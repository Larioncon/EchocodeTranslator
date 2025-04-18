//
//  ETResultVC.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

class ETResultVC: UIViewController {
    private var viewBuilder = ViewBuilder()
    // MARK: - Props
    private let textMsg: String
    private let isSoundDetected: Bool
    private let selectedPet: Pet
    
    // MARK: - Init
    init(textMsg: String, selectedPet: Pet, isSoundDetected: Bool) {
        self.textMsg = textMsg
        self.selectedPet = selectedPet
        self.isSoundDetected = isSoundDetected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Header Text
    private let headerTitle = ETLabel(
        textColor: .colorBlack,
        fontSize: 32,
        text: "Result",
        weight: .regular,
        fontName: "KonkhmerSleokchher-Regular",
        textAlignment: .center
    )
    
    // MARK: - Close Button
    private lazy var closeBtn: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "closeBtn")
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Translation Message View
    private lazy var msgView: ETSpeechBubbleView = {
        let view = ETSpeechBubbleView()
        view.addSubview(translationMsg)
        return view
    }()
    
    private lazy var translationMsg = ETLabel(
        textColor: .colorBlack,
        fontSize: 12,
        text: textMsg,
        weight: .regular,
        fontName: "KonkhmerSleokchher-Regular",
        textAlignment: .center,
        contentMode: .center
    )
    
    
    // MARK: - Repeat Button
    private lazy var repeatBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .colorMsgBG
        button.layer.cornerRadius = 16
        
        let repeatIcon = UIImageView(image: UIImage(named: "repeatIcon"))
        repeatIcon.contentMode = .scaleAspectFit
        repeatIcon.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(repeatIcon)
        
        let repeatLabel = ETLabel(
            textColor: .colorBlack,
            fontSize: 12,
            text: "Repeat",
            weight: .regular,
            fontName: "KonkhmerSleokchher-Regular",
            textAlignment: .center,
            contentMode: .center
        )
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(repeatLabel)
        
        NSLayoutConstraint.activate([
            repeatLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            repeatLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            repeatIcon.trailingAnchor.constraint(equalTo: repeatLabel.leadingAnchor, constant: -12),
            repeatIcon.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(animateDown), for: [.touchDown])
        button.addTarget(self, action: #selector(animateUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Pet Image View
    private lazy var bigPetImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bigDogImg") ?? UIImage()
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
        updateViewBasedOnSoundDetection()
        updatePetImage()
        viewBuilder.configureShadow(for: repeatBtn)
    }
    
    // MARK: - Layout
    private func configureLayout() {
        [headerTitle, closeBtn, msgView, repeatBtn, bigPetImgView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeBtn.centerYAnchor.constraint(equalTo: headerTitle.centerYAnchor),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeBtn.heightAnchor.constraint(equalToConstant: 48),
            closeBtn.widthAnchor.constraint(equalTo: closeBtn.heightAnchor),
            
            msgView.bottomAnchor.constraint(equalTo: bigPetImgView.topAnchor, constant: -125),
            msgView.heightAnchor.constraint(equalToConstant: 142),
            msgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            msgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            repeatBtn.bottomAnchor.constraint(equalTo: bigPetImgView.topAnchor, constant: -125),
            repeatBtn.heightAnchor.constraint(equalToConstant: 54),
            repeatBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            repeatBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            translationMsg.centerXAnchor.constraint(equalTo: msgView.centerXAnchor),
            translationMsg.centerYAnchor.constraint(equalTo: msgView.centerYAnchor),
            
            bigPetImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigPetImgView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            bigPetImgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -122)
        ])
    }
    
    // MARK: - Update UI
    private func updateViewBasedOnSoundDetection() {
        msgView.isHidden = !isSoundDetected
        repeatBtn.isHidden = isSoundDetected
    }
    
    private func updatePetImage() {
        switch selectedPet {
        case .cat:
            bigPetImgView.image = UIImage(named: "bigCatImg") ?? UIImage()
        case .dog:
            bigPetImgView.image = UIImage(named: "bigDogImg") ?? UIImage()
        }
    }
    
    // MARK: - close and repeat action
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Button Animations
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.05) {
            self.repeatBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.repeatBtn.alpha = 0.7
        }
    }
    
    @objc private func animateUp() {
        UIView.animate(withDuration: 0.10) {
            self.repeatBtn.transform = .identity
            self.repeatBtn.alpha = 1.0
        }
    }
}
