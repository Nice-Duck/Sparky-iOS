//
//  ImageView+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/31.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setupImageView(frameSize: CGSize, url: URL?) {
        let processor = DownsamplingImageProcessor(size: frameSize)
        self.kf.setImage(with: url,
                              placeholder: UIImage(named: "vector"),
                              options: [
                                .processor(processor),
                                .loadDiskFileSynchronously,
                                .cacheOriginalImage,
                                .transition(.fade(0.25)),
                              ]) { result in
                                  switch result {
                                  case .success(let value):
                                      print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                  case .failure(let error):
                                      print("error: \(error)")
                                  }
                              }
    }
}
