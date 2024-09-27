//
//  BookmarkListModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/8/24.
//

import Foundation

struct BookmarkListModel {
    let postId: Int
    let title: String
    let postOwnerId: Int
    let postOwnerNickname: String
    let postOwnerProfileImage: String
    let date: String
    let categoryType: RecordType
    let firstImageURL: String
}
