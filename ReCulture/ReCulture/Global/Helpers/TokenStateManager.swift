//
//  TokenStateManager.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

class TokenStateManager {
    
    static let shared = TokenStateManager()
    
    private var isLoggedIn: Bool = false
    private var tokenExpired: Bool = false
    private var isLoggedOut: Bool = false
}
