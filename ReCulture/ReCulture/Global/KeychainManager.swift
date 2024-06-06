//
//  KeychainManager.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import Foundation

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private let service = "com.smwu.ReCulture"
    private let account = "token"
    
    /// KeyChain에 토큰 저장
    func saveToken(_ token: String) {
        let query: NSDictionary = [
           kSecClass: kSecClassGenericPassword,
           kSecAttrService: service,
           kSecAttrAccount: account,
           kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any   // 저장할 Token
        ]
        
        // 기존에 아이템이 있는 경우 먼저 삭제해야 함
        SecItemDelete(query as CFDictionary)
        
        // 새 데이터 추가
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // 데이터 추가 결과가 no error가 아닌 경우
        guard status == errSecSuccess else {
            print("키체인에 토큰 추가 - 에러 발생: \(status)")
            return
        }
    }
    
    /// KeyChain에서 토큰 읽어오기
    func getToken() -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue as Any,  // CFData 타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne       // 중복되는 경우, 하나의 값만 불러오라는 의미
        ]
        
        // 값 읽어오기
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
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
    func deleteToken() -> Bool {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        
        let status = SecItemDelete(query)
        
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
