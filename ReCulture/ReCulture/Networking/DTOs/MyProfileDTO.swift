//
//  MyProfileDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/7/24.
//

struct MyProfileDTO: Codable {
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

extension MyProfileDTO {
    static func convertMyProfileDTOToModel(DTO: MyProfileDTO) -> MyProfileModel {
        return MyProfileModel(
            id: DTO.id,
            nickname: DTO.nickname,
            profilePhoto: DTO.profilePhoto,
            exp: DTO.exp,
            levelNum: DTO.levelId,
            levelName: DTO.level
        )
    }
}
