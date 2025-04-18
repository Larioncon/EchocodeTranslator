//
//  AudioService.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 18/04/2025.
//

import AVFoundation

class AudioService {
    
    // MARK: - Properties
    private var audioRecorder: AVAudioRecorder?
    private var audioLevelTimer: Timer?
    private var isRecording = false
    private var isSoundDetected = false
    private let soundThreshold: Float
    
    // Closures for event handling
    var onSoundDetected: (() -> Void)?
    var onSilenceDetected: (() -> Void)?
    var onRecordingFinished: ((URL?) -> Void)?
    var onPermissionDenied: (() -> Void)?
    var onRecordingStarted: (() -> Void)?
    
    // MARK: - Initialization
    init(soundThreshold: Float = -45.0) {
        self.soundThreshold = soundThreshold
    }
    
    // MARK: - Public Methods
    func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    func checkMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied, .undetermined:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if !granted {
                    print("Microphone permission denied")
                    self.onPermissionDenied?()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            print("Recording started, metering enabled: \(audioRecorder?.isMeteringEnabled ?? false)")
            onRecordingStarted?()
            startAudioLevelMonitoring()
            
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
            isRecording = false
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        stopAudioLevelMonitoring()
        
        let recordingURL = audioRecorder?.url
        if let url = recordingURL {
            print("Recording saved at: \(url)")
        }
        
        audioRecorder = nil
        isRecording = false
        
        onRecordingFinished?(recordingURL)
    }
    
    private func startAudioLevelMonitoring() {
        audioLevelTimer?.invalidate()
        audioLevelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let recorder = self.audioRecorder, recorder.isRecording else {
                print("Recorder not active, stopping monitoring")
                self?.stopAudioLevelMonitoring()
                return
            }
            
            recorder.updateMeters()
            let averagePower = recorder.averagePower(forChannel: 0)
            print("Audio level: \(averagePower) dB")
            
            let isSoundNow = averagePower > self.soundThreshold
            
            if isSoundNow && !self.isSoundDetected {
                print("Sound detected")
                self.onSoundDetected?()
                self.isSoundDetected = true
            } else if !isSoundNow && self.isSoundDetected {
                print("Silence detected")
                self.onSilenceDetected?()
                self.isSoundDetected = false
            }
        }
    }
    
    private func stopAudioLevelMonitoring() {
        audioLevelTimer?.invalidate()
        audioLevelTimer = nil
        isSoundDetected = false
        print("Audio level monitoring stopped")
    }
}
