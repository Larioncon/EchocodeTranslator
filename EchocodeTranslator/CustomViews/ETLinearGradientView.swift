//
//  ETLinearGradientView.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

class ETLinearGradientView: UIView {
    
    let topColor: UIColor = UIColor.colorWhiteGradient
    
    let bottomColor: UIColor = UIColor.colorGreenGradient
    
    let gradientLayer = CAGradientLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer.frame != bounds {
            gradientLayer.frame = bounds
        }
    }
}
