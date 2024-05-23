//
//  UIBezierPath+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/17/24.
//

import UIKit

/// 코너마다 radius를 다르게 줄 수 있는 extension
extension UIBezierPath {
    
    // path가 그려지는 순서: leftTop -> rightTop -> rightBottom -> leftBottom -> leftTop
    
    convenience init(for bounds: CGRect, leftTopSize: CGSize = .zero, rightTopSize: CGSize = .zero, leftBottomSize: CGSize = .zero, rightBottomSize: CGSize = .zero) {
        self.init()

        let path = CGMutablePath()

        let leftTop: CGPoint = bounds.origin
        let rightTop: CGPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
        let leftBottom: CGPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
        let rightBottom: CGPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)

        if leftTopSize != .zero {
            // 1️⃣
            path.move(to: CGPoint(x: leftTop.x + leftTopSize.width, y: leftTop.y))
        } else {
            path.move(to: leftTop)
        }

        if rightTopSize != .zero {
            // 2️⃣
            path.addLine(to: CGPoint(x: rightTop.x - rightTopSize.width, y: rightTop.y))
            // 3️⃣
            path.addCurve(to: CGPoint(x: rightTop.x, y: rightTop.y + rightTopSize.height), control1: CGPoint(x: rightTop.x, y: rightTop.y), control2: CGPoint(x: rightTop.x, y: rightTop.y + rightTopSize.height))
        } else {
            path.addLine(to: rightTop)
        }

        if rightBottomSize != .zero {
            // 4️⃣
            path.addLine(to: CGPoint(x: rightBottom.x, y: rightBottom.y - rightBottomSize.height))
            // 5️⃣
            path.addCurve(to: CGPoint(x: rightBottom.x - rightBottomSize.width, y: rightBottom.y), control1: CGPoint(x: rightBottom.x, y: rightBottom.y), control2: CGPoint(x: rightBottom.x - rightBottomSize.width, y: rightBottom.y))
        } else {
            path.addLine(to: rightBottom)
        }

        if leftBottomSize != .zero {
            // 6️⃣
            path.addLine(to: CGPoint(x: leftBottom.x + leftBottomSize.width, y: leftBottom.y))
            // 7️⃣
            path.addCurve(to: CGPoint(x: leftBottom.x, y: leftBottom.y - leftBottomSize.height), control1: CGPoint(x: leftBottom.x, y: leftBottom.y), control2: CGPoint(x: leftBottom.x, y: leftBottom.y - leftBottomSize.height))
        } else {
            path.addLine(to: leftBottom)
        }

        if leftTopSize != .zero {
            // 8️⃣
            path.addLine(to: CGPoint(x: leftTop.x, y: leftTop.y + leftTopSize.height))
            // 9️⃣
            path.addCurve(to: CGPoint(x: leftTop.x + leftTopSize.width, y: leftTop.y), control1: CGPoint(x: leftTop.x, y: leftTop.y), control2: CGPoint(x: leftTop.x + leftTopSize.width, y: leftTop.y))
        } else {
            path.addLine(to: leftTop)
        }

        path.closeSubpath()
        cgPath = path
    }
}
