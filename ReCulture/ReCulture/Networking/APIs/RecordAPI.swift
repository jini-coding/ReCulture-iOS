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
    typealias Response = [RecordResponseDTO]
        
    var method: HTTPMethod { .get }
    var path: String { "/culture" }
    var parameters: [String: String] { return [:] }
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

