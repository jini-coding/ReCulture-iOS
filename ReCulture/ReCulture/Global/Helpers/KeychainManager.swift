//
//  KeychainManager.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import Foundation
import Security

enum TokenType: String{
    case accessToken = "AccessToken"
    case refreshToken = "RefreshToken"
}

class KeychainManager {
    
    static let shared = KeychainManager()
    
    static let service = Bundle.main.bundleIdentifier
        
    /// KeyChain에 토큰 저장
    func saveToken(type: TokenType, token: String) {
        let query: [String : Any] = [
           kSecClass as String: kSecClassGenericPassword as Any,
           kSecAttrService as String: KeychainManager.service as Any,
           kSecAttrAccount as String: type.rawValue as Any,
           kSecValueData as String: token.data(using: .utf8, allowLossyConversion: false) as Any   // 저장할 Token
        ]
        
        // 기존에 아이템이 있는 경우 먼저 삭제해야 함
        SecItemDelete(query as CFDictionary)
        
        // 새 데이터 추가
        let status = SecItemAdd(query as CFDictionary, nil)
        print("토큰 저장: \(status)")
        // 데이터 추가 결과가 no error가 아닌 경우
        guard status == errSecSuccess else {
            print("키체인에 토큰 추가 - 에러 발생: \(status)")
            return
        }
    }
    
    /// KeyChain에서 토큰 읽어오기
    func getToken(type: TokenType) -> String? {
        let query: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword as Any,
            kSecAttrService as String : KeychainManager.service as Any,
            kSecAttrAccount as String: type.rawValue as Any,
            kSecReturnData as String: kCFBooleanTrue as Any,  // CFData 타입으로 불러오라는 의미
            kSecMatchLimit as String: kSecMatchLimitOne as Any       // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        // 값 읽어오기
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } 
        else {
            print("키체인에서 토큰 읽기 - 에러 발생: \(status)")
            return nil
        }
    }
    
    /// KeyChain에서 토큰 삭제
    func deleteToken(type: TokenType) -> Bool {
        let query: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword as Any,
            kSecAttrService as String: KeychainManager.service as Any,
            kSecAttrAccount as String: type.rawValue as Any
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("토큰이 키체인에서 삭제됨")
            return true
        } 
        else {
            print("토큰이 키체인에서 삭제되지 못함: \(status)")
            return false
        }
    }
}
