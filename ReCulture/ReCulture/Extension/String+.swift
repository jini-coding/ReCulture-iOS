//
//  String+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/2/24.
//

import Foundation

extension String {
    
    /// @ 포함하는지, 2글자 이상인지 확인
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /// 비밀번호가 유효한지(대문자, 소문자, 특수문자, 숫자가 8자 이상인지) 확인하는 메소드
    func isValidPassword() -> Bool {
        // 조건
        let pwRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", pwRegEx)
        // 조건에 대해 평가
        return passwordValidation.evaluate(with: self)
    }
}
