//
//  NetworkingTestVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import UIKit

/// 네트워킹 예시를 위한 임시 VC
class NetworkingTestVC: UIViewController {
    
    override func viewDidLoad() {
        
        /*
         1. DTO(실제 API에서 받게 되는 정보) 데이터 모델 구조체 선언
         2. apiUrl 선언(만들기)
         3. NetworkService 함수를 이용해서 NetworkManager에 네트워킹 요청 함수 구현
         4. 내 VC에 함수 실행
        */
        
        // 4. 내 VC에 함수 실행
        NetworkManager.shared.fetchNetworkingTest { result in
            print(result)
        }
    }
}
