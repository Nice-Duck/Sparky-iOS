//
//  PreviewViewModel.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/21.
//

import SwiftLinkPreview

final class PreviewViewModel {
    
    private let slp = SwiftLinkPreview(session: URLSession.shared,
                                       workQueue: SwiftLinkPreview.defaultWorkQueue,
                                       responseQueue: DispatchQueue.main,
                                       cache: DisabledCache.instance)
    
    func fetchPreview(urlString: String, completion: @escaping (Response) -> Void) {
        self.slp.preview(urlString) { response in
                print("PreviewViewModel response - \(response)")
                completion(response)
            } onError: { error in
                print("PreviewViewModel error - \(error)")
            }
    }
}
