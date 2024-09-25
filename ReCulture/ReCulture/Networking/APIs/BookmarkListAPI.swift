//
//  BookmarkListAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/8/24.
//

struct BookmarkListAPI: ServableAPI {
    typealias Response = BookmarkListDTO
    
    var method: HTTPMethod { .get }
    var path: String { "/bookmark" }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
