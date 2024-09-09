//
//  BookmarkModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/8/24.
//

import Foundation

struct BookmarkModel {
    let postId: Int
    let title: String
    // TODO: 서버 수정 필요 -> 작성한 사람 닉네임으로
    let postOwnerId: Int
    let date: String
    let categoryType: RecordType
    let firstImageURL: String
}
