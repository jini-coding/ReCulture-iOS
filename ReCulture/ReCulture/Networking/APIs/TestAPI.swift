//
//  TestAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import Foundation

/*
 2.apiUrl을 생성 해준다.
 원래 내가 사용할 Url -> https://itunes.apple.com/search/?term=BTS&media=music
 */
struct TestAPI: ServableAPI {
    typealias Response = TestDTO // // Decodable을 채택한 Response 객체
    
    var path: String { "/search/" }
    var params: [String : String] {
        [
            "media": "music",
            "term": "BTS"
        ]
    }
}
