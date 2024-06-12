//
//  ServableAPI.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import Foundation

// 같은 API 제공자에게서 여러개의 API를 요청할 때 도메인 등의 중복 값들을 생략가능
// path, parameter, 도메인 주소까지 커스텀 가능

/// 서버 통신 시 api들이 채택해야 하는 프로토콜
/// 바로 서버로 요청보낼 수 있는 형태로 만들어줌
protocol ServableAPI {
    associatedtype Response: Decodable
    var path: String { get }
    var params: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    var requestBody: Encodable? { get }
    var multipartRequestBody: Data? { get }
}

extension ServableAPI {
    var baseURL: String { "http://34.27.50.30:8080/api" }
    var params: String { "" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var requestBody: Encodable? { nil }
    var multipartRequestBody: Data? { nil }
    
    var urlRequest: URLRequest {
        let urlString = baseURL + path + params
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach { (key: String, value: String) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let requestBody = requestBody, let jsonData = try? JSONEncoder().encode(requestBody) {
            request.httpBody = jsonData
        }
        
        if let multipartBody = multipartRequestBody {
            request.httpBody = multipartBody
        }
        print("===Servable API Headers==")
        print(request.allHTTPHeaderFields)
        print("===Servable API MultipartBody==")
        print(request.httpBody)
        return request
    }
    
    func createBody(name: String, parameters: [String : Any], boundary: String, imageFiles: [ImageFile]?) -> Data {
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
              body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(image.filename).png\"\r\n".data(using: .utf8)!)
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
