//
//  UIStackView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/15.
//

import UIKit

extension UIStackView {
    
    func addDashedBorder(frameSize: CGSize, borderColor: UIColor) {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let shapeRect = CGRect(x: 0,
                               y: 0,
                               width: frameSize.width,
                               height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 8).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}
