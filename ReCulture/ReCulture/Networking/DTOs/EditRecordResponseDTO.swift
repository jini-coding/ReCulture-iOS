//
//  EditRecordResponseDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/22/24.
//

struct EditRecordResponseDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: AddRecordResponseDTO
}
