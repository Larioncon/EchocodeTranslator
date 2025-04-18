//
//  TabBar.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

class TabBar: UITabBarController {
    let tabModel = TabViewModel()
    
    
    lazy var tabView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.colorShadow.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 14
        $0.addSubview(tabViewStack)
        return $0
        
    }(UIView())
    lazy var tabViewStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 42
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
           return $0
       }(UIStackView())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.isHidden = true
        tabBar.isUserInteractionEnabled = false
        setViewControllers(tabModel.setupViewControllers(), animated: true)

        view.addSubview(tabView)
        setupTabBar(pages: tabModel.createTabItems())
        setConstraints()
      
    }
    private func setupTabBar(pages:[TabItem]) {
        pages.enumerated().forEach{ item in
            if item.offset == 0 {
                tabViewStack.addArrangedSubview(createOneTabItem(item: item.element, isFirst: true))
            } else {
                tabViewStack.addArrangedSubview(createOneTabItem(item: item.element))
            }
        }
    }
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 87),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -87),
            tabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            tabView.heightAnchor.constraint(equalToConstant: 82),
            
            tabViewStack.topAnchor.constraint(equalTo: tabView.topAnchor),
            tabViewStack.bottomAnchor.constraint(equalTo: tabView.bottomAnchor),
            
            tabViewStack.leadingAnchor.constraint(equalTo: tabView.leadingAnchor,constant: 4),
            tabViewStack.trailingAnchor.constraint(equalTo: tabView.trailingAnchor, constant: -4),
        ])

    }
    private func createOneTabItem(item: TabItem, isFirst: Bool = false) -> UIView {
        ETTabBarItem(tabItem: item, isActive: isFirst) { [weak self] selectedItem in
            guard let self = self else {return}
            self.tabViewStack.arrangedSubviews.forEach{
                guard let tabItem = $0 as? ETTabBarItem else {return}
                tabItem.isActive = false
            }
            selectedItem.isActive.toggle()
            self.selectedIndex = item.index
        }
    }

}

