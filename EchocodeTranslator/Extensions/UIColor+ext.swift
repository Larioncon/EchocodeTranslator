//
//  UIColor+ext.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

extension UIColor {
    static let colorGreenGradient = UIColor(hex: "#C9FFE0")
    static let colorWhiteGradient = UIColor(hex: "#F3F5F6")
    static let colorBlack = UIColor(hex: "#292D32")
    static let colorDogBG = UIColor(hex: "#ECFBC7")
    static let colorCatBG = UIColor(hex: "#D1E7FC")
    static let colorShadow = UIColor(hex: "#373E7D", alpha: 0.15)
    static let colorMsgBG = UIColor(hex: "#D6DCFF")
    
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat? = nil) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        let finalAlpha = alpha ?? 1.0  
        self.init(red: red, green: green, blue: blue, alpha: finalAlpha)
    }
}

