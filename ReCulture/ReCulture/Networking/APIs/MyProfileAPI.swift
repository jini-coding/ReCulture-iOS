//
//  MyProfileAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import Foundation

struct MyProfileAPI: ServableAPI {
    typealias Response = MyProfileDTO
        
    var method: HTTPMethod { .get }
    var path: String { "/profile/my-profile" }
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}


struct EidtMyProfileAPI: ServableAPI {
    typealias Response = EditMyProfileRequestDTO
    
    let requestDTO: [String: Any]
    let profileImage: [ImageFile]
    let boundary = UUID().uuidString
        
    var method: HTTPMethod { .put }
    var path: String { "/profile" }
    var headers: [String : String]? { [
        "Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)",
        "Content-Type": "multipart/form-data; boundary=\(boundary)"] }
    
    var multipartRequestBody: Data? {
        createBody(name: "photo",
                   parameters: requestDTO,
                   boundary: boundary,
                   imageFiles: profileImage)
    }
}

struct LogoutAPI: ServableAPI {
    typealias Response = LogoutResponse
        
    var method: HTTPMethod { .post }
    var path: String { "/auth/logout" }
    
    // Add the "refresh" token to the headers as required
    var headers: [String : String]? {
        guard let refreshToken = KeychainManager.shared.getToken(type: .refreshToken) else {
            return nil
        }
        
        return [
            "Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)",
            "refresh": refreshToken
        ]
    }
}

struct WithdrawalAPI: ServableAPI {
    typealias Response = WithdrawalResponse
        
    var method: HTTPMethod { .delete }
    var path: String { "/user/delete" }
    
    var headers: [String : String]? { ["Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)"] }
}

struct ChangePwAPI: ServableAPI {
    typealias Response = ChangePwResponseDTO
    
    let requestDTO: ChangePwRequestDTO
        
    var method: HTTPMethod { .put }
    var path: String { "/auth/change_password" }
    var headers: [String: String]? { [
            "Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)",
            "Content-Type": "application/json"
        ] }

    var requestBody: Encodable? { requestDTO }
}
