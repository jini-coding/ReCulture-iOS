//
//  AddRecordRequestDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/12/24.
//

import Foundation

struct AddRecordRequestDTO: Codable {
    let title: String
    let emoji: String
    let date: String
    let categoryId: String
    let disclosure: String
    let review: String
    let detail1: String
    let detail2: String
    let detail3: String
    let detail4: String
}
