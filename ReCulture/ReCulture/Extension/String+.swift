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
}
