//
//  HomeModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

struct MyProfileModel {
    var id: Int?
    var nickname: String?
    var profilePhoto: String?
    var exp: Int?
    var levelNum: Int?
    var levelName: String?
    var bio: String?
    var birthdate: String?
    var interest: String?
}

struct MyCalendarModel {
    let day: Int
    let count: Int
}
