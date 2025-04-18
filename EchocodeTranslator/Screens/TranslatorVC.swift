//
//  TranslatorVC.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit
import AVFoundation
import Lottie

enum Pet: String {
    case cat
    case dog
}

class TranslatorVC: UIViewController {
    
    private let someTranslations = Translations.petTranslations
    private var selectedTranslation: String?
    
    private var isPetTalking = true
    private var selectedPet: Pet = .dog
    private var catOverlayView = UIView()
    private var dogOverlayView = UIView()
    private var iconTopConstraint: NSLayoutConstraint?
    
    // Audio recording service
    private lazy var audioService = AudioService()
    
    //  Wave Animation
    private var waveAnimationView = LottieAnimationView()
    
    private var viewBuilder = ViewBuilder()
    
    // MARK: - Header Text
    private let headerTitle = ETLabel(textColor: .colorBlack, fontSize: 32, text: "Translator", weight: .regular, fontName: "KonkhmerSleokchher-Regular", textAlignment: .center)
    
    // MARK: - Switcher Human/Pet
    private lazy var switchContainer = viewBuilder.createStack(axis: .horizontal, alignment: .center, spacing: 8)
    private let leftLabel = ETLabel(textColor: .colorBlack, fontSize: 16, text: "PET", weight: .regular, fontName: "KonkhmerSleokchher-Regular", textAlignment: .center, contentMode: .center)
    private let rightLabel = ETLabel(textColor: .colorBlack, fontSize: 16, text: "HUMAN", weight: .regular, fontName: "KonkhmerSleokchher-Regular", textAlignment: .center, contentMode: .center)
    
