//
//  UserProfileAPI.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct UserProfileAPI: ServableAPI {
    typealias Response = UserProfileDTO
        
    let id: Int
    
    var method: HTTPMethod { .get }
    var path: String { "/profile/\(id)" }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

