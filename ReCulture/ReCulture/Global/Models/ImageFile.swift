//
//  ImageFile.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/10/24.
//

import Foundation

struct ImageFile:Codable {
    let filename: String
    let data: Data
    let type: String
}
