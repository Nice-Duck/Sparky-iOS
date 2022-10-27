//
//  BehaviorRelay+.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/24.
//

import RxRelay

extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    var values: Element {
        set {
            let newValue = newValue
            accept(newValue)
        }
        
        get {
            return value
        }
    }
    
    public func append(_ subElement: Element.Element) {
        var newValue = value
        newValue.append(subElement)
        accept(newValue)
    }
    
    public func insert(_ subElement: Element.Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(subElement, at: index)
        accept(newValue)
    }

    public func remove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
    
//    func convertNoneType(tagList: [Tag]) -> [Tag] {
//        var newTagList = tagList
//        if newTagList[newTagList.count - 1].buttonType == .add { newTagList.removeLast() }
//        
//        for i in 0..<newTagList.count {
//            newTagList[i] = Tag(text: newTagList[i].text,
//                             backgroundColor: newTagList[i].backgroundColor,
//                             buttonType: .none)
//        }
//        return newTagList
//    }
//
//    func convertDeleteType(tagList: [Tag]) -> [Tag] {
//        var newTagList = tagList
//        for i in 0..<newTagList.count {
//            newTagList[i] = Tag(text: newTagList[i].text,
//                             backgroundColor: newTagList[i].backgroundColor,
//                             buttonType: .none)
//        }
//        
//        let addButtonTag = Tag(text: "태그추가",
//                               backgroundColor: .clear,
//                               buttonType: .add)
//        newTagList.append(addButtonTag)
//        return newTagList
//    }
}
