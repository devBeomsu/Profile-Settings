//
//  CustomView.swift
//  01_Portfolio
//
//  Created by Raphael Shim on 2023/03/29.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var hasShadow: Bool = false {
        didSet {
            if hasShadow {
                layer.applyShadow()
            }
        }
    }
}
