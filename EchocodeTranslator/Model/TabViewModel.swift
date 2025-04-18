//
//  TabViewModel.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit


class TabViewModel {
    
    func setupViewControllers() -> [UIViewController] {
        let translatorVC = TranslatorVC()
        let settingsVC = SettingsVC()
    
        let tabItems = createTabItems()
        
        translatorVC.tabBarItem = createTabBarItem(for: tabItems[0])
        settingsVC.tabBarItem = createTabBarItem(for: tabItems[1])
        
        return [translatorVC, settingsVC]
    }
    
    
    func createTabItems() -> [TabItem] {
        return [
            TabItem(index: 0, tabText: "Translator", tabImage: "msgImg"),
            TabItem(index: 1, tabText: "Clicker", tabImage: "gearshape")
        ]
    }
    
    
    private func createTabBarItem(for tabItem: TabItem) -> UITabBarItem {
        let image: UIImage?
        
        if let sysImage = UIImage(systemName: tabItem.tabImage) {
            image = sysImage.withRenderingMode(.alwaysTemplate)
        } else {
            image = UIImage(named: tabItem.tabImage)?.withRenderingMode(.alwaysTemplate)
        }
        return UITabBarItem(title: tabItem.tabText, image: image, selectedImage: image)
    }
    
    
}
