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

        session.dataTask(with: api.urlRequest) { data, response, error in
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
                } catch NetworkError.unableToDecode {
                    completion(.failure(NetworkError.unableToDecode))
                } catch NetworkError.clientError {
                    completion(.failure(NetworkError.clientError))
                } catch NetworkError.serverError {
                    completion(.failure(NetworkError.serverError))
                } catch {
                    completion(.failure(NetworkError.unknownError))
                }
            }
        }
        .resume()
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
        switch response.statusCode {
        case 200..<300: return
        case 400..<500: throw NetworkError.clientError
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
