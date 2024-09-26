//
//  RecordAPI.swift
//  ReCulture
//
//  Created by Jini on 6/10/24.
//

import Foundation

struct myRecordAPI: ServableAPI {
    typealias Response = [AllRecordResponseDTO]
    
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
    var parameters: [String: String] {
        return [
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct recordDetailAPI: ServableAPI {
    typealias Response = RecordDetailResponseDTO
    
    let id: Int
        
    var method: HTTPMethod { .get }
    var path: String { "/culture/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct deleteRecordAPI: ServableAPI {
    typealias Response = AllRecordResponseDTO
    
    let id: Int
        
    var method: HTTPMethod { .delete }
    var path: String { "/culture/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
