//
//  String+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/22.
//

import Foundation

extension String {
    func convertSpecialCharacters() -> String {
        var newString = self
        let characterDictionary = [
            "&amp;": "&",
//            "&lt;": "<",
//            "&gt;": ">",
//            "&quot;": "\"",
//            "&apos;": "'"
        ]
        
        for (escapedChar, unescapedChar) in characterDictionary {
            newString = self.replacingOccurrences(of: escapedChar, with: unescapedChar)
        }
        return newString
    }
}
