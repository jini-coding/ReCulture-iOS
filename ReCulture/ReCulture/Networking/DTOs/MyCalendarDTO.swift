//
//  MyCalendarDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/13/24.
//

typealias MyCalendarDTO = [CalendarRecordDetail]

struct CalendarRecordDetail: Codable {
    let id: Int
    let title: String
    let emoji: String
    let date: String
    let categoryId: Int
    let disclosure: String
    let review: String
    let detail1: String
    let detail2: String
    let detail3: String
    let detail4: String
    let authorId: Int
    let createdAt: String
    let updatedAt: String
    let photos: [CulturePhotos]
}

struct CulturePhotos: Codable {
    let id: Int
    let url: String
    let culturePostId: Int
}
