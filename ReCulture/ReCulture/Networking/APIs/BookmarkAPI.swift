//
//  BookmarkAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/25/24.
//

struct BookmarkAPI: ServableAPI {
    typealias Response = BookmarkDTO
    
    let recordId: Int
   
    var requestBody: Encodable? { ["postId" : recordId] }
    var method: HTTPMethod { .post }
    var path: String { "/bookmark/toggle" }
    var headers: [String : String]? {  ["Content-Type": "application/json",
                                        "Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"]
    }
}
