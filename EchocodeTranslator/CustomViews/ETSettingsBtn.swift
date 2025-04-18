//
//  ETSettingsBtn.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

class ETSettingsBtn: UIControl {
    
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String) {
        self.backgroundColor = .colorMsgBG
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
       
        titleLabel.text = title
        titleLabel.textColor = .colorBlack
        titleLabel.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 16) ?? .systemFont(ofSize: 16)
        
    
        iconView.image = UIImage(named: "chevron-right")
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor.colorBlack
  
        addSubview(titleLabel)
        addSubview(iconView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 7),
            iconView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        
        addTarget(self, action: #selector(animateDown), for: [.touchDown])
        addTarget(self, action: #selector(animateUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.05) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.7
        }
    }
    
    @objc private func animateUp() {
        UIView.animate(withDuration: 0.10) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
