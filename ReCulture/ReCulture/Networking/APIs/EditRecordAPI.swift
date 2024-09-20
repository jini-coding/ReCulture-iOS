//
//  EditRecordAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/21/24.
//

import Foundation

struct EditRecordAPI: ServableAPI {
    typealias Response = AddRecordResponseDTO
    
    let recordId: Int
    
    let requestDTO: [String: Any]
    let photos: [ImageFile]
    let boundary = UUID().uuidString
    
    var method: HTTPMethod { .post }
    var path: String { "/culture/\(recordId)" }
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
