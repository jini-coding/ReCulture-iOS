//
//  RecordAPI.swift
//  ReCulture
//
//  Created by Jini on 6/10/24.
//

import Foundation

struct myRecordAPI: ServableAPI {
    typealias Response = [RecordResponseDTO]
    
    var method: HTTPMethod { .get }
    var path: String { "/culture/my-culture" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct allRecordAPI: ServableAPI {
    typealias Response = SearchResponseDTO
    
    let page: Int
    let pageSize: Int
        
    var method: HTTPMethod { .get }
    //var path: String { "/culture?page=\(page)&pageSize=\(pageSize)" }
    var path: String { "/culture" }
    var queryParams: [String: String]? {
        return [
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct recordDetailAPI: ServableAPI {
    typealias Response = RecordResponseDTO
    
    let id: Int
        
    var method: HTTPMethod { .get }
    var path: String { "/culture/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct deleteRecordAPI: ServableAPI {
    typealias Response = RecordResponseDTO
    
    let id: Int
        
    var method: HTTPMethod { .delete }
    var path: String { "/culture/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct recommendRecordAPI: ServableAPI {
    typealias Response = SearchResponseDTO
    
    let page: Int
    let pageSize: Int
        
    var method: HTTPMethod { .get }
    //var path: String { "/culture?page=\(page)&pageSize=\(pageSize)" }
    var path: String { "/culture/recommend" }
    // Use queryParams instead of parameters
    var queryParams: [String: String]? {
        return [
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct searchRecordAPI: ServableAPI {
    typealias Response = SearchResponseDTO
    
    let searchString: String
    let page: Int
    let pageSize: Int
    
    var method: HTTPMethod { .get }
    
    var path: String { "/culture/search" }
    
    // Use queryParams instead of parameters
    var queryParams: [String: String]? {
        return [
            "searchString": searchString,
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct searchUserAPI: ServableAPI {
    typealias Response = UserSearchResponseDTO
    
    let nickname: String
    let page: Int
    let pageSize: Int
    
    var method: HTTPMethod { .get }
    
    var path: String { "/profile/search" }
    
    // Use queryParams instead of parameters
    var queryParams: [String: String]? {
        return [
            "nickname": nickname,
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
