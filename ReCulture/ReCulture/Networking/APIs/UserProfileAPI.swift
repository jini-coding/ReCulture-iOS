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

struct userRecordAPI: ServableAPI {
    typealias Response = [AllRecordResponseDTO]
    
    let id: Int
    
    var method: HTTPMethod { .get }
    var path: String { "/culture/user/\(id)" }
    var parameters: [String: String] { return [:] }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}
