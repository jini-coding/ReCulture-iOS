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
            userId: DTO.userId,
            nickname: DTO.nickname,
            bio: DTO.bio, 
            birthdate: DTO.birthdate, 
            interest: DTO.interest,
            profilePhoto: DTO.profilePhoto,
            exp: DTO.exp,
            levelId: DTO.levelId,
            level: DTO.level
        )
    }
}
