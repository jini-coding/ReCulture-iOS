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
    typealias Response = MyProfileDTO
    
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
