//
//  NetworkService.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import Foundation

protocol NetworkServable {
    func request<API>(_ api: API, completion: @escaping (Result<API.Response, NetworkError>) -> Void) where API: ServableAPI
}

class NetworkService: NetworkServable {

    init() {}

    // ServableAPI를 채택한 객체를 매개변수로 받아, 실제로 네트워크 통신하는 로직
    func request<API>(
        _ api: API,
        completion: @escaping (Result<API.Response, NetworkError>) -> Void
    ) where API : ServableAPI {
        let session = URLSession.shared
        
        // URLRequest를 생성하는 과정에서 쿼리 파라미터 추가
        guard let urlRequest = try? createURLRequest(from: api) else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                let networkError = self.convertErrorToNetworkError(from: error!)
                completion(.failure(networkError))
                return
            }

            if let response = response as? HTTPURLResponse {
                do {
                    try self.httpProcess(response: response)

                    guard let data else {
                        completion(.failure(.noData))
                        return
                    }

                    let decodedData = try self.decode(API.Response.self, from: data)

                    completion(.success(decodedData))
                } catch NetworkError.userAuthError {
                    completion(.failure(NetworkError.userAuthError))
                } catch NetworkError.unableToDecode {
                    completion(.failure(NetworkError.unableToDecode))
                } catch NetworkError.clientError {
                    completion(.failure(NetworkError.clientError))
                } catch NetworkError.serverError {
                    if let jsonString = String(data: (data)!, encoding: .utf8) {
                        print("Received JSON: \(jsonString)")
                    }
                    completion(.failure(NetworkError.serverError))
                } catch {
                    completion(.failure(NetworkError.unknownError))
                }
            }
        }
        .resume()
    }
    
    /// `ServableAPI`를 사용하여 URLRequest를 생성하는 함수
    private func createURLRequest<API>(from api: API) throws -> URLRequest where API: ServableAPI {
        var urlComponents = URLComponents(string: "\(api.baseURL)\(api.path)")
        
        // Ensure queryParams are added here
        if let queryParams = api.queryParams, api.method == .get {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue

        // Headers 설정
        if let headers = api.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        if let requestBody = api.requestBody, let jsonData = try? JSONEncoder().encode(requestBody) {
            request.httpBody = jsonData
        }

        if let multipartBody = api.multipartRequestBody {
            request.httpBody = multipartBody
        }

        return request
    }

}



extension NetworkService {
    private func convertErrorToNetworkError(from error: Error) -> NetworkError {
        if let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet {
            return NetworkError.disconnected
        } else {
            return NetworkError.apiIssue
        }
    }

    private func httpProcess(response: HTTPURLResponse) throws {
        print(response.statusCode)
        switch response.statusCode {
        case 200..<300: return
        case 400..<405: throw NetworkError.userAuthError
        case 405..<500: throw NetworkError.clientError
        case 500..<600: throw NetworkError.serverError
        default: throw NetworkError.unknownError
        }
    }

    
    /// 서버로부터 받은 데이터를 지정된 타입으로 디코딩
    /// - Parameters:
    ///   - type: 디코딩하고자 하는 타입
    ///   - data: 서버로부터 받은 원시 데이터
    /// - Returns: 디코딩된 데이터
    private func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T
    where T: Decodable {
        do {
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        } catch {
            throw NetworkError.unableToDecode
        }
    }
}