    private let switchButton: UIButton = {
        let button = UIButton(type: .system)
        if let img = UIImage(named: "arrow-swap") {
            button.setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .colorBlack
        } else {
            button.setTitle("⇄", for: .normal)
            button.setTitleColor(.colorBlack, for: .normal)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return button
    }()
    
    // MARK: - Voice interaction panel and animal selection
    private lazy var voiceInteractionPanelStack = viewBuilder.createStack(axis: .horizontal, alignment: .center, spacing: 35)
    
    private lazy var recorderView: UIControl = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(recorderTapped), for: .touchUpInside)
        return $0
    }(UIControl())
    
    private lazy var iconRecView: UIImageView = {
        $0.image = UIImage(named: "microIcon")
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var recorderTitle = ETLabel(textColor: .colorBlack, fontSize: 16, text: "Start Speak", weight: .regular, fontName: "KonkhmerSleokchher-Regular", textAlignment: .center, contentMode: .center)
    
    private var animalSelection: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        return $0
    }(UIView())
    
    private lazy var catBtnSelection: UIButton = {
        $0.setImage(UIImage(named: "catImgBtn"), for: .normal)
        $0.backgroundColor = .colorCatBG
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(catTapped), for: .touchUpInside)
        let overlayView = UIView(frame: $0.bounds)
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.isUserInteractionEnabled = false
        $0.addSubview(overlayView)
        self.catOverlayView = overlayView
        return $0
    }(UIButton())
    
    private lazy var dogBtnSelection: UIButton = {
        $0.setImage(UIImage(named: "dogImgBtn"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .colorDogBG
        $0.addTarget(self, action: #selector(dogTapped), for: .touchUpInside)
        let overlayView = UIView(frame: $0.bounds)
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.isUserInteractionEnabled = false
        $0.addSubview(overlayView)
        self.dogOverlayView = overlayView
        return $0
    }(UIButton())
    
    // MARK: - Animal image at the bottom of the screen
    private lazy var bigPetImg: UIImage = {
        return UIImage(named: "bigDogImg") ?? UIImage()
    }()
    
    private lazy var bigPetImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = bigPetImg
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = ETLinearGradientView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        setupAudioService()
        setActions()
        setupLottieView(animationName: "waveLottie")
        audioService.requestMicrophonePermission()
    }
    
    // MARK: - Setup Methods
    
    private func configureLayout() {
        // Layout code remains the same
        [headerTitle, switchContainer, voiceInteractionPanelStack, bigPetImgView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [leftLabel, switchButton, rightLabel].forEach {
            switchContainer.addArrangedSubview($0)
        }
        
        [recorderView, animalSelection].forEach {
            voiceInteractionPanelStack.addArrangedSubview($0)
        }
        
        [iconRecView, recorderTitle].forEach {
            recorderView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [catBtnSelection, dogBtnSelection].forEach {
            animalSelection.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let iconTopOffset = recorderView.frame.height / 4
        iconTopConstraint = iconRecView.topAnchor.constraint(equalTo: recorderView.topAnchor, constant: iconTopOffset)
        iconTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            switchContainer.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 12),
            switchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            leftLabel.widthAnchor.constraint(equalToConstant: 135),
            leftLabel.heightAnchor.constraint(equalToConstant: 65),
            switchButton.heightAnchor.constraint(equalToConstant: 24),
            switchButton.widthAnchor.constraint(equalToConstant: 24),
            rightLabel.widthAnchor.constraint(equalToConstant: 135),
            rightLabel.heightAnchor.constraint(equalToConstant: 65),
            
            voiceInteractionPanelStack.topAnchor.constraint(equalTo: switchContainer.bottomAnchor, constant: 30),
            voiceInteractionPanelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            recorderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.453),
            recorderView.heightAnchor.constraint(equalTo: recorderView.widthAnchor, multiplier: 0.988),
            
            animalSelection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2724),
            animalSelection.heightAnchor.constraint(equalTo: recorderView.heightAnchor),
            animalSelection.widthAnchor.constraint(equalToConstant: 107),
            animalSelection.heightAnchor.constraint(equalTo: recorderView.heightAnchor),
            
            iconRecView.centerXAnchor.constraint(equalTo: recorderView.centerXAnchor),
            recorderTitle.centerXAnchor.constraint(equalTo: recorderView.centerXAnchor),
            recorderTitle.bottomAnchor.constraint(equalTo: recorderView.bottomAnchor, constant: -10),
            
            catBtnSelection.topAnchor.constraint(equalTo: animalSelection.topAnchor, constant: 12),
            catBtnSelection.leadingAnchor.constraint(equalTo: animalSelection.leadingAnchor, constant: 12),
            catBtnSelection.trailingAnchor.constraint(equalTo: animalSelection.trailingAnchor, constant: -12),
            catBtnSelection.heightAnchor.constraint(equalTo: dogBtnSelection.heightAnchor),
            
            dogBtnSelection.topAnchor.constraint(equalTo: catBtnSelection.bottomAnchor, constant: 12),
            dogBtnSelection.bottomAnchor.constraint(equalTo: animalSelection.bottomAnchor, constant: -12),
            dogBtnSelection.leadingAnchor.constraint(equalTo: animalSelection.leadingAnchor, constant: 12),
            dogBtnSelection.trailingAnchor.constraint(equalTo: animalSelection.trailingAnchor, constant: -12),
            
            bigPetImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigPetImgView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            bigPetImgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -122)
        ])
        
        catBtnSelection.isSelected = false
        dogBtnSelection.isSelected = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let newIconTopOffset = recorderView.frame.height / 4
        iconTopConstraint?.constant = newIconTopOffset
    }
    
    private func setupAudioService() {
        // Setup event handlers for audio service
        audioService.onRecordingStarted = { [weak self] in
            guard let self = self else { return }
            self.iconRecView.isHidden = true
            self.waveAnimationView.isHidden = false
            self.recorderTitle.text = "Recording..."
        }
        
        audioService.onSoundDetected = { [weak self] in
            guard let self = self else { return }
            self.selectedTranslation = self.someTranslations.randomElement() ?? "Something was said!"
            self.waveAnimationView.animationSpeed = -1.0 // Play backward
            self.waveAnimationView.play()
        }
        
        audioService.onSilenceDetected = { [weak self] in
            guard let self = self else { return }
            self.waveAnimationView.stop()
            self.waveAnimationView.currentProgress = 1.0 // Static at end
        }
        
        audioService.onRecordingFinished = { [weak self] _ in
            guard let self = self else { return }
            // Reset UI
            self.waveAnimationView.stop()
            self.waveAnimationView.currentProgress = 1.0
            self.waveAnimationView.isHidden = true
            self.iconRecView.isHidden = false
            self.recorderTitle.text = "Start Speak"
            
            // Present result view controller
            if let translation = self.selectedTranslation {
                let vc = ETResultVC(
                    textMsg: translation,
                    selectedPet: self.selectedPet,
                    isSoundDetected: true
                )
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: false)
            } else {
                let vc = ETResultVC(
                    textMsg: "mew-mew",
                    selectedPet: self.selectedPet,
                    isSoundDetected: false
                )
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: false)
            }
            
            // Reset translation for the next recording
            self.selectedTranslation = nil
        }
        
        audioService.onPermissionDenied = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(
                title: "Enable Microphone Access",
                message: "Please allow access to your microphone to use the app's features",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setActions() {
        switchButton.addTarget(self, action: #selector(switchLabels), for: .touchUpInside)
        updateSelectionUI()
        viewBuilder.configureShadow(for: animalSelection)
        viewBuilder.configureShadow(for: recorderView)
        
    }
    
    private func setupLottieView(animationName: String) {
        waveAnimationView.translatesAutoresizingMaskIntoConstraints = false
        recorderView.addSubview(waveAnimationView)
        waveAnimationView.isHidden = true
        if let animation = LottieAnimation.named(animationName) {
            waveAnimationView.animation = animation
            print("Lottie animation loaded successfully: \(animationName)")
        } else {
            print("Failed to load Lottie animation: \(animationName)")
        }
        waveAnimationView.loopMode = .loop
        waveAnimationView.isUserInteractionEnabled = false
        waveAnimationView.currentProgress = 1.0
        NSLayoutConstraint.activate([
            waveAnimationView.heightAnchor.constraint(equalToConstant: 90),
            waveAnimationView.widthAnchor.constraint(equalToConstant: 135),
            waveAnimationView.centerXAnchor.constraint(equalTo: recorderView.centerXAnchor),
            waveAnimationView.centerYAnchor.constraint(equalTo: recorderView.centerYAnchor),
        ])
    }
    
    // MARK: - Action Methods
    
    @objc func catTapped() {
        selectedPet = .cat
        catBtnSelection.isSelected = true
        dogBtnSelection.isSelected = false
        bigPetImg = UIImage(named: "bigCatImg") ?? UIImage()
        bigPetImgView.image = bigPetImg
        updateSelectionUI()
    }
    
    @objc func dogTapped() {
        selectedPet = .dog
        catBtnSelection.isSelected = false
        dogBtnSelection.isSelected = true
        bigPetImg = UIImage(named: "bigDogImg") ?? UIImage()
        bigPetImgView.image = bigPetImg
        updateSelectionUI()
    }
    
    @objc private func recorderTapped() {
        if isPetTalking {
            audioService.checkMicrophonePermission { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.audioService.toggleRecording()
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Microphone Access Required",
                            message: "Please enable microphone access in Settings to start recording.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(
                title: "Language Mismatch",
                message: "Please switch the translation direction. We can't translate from human to pet yet.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func switchLabels() {
        isPetTalking.toggle()
        UIView.transition(with: leftLabel, duration: 0.2, options: .transitionCrossDissolve) {
            self.leftLabel.text = self.isPetTalking ? "PET" : "HUMAN"
        }
        UIView.transition(with: rightLabel, duration: 0.2, options: .transitionCrossDissolve) {
            self.rightLabel.text = self.isPetTalking ? "HUMAN" : "PET"
        }
    }
    
    private func updateSelectionUI() {
        catOverlayView.isHidden = catBtnSelection.isSelected
        dogOverlayView.isHidden = dogBtnSelection.isSelected
    }
    
}
