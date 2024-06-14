//
//  FollowDTO.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct FollowDTO: Codable {
    let id: Int
    let followerID: Int
    let followingID: Int
    let createdAt: String
    let follower: Follower
    let following: Following
}

struct Follower: Codable {
    let id: Int
    let email: String
    let createdAt: String
}

struct Following: Codable {
    let id: Int
    let email: String
    let createdAt: String
}

struct FollowStateDTO: Codable {
    let id: Int
    let fromUserID: Int
    let toUserID: Int
    let status: String
    let createdAt: String
    let updatedAt: String
}


extension FollowDTO {
    static func convertFollowDTOToModel(DTO: FollowDTO) -> FollowModel {
         return FollowModel(
             id: DTO.id,
             followerID: DTO.followerID,
             followingID: DTO.followingID,
             createdAt: DTO.createdAt,
             follower: FollowModel.UserModel(
                 id: DTO.follower.id,
                 email: DTO.follower.email,
                 createdAt: DTO.follower.createdAt
             ),
             following: FollowModel.UserModel(
                 id: DTO.following.id,
                 email: DTO.following.email,
                 createdAt: DTO.following.createdAt
             )
         )
     }

    static func convertFollowDTOsToModels(DTOs: [FollowDTO]) -> [FollowModel] {
        return DTOs.map { convertFollowDTOToModel(DTO: $0) }
    }
}


extension FollowStateDTO {
    static func convertFollowStateDTOToModel(DTO: FollowStateDTO) -> FollowStateModel {
        return FollowStateModel(
            id: DTO.id,
            fromUserID: DTO.fromUserID,
            toUserID: DTO.toUserID,
            status: DTO.status,
            createdAt: DTO.createdAt,
            updatedAt: DTO.updatedAt
        )
    }

    static func convertFollowStateDTOsToModels(DTOs: [FollowStateDTO]) -> [FollowStateModel] {
        return DTOs.map { convertFollowStateDTOToModel(DTO: $0) }
    }
}
