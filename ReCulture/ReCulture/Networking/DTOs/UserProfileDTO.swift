//
//  UserProfileDTO.swift
//  ReCulture
//
//  Created by Jini on 6/14/24.
//

struct UserProfileDTO: Codable {
    let id: Int
    let userId: Int
    let nickname: String
    let bio: String
    let birthdate: String
    let interest: String?
    let profilePhoto: String
    let exp: Int
    let levelId: Int
    let level: String
}

extension UserProfileDTO {
    static func convertUserProfileDTOToModel(DTO: UserProfileDTO) -> UserProfileModel {
        return UserProfileModel(
            id: DTO.id,
            nickname: DTO.nickname,
            profilePhoto: DTO.profilePhoto,
            exp: DTO.exp,
            levelNum: DTO.levelId,
            levelName: DTO.level,
            bio: DTO.bio,
            birthdate: DTO.birthdate,
            interest: DTO.interest
        )
    }
}
