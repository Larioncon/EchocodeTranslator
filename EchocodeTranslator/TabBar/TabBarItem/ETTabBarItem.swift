//
//  ETTabBarItem.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit


class ETTabBarItem: UIView {
    
    var tabItem: TabItem
    var imageRightConstraints: NSLayoutConstraint?
    var isActive: Bool {
        willSet {
            self.tabImage.tintColor = newValue ? .colorBlack : .gray
            self.tabText.textColor = newValue ? .colorBlack : .gray
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    var isSelected: (ETTabBarItem) -> Void
    
    lazy var contentView: UIView = {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToTab)))
        $0.addSubview(tabImage)
        $0.addSubview(tabText)
        return $0
    }(UIView())
    
    
    lazy var tabImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let systemImage = UIImage(systemName: tabItem.tabImage) {
            imageView.image = systemImage.withRenderingMode(.alwaysTemplate)
        } else if let customImage = UIImage(named: tabItem.tabImage) {
            imageView.image = customImage.withRenderingMode(.alwaysTemplate)
        } else {
            print("⚠️ Ошибка: Изображение \(tabItem.tabImage) не найдено")
            imageView.image = nil
        }

        imageView.tintColor = isActive ? .colorBlack : .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var tabText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = tabItem.tabText
        $0.textColor = isActive ? .colorBlack : .gray
        $0.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 12) ?? .systemFont(ofSize: 12)
        $0.textAlignment = .center // центрируем текст по горизонтали
        return $0
    }(UILabel())
    
    init(tabItem: TabItem, imageRightConstraints: NSLayoutConstraint? = nil, isActive: Bool, isSelected: @escaping (ETTabBarItem) -> Void) {
        self.tabItem = tabItem
        self.imageRightConstraints = imageRightConstraints
        self.isActive = isActive
        self.isSelected = isSelected
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageRightConstraints = tabImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            //contentView
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            //tabImage
            tabImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tabImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor), // центрируем изображение
            tabImage.heightAnchor.constraint(equalToConstant: 24), // задаем фиксированную высоту изображения
            tabImage.widthAnchor.constraint(equalToConstant: 24), // фиксированная ширина изображения
            
            //tabText
            tabText.topAnchor.constraint(equalTo: tabImage.bottomAnchor, constant: 4), // отступ от изображения
            tabText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor), // центрируем текст по горизонтали
            tabText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) // отступ снизу
        ])
    }
    
    @objc func tapToTab() {
        self.isSelected(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
