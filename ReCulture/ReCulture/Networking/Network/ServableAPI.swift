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
}

extension ServableAPI {
    var baseURL: String { "http://34.27.50.30:8080/api" }
    var params: String { "" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var requestBody: Encodable? { nil }
    
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
        
        return request
    }
}
