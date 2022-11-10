//
//  CrawlManager.swift
//  Sparky
//
//  Created by SeungMin on 2022/10/03.
//

import Alamofire
import SwiftSoup
import RxRelay

enum NetworkError: Error {
    case invalidURL
    case invlidRequest
    case invalidResponse
    case emptyHTML
    case failure
    case parsingError
    
}

final class CrwalManager {
    func getTistoryScrap(url: URL?,
                         completion: @escaping (Scrap) -> Void) {
        var scrap = Scrap(scrapId: 0,
                        title: "",
                          subTitle: "",
                          memo: "",
                          thumbnailURLString: Strings.sparkyImageString,
                          scrapURLString: "",
                          tagList: BehaviorRelay(value: [])
        )
        
        guard let url = url else {
            print(NetworkError.invalidURL)
            return
        }

        AF.request(url).responseString { response in
            if response.error != nil {
                print(NetworkError.failure)
                return
            }
            
            guard let html = response.value else {
                print(NetworkError.emptyHTML)
                return
            }
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select(Strings.tistoryBaseSector)
                let array = elements.array()
                
                var thumbnailURLString = ""
                var title = ""
                var subTitle = ""
                
                for i in 0..<array.count {
                    print("index - \(i)")
                    thumbnailURLString = try array[i].select(Strings.tistoryThumbnailSector).attr("src")
//                    thumbnailURL = URL(string: thumbnailURLString) ?? URL(string: Strings.sparkyImageString)!
                    title = try array[i].select(Strings.tistoryTitleSector).text()
                    subTitle += try array[i].select(Strings.tistorySubTitleSector).text()
                }
                
                scrap = Scrap(scrapId: 0,
                    title: title,
                              subTitle: subTitle,
                              memo: "",
                              thumbnailURLString: thumbnailURLString,
                              scrapURLString: "",
                              tagList: BehaviorRelay(value: []))
                completion(scrap)
            } catch {
                print(NetworkError.parsingError)
            }
            
        }
    }
}
