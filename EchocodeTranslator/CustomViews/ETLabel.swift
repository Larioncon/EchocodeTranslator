//
//  ETLabel.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

class ETLabel: UILabel {
    
    init(
        textColor: UIColor,
        fontSize: CGFloat,
        text: String,
        weight: UIFont.Weight,
        fontName: String,
        textAlignment: NSTextAlignment,
        contentMode: UIView.ContentMode? = nil
    ) {
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let contentMode = contentMode {
            self.contentMode = contentMode
        }

        if let customFont = UIFont(name: fontName, size: fontSize) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
