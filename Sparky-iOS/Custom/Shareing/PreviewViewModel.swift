//
//  PreviewViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/21.
//

import SwiftLinkPreview

final class PreviewViewModel {
    
    let slp = SwiftLinkPreview(session: URLSession.shared,
                               workQueue: SwiftLinkPreview.defaultWorkQueue,
                               responseQueue: DispatchQueue.main,
                               cache: DisabledCache.instance)
    var preview: Preview? = nil
    
    func fetchPreview(urlString: String, completion: @escaping (Preview?) -> Void) {
        self.slp.preview(urlString) { response in
            print("PreviewViewModel response - \(response)")
            
            self.preview = Preview(title: response.title ?? "",
                                   subtitle: response.description ?? "",
                                   thumbnailURLString: response.image?.convertSpecialCharacters() ?? "",
                                   scrapURLString: response.url?.absoluteString ?? "")
            completion(self.preview)
        } onError: { error in
            print("PreviewViewModel error - \(error)")
        }
    }
}
