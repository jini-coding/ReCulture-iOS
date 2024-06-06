//
//  NetworkManager.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import Foundation

// 3. NetworkService 함수를 이용해서 NetworkManager에 네트워킹 요청 함수 구현
// 실직적으로 네트워킹을 할 함수를 선언하는 곳
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    /// 앨범들을 조회하는 함수입니다.
    func fetchNetworkingTest(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<TestDTO, NetworkError>) -> Void
    ) {
        let testAPI = TestAPI()
        networkService.request(testAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자 회원가입하는 함수
    func postUserSignup(
        signupRequestDTO: SignupRequestDTO,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<SignupResponseDTO, NetworkError>) -> Void
    ){
        let signupAPI = SignupAPI(requestDTO: signupRequestDTO)
        networkService.request(signupAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자 로그인하는 함수
    func postUserLogin(
        loginRequestDTO: LoginRequestDTO,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void
    ){
        let loginAPI = LoginAPI(requestDTO: loginRequestDTO)
        networkService.request(loginAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
