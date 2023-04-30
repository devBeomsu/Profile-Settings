//
//  CustomButton.swift
//  01_Portfolio
//
//  Created by Raphael Shim on 2023/03/29.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable
    // cornerRadius 프로퍼티가 변경될 때마다, 버튼의 레이어의 cornerRadius 값을 업데이트
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
