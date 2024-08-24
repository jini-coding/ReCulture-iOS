//
//  UserDefaultsManager.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 8/24/24.
//

import Foundation

class UserDefaultsManager {
    enum UserDefaultsKeys: String, CaseIterable {
        case userId /// 해당 사용자의 id
        case nickname /// 해당 사용자의 닉네임
        case email /// 해당 사용자의 이메일
        case handle /// 해당 사용자의 핸들(@으로 시작하는)
    }
    
    static func setData<T>(value: T, key: UserDefaultsKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func getData<T>(type: T.Type, forKey: UserDefaultsKeys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    
    static func removeData(key: UserDefaultsKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
}
