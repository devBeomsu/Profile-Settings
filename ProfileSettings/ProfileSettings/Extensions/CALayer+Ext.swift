//
//  CALayer+Ext.swift
//  01_Portfolio
//
//  Created by Raphael Shim on 2023/03/29.
//

import Foundation
import UIKit

extension CALayer {
    /// 그림자 적용
    /// - Parameters:
    ///   - color: 그림자 색
    ///   - alpha: 투명도
    ///   - x: 가로 위치
    ///   - y: 세로 위치
    ///   - blur: 블러
    ///   - spread: 퍼짐 정도
    func applyShadow(
        color: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8),
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 4,
        blur: CGFloat = 10,
        spread: CGFloat = 0
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
