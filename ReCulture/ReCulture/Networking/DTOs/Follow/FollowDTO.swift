//
//  FollowDTO.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct FollowerDTO: Codable {
    let id: Int
    let followerID: Int
    let followingID: Int
    let createdAt: String
    let follower: Follower
    
    enum CodingKeys: String, CodingKey {
        case id
        case followerID = "followerId"
        case followingID = "followingId"
        case createdAt
        case follower
    }

    struct Follower: Codable {
        let id: Int
        let email: String
        let createdAt: String
    }
}

struct FollowingDTO: Codable {
    let id: Int
    let followerID: Int
    let followingID: Int
    let createdAt: String
    let following: Following
    
    enum CodingKeys: String, CodingKey {
        case id
        case followerID = "followerId"
        case followingID = "followingId"
        case createdAt
        case following
    }

    struct Following: Codable {
        let id: Int
        let email: String
        let createdAt: String
    }
}

struct FollowStateDTO: Codable {
    let id: Int
    let fromUserId: Int
    let toUserId: Int
    let status: String
    let createdAt: String
    let updatedAt: String
}

struct SendRequestDTO: Encodable {
    let receiverId: Int
}

extension FollowerDTO {
    static func convertFollowerDTOToModel(DTO: FollowerDTO) -> FollowerModel {
         return FollowerModel(
             id: DTO.id,
             followerID: DTO.followerID,
             followingID: DTO.followingID,
             createdAt: DTO.createdAt,
             follower: FollowerModel.UserModel(
                 id: DTO.follower.id,
                 email: DTO.follower.email,
                 createdAt: DTO.follower.createdAt
             )
         )
     }

    static func convertFollowerDTOsToModels(DTOs: [FollowerDTO]) -> [FollowerModel] {
        return DTOs.map { convertFollowerDTOToModel(DTO: $0) }
    }
}

extension FollowingDTO {
    static func convertFollowingDTOToModel(DTO: FollowingDTO) -> FollowingModel {
         return FollowingModel(
             id: DTO.id,
             followerID: DTO.followerID,
             followingID: DTO.followingID,
             createdAt: DTO.createdAt,
             following: FollowingModel.UserModel(
                 id: DTO.following.id,
                 email: DTO.following.email,
                 createdAt: DTO.following.createdAt
             )
         )
     }

    static func convertFollowingDTOsToModels(DTOs: [FollowingDTO]) -> [FollowingModel] {
        return DTOs.map { convertFollowingDTOToModel(DTO: $0) }
    }
}


extension FollowStateDTO {
    static func convertFollowStateDTOToModel(DTO: FollowStateDTO) -> FollowStateModel {
        return FollowStateModel(
            id: DTO.id,
            fromUserID: DTO.fromUserId,
            toUserID: DTO.toUserId,
            status: DTO.status,
            createdAt: DTO.createdAt,
            updatedAt: DTO.updatedAt
        )
    }

    static func convertFollowStateDTOsToModels(DTOs: [FollowStateDTO]) -> [FollowStateModel] {
        return DTOs.map { convertFollowStateDTOToModel(DTO: $0) }
    }
}
