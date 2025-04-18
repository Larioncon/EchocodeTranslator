//
//  ViewBuilder.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit


class ViewBuilder {
    func createStack(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, spacing: CGFloat) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.alignment = alignment
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    func configureShadow(for view: UIView) {
        view.layer.shadowColor = UIColor.colorShadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 14
    }
    
}
