//
//  ETSpeechBubbleView.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit

class ETSpeechBubbleView: UIView {
    private let bubbleLayer = CAShapeLayer()
    private let tailLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .colorMsgBG
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.colorShadow.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 14
        clipsToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawTail()
    }

    private func drawTail() {
        tailLayer.removeFromSuperlayer()
        
       
        let tailWidth: CGFloat = 12
        let tailHeight: CGFloat = 125
        
        // Tail base placed closer to the right edge
        let tailStartX = bounds.width - 24
        let tailStartY = bounds.height
        
        // Create the path for the tail
        let tailPath = UIBezierPath()
        
        // Starting point on the bubble border
        tailPath.move(to: CGPoint(x: tailStartX, y: tailStartY))
        
        // Left point of the tail base
        tailPath.addLine(to: CGPoint(x: tailStartX - tailWidth/2, y: tailStartY))
        
      
        let tipOffsetX: CGFloat = -tailHeight * 0.5 // Shift left to point at 7 o'clock
        let tipOffsetY: CGFloat = tailHeight * 0.866 // Vertical offset downward
        tailPath.addLine(to: CGPoint(x: tailStartX + tipOffsetX, y: tailStartY + tipOffsetY))
        
        // Right point of the tail base
        tailPath.addLine(to: CGPoint(x: tailStartX + tailWidth/2, y: tailStartY))
        
        tailPath.close()
        
        tailLayer.path = tailPath.cgPath
        tailLayer.fillColor = UIColor.colorMsgBG.cgColor
        tailLayer.shadowColor = UIColor.colorShadow.cgColor
        tailLayer.shadowOpacity = 1
        tailLayer.shadowOffset = CGSize(width: 0, height: 0)
        tailLayer.shadowRadius = 8
        
        layer.addSublayer(tailLayer)
        
        // Debug info
        print("Bubble bounds: \(bounds), Tail position: \(tailStartX), \(tailStartY)")
    }
}
