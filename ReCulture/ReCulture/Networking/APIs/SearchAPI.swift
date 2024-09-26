//
//  SearchAPI.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

import Foundation

struct SearchAPI: ServableAPI {
    typealias Response = [AllRecordResponseDTO]
        
    var method: HTTPMethod { .get }
    var path: String { "/culture" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
