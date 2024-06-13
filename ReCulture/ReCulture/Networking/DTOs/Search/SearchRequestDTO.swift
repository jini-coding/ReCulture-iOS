//
//  SearchRequestDTO.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

struct SearchRequestDTO: Codable {
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
    let photos: [String]
}
