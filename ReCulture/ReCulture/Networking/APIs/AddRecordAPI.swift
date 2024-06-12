//
//  AddRecordAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/12/24.
//

import Foundation

struct AddRecordAPI: ServableAPI {
    typealias Response = AddRecordResponseDTO
    
    let requestDTO: [String: Any]
    let photos: [ImageFile]
    let boundary = UUID().uuidString
    
    var method: HTTPMethod { .post }
    var path: String { "/culture" }
    var headers: [String : String]? { [
        "Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)",
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
    ]}
    
    var multipartRequestBody: Data? {
        createBody(name: "photos",
                   parameters: requestDTO,
                   boundary: boundary,
                   imageFiles: photos)
    }
}
