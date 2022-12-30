//
//  Image+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/25.
//

import UIKit

extension UIImage {
    
    static let addScrap: UIImage = UIImage(named: "addScrap")!
    static let addURL: UIImage = UIImage(named: "addURL")!
    static let back: UIImage = UIImage(named: "back")!
    static let ban: UIImage = UIImage(named: "ban")!
    static let check: UIImage = UIImage(named: "check")!
    static let clear: UIImage = UIImage(named: "clear")!
    static let delete: UIImage = UIImage(named: "delete")!
    static let edit: UIImage = UIImage(named: "edit")!
    static let ellipse5: UIImage = UIImage(named: "ellipse5")!
    static let folder: UIImage = UIImage(named: "folder")!
    static let formatListBulleted: UIImage = UIImage(named: "formatListBulleted")!
    static let home: UIImage = UIImage(named: "home")!
    static let logo: UIImage = UIImage(named: "logo")!
    static let plus: UIImage = UIImage(named: "plus")!
    static let profile: UIImage = UIImage(named: "profile")!
    static let rightChevron: UIImage = UIImage(named: "rightChevron")!
    static let search: UIImage = UIImage(named: "search")!
    static let searchDisable: UIImage = UIImage(named: "searchDisable")!
    static let vector: UIImage = UIImage(named: "vector")!
    static let vector1: UIImage = UIImage(named: "vector1")!
    static let vector971: UIImage = UIImage(named: "vector971")!
    static let viewAgenda: UIImage = UIImage(named: "viewAgenda")!
    
    func setSize(newSize: CGSize) {
        
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
