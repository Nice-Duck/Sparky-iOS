//
//  UIView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/11/10.
//

import UIKit

extension UIView {
//
//    func setKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification) {
//          if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                  let keyboardRectangle = keyboardFrame.cgRectValue
//                  let keyboardHeight = keyboardRectangle.height
//              UIView.animate(withDuration: 1) {
//                  self.frame.origin.y -= keyboardHeight
////                  self.layoutIfNeeded()
////                  self.layoutSubviews()
//              }
//          } else { }
//      }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.frame.origin.y != 0 {
//            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                    let keyboardRectangle = keyboardFrame.cgRectValue
//                    let keyboardHeight = keyboardRectangle.height
//                UIView.animate(withDuration: 1) {
//                    print("button y - \(self.frame.origin.y)")
//                    print("keyboard height - \(keyboardHeight)")
//                    self.frame.origin.y += keyboardHeight
////                    self.layoutIfNeeded()
////                    self.layoutSubviews()
//                }
//            }
//        } else { print("타긴타냐?") }
//    }
}
