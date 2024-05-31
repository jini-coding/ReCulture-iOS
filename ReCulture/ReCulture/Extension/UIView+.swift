//
//  UIView+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/17/24.
//

import UIKit

extension UIView {
    
    /// UIView의 각 corner에 다른 radius 값을 줄 수 있는 함수
    /// - Parameters:
    ///   - leftTop: 위의 왼쪽 radius 값
    ///   - rightTop: 위의 오른쪽 radius 값
    ///   - leftBottom: 아래의 왼쪽 radius 값
    ///   - rightBottom: 아래의 오른쪽 radius 값
    func radiusCorners(leftTop: CGFloat = 0, rightTop: CGFloat = 0, leftBottom: CGFloat = 0, rightBottom: CGFloat = 0) {
        let leftTopSize = CGSize(width: leftTop, height: leftTop)
        let rightTopSize = CGSize(width: rightTop, height: rightTop)
        let leftBottomSize = CGSize(width: leftBottom, height: leftBottom)
        let rightBottomSize = CGSize(width: rightBottom, height: rightBottom)
        let maskedPath = UIBezierPath(for: self.bounds, leftTopSize: leftTopSize, rightTopSize: rightTopSize, leftBottomSize: leftBottomSize, rightBottomSize: rightBottomSize)

        let shape = CAShapeLayer()
        shape.path = maskedPath.cgPath
        self.layer.mask = shape
    }
    
    /// uiview에 corner radius가 적용된 점선 테두리 적용
    /// - Parameters:
    ///   - color: 테두리로 그릴 UIColor
    ///   - radius: 테두리에 적용한 corner radius 값
    func setDotLineWithCornerRadius(color: UIColor, radius: CGFloat){
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = color.cgColor
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.lineDashPattern = [3, 3]
        borderLayer.lineWidth = 2
        borderLayer.frame = self.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath

        self.layer.addSublayer(borderLayer)
    }
}
