//
//  Codable+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

import Foundation

extension Encodable {
    
    var toDictionary : [String: Any] {
        guard let object = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] 
        else { return [:] }
        return dictionary
    }
}
