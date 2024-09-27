//
//  MypageModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

struct FollowerModel {
    let id: Int
    let followerID: Int
    let followingID: Int
    let createdAt: String
    let follower: UserModel
    
    struct UserModel {
        let id: Int
        let email: String
        let createdAt: String
    }

}

struct FollowingModel {
    let id: Int
    let followerID: Int
    let followingID: Int
    let createdAt: String
    let following: UserModel
    
    struct UserModel {
        let id: Int
        let email: String
        let createdAt: String
    }

}

struct FollowStateModel {
    let id: Int
    let fromUserID: Int
    let toUserID: Int
    let status: String
    let createdAt: String
    let updatedAt: String
}

struct EditMyProfileModel {
    var nickname: String?
    var bio: String?
    var birthdate: String?
    var interest: String?
    var photo: String?
}

struct ChangePwModel {
    var cur_password: String?
    var new_password: String?
}

struct ChangePwResponseModel {
    var id: Int?
    var email: String?
    var createdAt: String?
}
