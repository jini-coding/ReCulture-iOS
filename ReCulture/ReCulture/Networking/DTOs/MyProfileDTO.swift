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

struct EditMyProfileRequestDTO: Codable {
    let nickname: String
    let bio: String
    let birthdate: String
    let interest: String
}

extension MyProfileDTO {
    static func convertMyProfileDTOToModel(DTO: MyProfileDTO) -> MyProfileModel {
        return MyProfileModel(
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

extension EditMyProfileRequestDTO {
    static func convertEditMyProfileDTOToModel(DTO: EditMyProfileRequestDTO) -> EditMyProfileModel {
        return EditMyProfileModel(
            nickname: DTO.nickname,
            bio: DTO.bio,
            birthdate: DTO.birthdate,
            interest: DTO.interest
        )
    }
}

struct LogoutResponse: Codable {
    let message: String
}

struct WithdrawalResponse: Codable {
    let id: Int
    let email: String
    let createdAt: String
}

struct ChangePwResponseDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: DataClass
    
    struct DataClass: Codable {
        let id: Int
        let email: String
        let createdAt: String
    }
}

struct ChangePwRequestDTO: Encodable {
    let cur_password: String
    let new_password: String
}

extension ChangePwResponseDTO {
    static func convertChangePwResDTOToModel(DTO: ChangePwResponseDTO) -> ChangePwResponseModel {
        return ChangePwResponseModel(
            id: DTO.data.id,
            email: DTO.data.email,
            createdAt: DTO.data.createdAt
        )
    }
}

extension ChangePwRequestDTO {
    static func convertChangePwReqDTOToModel(DTO: ChangePwRequestDTO) -> ChangePwModel {
        return ChangePwModel(
            cur_password: DTO.cur_password,
            new_password: DTO.new_password
        )
    }
}
