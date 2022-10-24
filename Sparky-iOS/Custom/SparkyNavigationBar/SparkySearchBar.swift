//
//  SparkyTextField.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/18.
//

import UIKit

class SparkyTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUnderLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUnderLine() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0,
                                   y: self.frame.height,
                                   width: self.frame.width,
                                   height: 1)
        bottomLayer.backgroundColor = UIColor.gray400.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
    func setupLeftImageView(image: UIImage) {
        self.leftViewMode = .always
        let leftImageView = UIImageView(frame: CGRect(x: 0,
                                                      y: self.frame.height / 2 - 10,
                                                      width: 16,
                                                      height: 16))
        leftImageView.tintColor = .gray400
        leftImageView.image = image
        self.addSubview(leftImageView)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: 24, y: bounds.size.height / 2 - 10, width: bounds.width, height: bounds.height)
        return bounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: 24, y: bounds.size.height / 2 - 10, width: bounds.width, height: bounds.height)
        return bounds
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = CGRect(x: 24, y: bounds.size.height / 2 - 10, width: bounds.width, height: bounds.height)
        return bounds
    }
}
