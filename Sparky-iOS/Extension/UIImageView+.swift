//
//  ImageView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/31.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url)
            self.contentMode = .scaleToFill
        }
    }
}
