//
//  NewUserProfileAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import Foundation
import UIKit

struct ImageFile:Codable {
    let filename: String
    let data: Data
    let type: String
}

struct NewUserProfileAPI: ServableAPI {
    typealias Response = NewUserProfileResponseDTO
    
    let requestDTO: [String: Any]
    let profileImage: [ImageFile]
    let boundary = UUID().uuidString
    
    var method: HTTPMethod { .post }
    var path: String { "/profile" }
    var headers: [String : String]? { [
        "Authorization": "Bearer \(KeychainManager.shared.getToken(type: .accessToken)!)",
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
    ]}
    
    var multipartRequestBody: Data? {
        createBody(parameters: requestDTO,
                   boundary: boundary,
                   imageFiles: profileImage)
    }
    
    func createBody(parameters: [String : Any], boundary: String, imageFiles: [ImageFile]?) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // image를 첨부하지 않아도 작동할 수 있도록 if let을 통해 images 여부 확인
        // request의 key값의 이름에 따라 name의 값을 변경
        if let images = imageFiles {
            for image in images {
              body.append(boundaryPrefix.data(using: .utf8)!)
              body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(image.filename).png\"\r\n".data(using: .utf8)!)
              body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
              body.append(image.data)
              body.append("\r\n".data(using: .utf8)!)
          }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
//        print("--body 만드는 중--")
//        print(String(decoding: body, as: UTF8.self))

        return body
    }
}
