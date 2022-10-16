//
//  SparkyNavBar.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/16.
//

import UIKit

class SparkyNavBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            subview.frame = ({
                frame.origin.y = (self.frame.size.height - subview.frame.size.height) / 2
                return frame;
            })()
        }
    }
}
