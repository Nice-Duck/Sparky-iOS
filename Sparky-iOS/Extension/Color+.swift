//
//  Color+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/09/25.
//

import UIKit

extension UIColor {
    
    static let sparkyWhite: UIColor = UIColor(named: "sparkyWhite")!
    static let sparkyBlack: UIColor = UIColor(named: "sparkyBlack")!
    static let sparkyOrange: UIColor = UIColor(named: "sparkyOrange")!
    static let sparkyBlue: UIColor = UIColor(named: "sparkyBlue")!
    static let colorchip1: UIColor = UIColor(named: "colorchip1")!
    static let colorchip2: UIColor = UIColor(named: "colorchip2")!
    static let colorchip3: UIColor = UIColor(named: "colorchip3")!
    static let colorchip4: UIColor = UIColor(named: "colorchip4")!
    static let colorchip5: UIColor = UIColor(named: "colorchip5")!
    static let colorchip6: UIColor = UIColor(named: "colorchip6")!
    static let colorchip7: UIColor = UIColor(named: "colorchip7")!
    static let colorchip8: UIColor = UIColor(named: "colorchip8")!
    static let colorchip9: UIColor = UIColor(named: "colorchip9")!
    static let colorchip10: UIColor = UIColor(named: "colorchip10")!
    static let colorchip11: UIColor = UIColor(named: "colorchip11")!
    static let colorchip12: UIColor = UIColor(named: "colorchip12")!
    static let background: UIColor = UIColor(named: "background")!
    static let background2: UIColor = UIColor(named: "background2")!
    static let gray100: UIColor = UIColor(named: "gray100")!
    static let gray200: UIColor = UIColor(named: "gray200")!
    static let gray300: UIColor = UIColor(named: "gray300")!
    static let gray400: UIColor = UIColor(named: "gray400")!
    static let gray500: UIColor = UIColor(named: "gray500")!
    static let gray600: UIColor = UIColor(named: "gray600")!
    static let gray700: UIColor = UIColor(named: "gray700")!
    static let gray800: UIColor = UIColor(named: "gray800")!
    static let gray900: UIColor = UIColor(named: "gray900")!
    
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  alpha: alpha)
    }
    
    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }
    
    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                  alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
    
    static func hexColorFromString(_ hexString: String) -> UIColor {
        let newHex = Int(hexString.replacingOccurrences(of: "#", with: "0x")) ?? 0xFFDDDA
        return UIColor(
            red: CGFloat((Float((newHex & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((newHex & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((newHex & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
    
    static func randomHexColor() -> UIColor {
        let colorList: [Int] = [
            0xFFDDDA,
            0xFFE8D3,
            0xFFFDCC,
            0xD8F5D6,
            0xD5E7E0,
            0xDFF1F5,
            0xD5DBEB,
            0xE5DDF3,
            0xF1E0EB,
            0xE5DBE0,
            0xFFE6F7,
            0xDFDFDF
        ]
        return UIColor(
            red: CGFloat((Float((colorList.randomElement() ?? 0xFFDDDA & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((colorList.randomElement() ?? 0xFFDDDA & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((colorList.randomElement() ?? 0xFFDDDA & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
    
    static func randomHexString() -> String {
        let colorList: [String] = [
            "#FFDDDA",
            "#FFE8D3",
            "#FFFDCC",
            "#D8F5D6",
            "#D5E7E0",
            "#DFF1F5",
            "#D5DBEB",
            "#E5DDF3",
            "#F1E0EB",
            "#E5DBE0",
            "#FFE6F7",
            "#DFDFDF"
        ]
        return colorList.randomElement() ?? "#FFDDDA"
    }
    
    func hexStringFromColor() -> String? {
        print("cgColor - \(self.cgColor)")
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print("hexString - \(hexString)")
        
        let newHexString = "#" + String(Array(hexString)[7...13])
        print("newHexString - \(newHexString)")
        
        return newHexString
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        let newColorString = NSString(format:"#%06x", rgb) as String
        print("newColorString - \(newColorString)")
        return newColorString
    }
}
