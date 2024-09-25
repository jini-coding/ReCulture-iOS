//
//  NetworkManager.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/3/24.
//

import Foundation

// 3. NetworkService 함수를 이용해서 NetworkManager에 네트워킹 요청 함수 구현
// 실직적으로 네트워킹을 할 함수를 선언하는 곳
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}

    /// 사용자 회원가입하는 함수
    func postUserRegister(
        signupRequestDTO: SignupRequestDTO,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<SignupResponseDTO, NetworkError>) -> Void
    ){
        let signupAPI = SignupAPI(requestDTO: signupRequestDTO)
        networkService.request(signupAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자 로그인하는 함수
    func postUserLogin(
        loginRequestDTO: LoginRequestDTO,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void
    ){
        let loginAPI = LoginAPI(requestDTO: loginRequestDTO)
        networkService.request(loginAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 로그인된 유저의 프로필 조회하는 함수
    func getMyProfile(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MyProfileModel, NetworkError>) -> Void
    ){
        let myProfileAPI = MyProfileAPI()
        networkService.request(myProfileAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(MyProfileDTO.convertMyProfileDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 사용자 새로운 프로필 설정하는 함수
    func postNewUserProfile(
        newUserProfileRequestDTO: NewUserProfileRequestDTO,
        profileImage: [ImageFile],
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<NewUserProfileResponseDTO, NetworkError>) -> Void
    ){
        let newUserProfileAPI = NewUserProfileAPI(requestDTO: newUserProfileRequestDTO.toDictionary, profileImage: profileImage)
        networkService.request(newUserProfileAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 새로운 기록 추가하는 함수
    func postNewRecord(
        addRecordRequestDTO: AddRecordRequestDTO,
        photos: [ImageFile],
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<AddRecordResponseDTO, NetworkError>) -> Void
    ){
        let addRecordAPI = AddRecordAPI(requestDTO: addRecordRequestDTO.toDictionary, photos: photos)
        networkService.request(addRecordAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
//    /// 공개된 모든 기록 조회하는 함수
//    func getAllRecords(page: Int, pageSize: Int, 
//                       _ networkService: NetworkServable = NetworkService(),
//                       completion: @escaping (Result<SearchResponseDTO, Error>) -> Void) {
//        let api = allRecordAPI(page: page, pageSize: pageSize)
//        networkService.request(api) { result in
//            switch result {
//            case .success(let responseDTO):
//                completion(.success(responseDTO))

    func getAllRecords(
        page: Int,
        pageSize: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<SearchResponseDTO, NetworkError>) -> Void
    ) {
        let recordAPI = allRecordAPI(page: page, pageSize: pageSize)
        networkService.request(recordAPI) { result in
            switch result {
            case .success(let responseDTO):
                print("Success: \(responseDTO)")
                completion(.success(responseDTO))
            case .failure(let error):
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
    }

    
    /// 내 기록 조회하는 함수
    func getMyRecords(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[RecordModel], NetworkError>) -> Void
    ) {
        let recordAPI = myRecordAPI()
        networkService.request(recordAPI) { result in
            switch result {
            case .success(let DTOs):
                let models = RecordResponseDTO.convertRecordDTOsToModels(DTOs: DTOs)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 로그인된 유저의 프로필 조회하는 함수 (마이페이지용)
    func getMyInfo(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MyProfileModel, NetworkError>) -> Void
    ){
        let myProfileAPI = MyProfileAPI()
        networkService.request(myProfileAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(MyProfileDTO.convertMyProfileDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
  
  
    func getMyCalendar(
        year: String,
        month: String,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MyCalendarDTO, NetworkError>) -> Void
    ){
        let myCalendarAPI = MyCalendarAPI(year: year, month: month)
        networkService.request(myCalendarAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자의 티켓들 가져오는 함수
    func getMyTicketBook(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[MyTicketBookModel], NetworkError>) -> Void
    ){
        let myTicketBookAPI = MyTicketBookAPI()
        networkService.request(myTicketBookAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(MyTicketBookDTO.convertMyTicketBookDTOsToModels(DTOs: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 새로운 티켓 추가하는 함수
    func postNewTicket(
        newTicketRequestDTO: TicketRequestDTO,
        photos: [ImageFile],
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<TicketResponseDTO, NetworkError>) -> Void
    ){
        let newTicketAPI = NewTicketAPI(requestDTO: newTicketRequestDTO.toDictionary, photos: photos)
        networkService.request(newTicketAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 특정 기록 상세보기
    func getRecordDetails(recordId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<RecordModel, NetworkError>) -> Void
    ) {
        let recordAPI = recordDetailAPI(id: recordId)
        networkService.request(recordAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(RecordResponseDTO.convertRecordDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 특정 유저 프로필 정보 불러오기
    func getUserProfile(userId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<UserProfileModel, NetworkError>) -> Void
    ){
        let userProfileAPI = UserProfileAPI(id: userId)
        networkService.request(userProfileAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(UserProfileDTO.convertUserProfileDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자 정보 수정
    func editMyProfile(
        requestDTO: [String: Any],
        profileImage: [ImageFile],
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MyProfileModel, NetworkError>) -> Void
    ) {
        let editMyProfileAPI = EidtMyProfileAPI(requestDTO: requestDTO, profileImage: profileImage)
        networkService.request(editMyProfileAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(MyProfileDTO.convertMyProfileDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getMyFollowers(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[FollowerDTO], NetworkError>) -> Void
    ) {
        let followAPI = FollowerAPI()
        networkService.request(followAPI) { result in
            switch result {
            case .success(let followersDTOs):
                completion(.success(followersDTOs))  // Return the DTOs
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getMyFollowings(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[FollowingDTO], NetworkError>) -> Void
    ) {
        let followAPI = FollowingAPI()
        networkService.request(followAPI) { result in
            switch result {
            case .success(let followingsDTOs):
                completion(.success(followingsDTOs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 수락or거절 대기 중인 요청 정보 불러오기
    func getPendingRequest(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[FollowStateModel], NetworkError>) -> Void
    ) {
        let pendingAPI = pendingAPI()
        networkService.request(pendingAPI) { result in
            switch result {
            case .success(let DTOs):
                let models = FollowStateDTO.convertFollowStateDTOsToModels(DTOs: DTOs)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 팔로우 요청 수락
    func acceptRequest(requestId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<FollowStateModel, NetworkError>) -> Void
    ) {
        let acceptAPI = acceptAPI(id: requestId)
        networkService.request(acceptAPI) { result in
            switch result {
            case .success(let DTO):
                let models = FollowStateDTO.convertFollowStateDTOToModel(DTO: DTO)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 팔로우 요청 거절
    func rejectRequest(requestId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<FollowStateModel, NetworkError>) -> Void
    ) {
        let denyAPI = denyAPI(id: requestId)
        networkService.request(denyAPI) { result in
            switch result {
            case .success(let DTO):
                let models = FollowStateDTO.convertFollowStateDTOToModel(DTO: DTO)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자의 북마크 기록들 리스트를 조회하는 함수입니다.
        func getBookmarkList(
            _ networkService: NetworkServable = NetworkService(),
            completion: @escaping (Result<[BookmarkListModel], NetworkError>) -> Void
        ){
            let api = BookmarkListAPI()
            networkService.request(api) { result in
                switch result {
                case .success(let DTOs):
                    let models = BookmarkListDTO.convertBookmarkListDTOsToModels(DTOs: DTOs.data)
                    completion(.success(models))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    /// 기록 삭제하기
    func deleteRecord(postId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<RecordModel, NetworkError>) -> Void
    ){
        let recordAPI = deleteRecordAPI(id: postId)
        networkService.request(recordAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(RecordResponseDTO.convertRecordDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 내 기록을 수정하는 함수입니다.
    func editMyRecord(recordId: Int,
                      editRecordRequestDTO: AddRecordRequestDTO,
                      photos: [ImageFile],
                      _ networkService: NetworkServable = NetworkService(),
                      completion: @escaping (Result<EditRecordResponseDTO, NetworkError>) -> Void
    ) {
        let api = EditRecordAPI(recordId: recordId,
                                    requestDTO: editRecordRequestDTO.toDictionary,
                                    photos: photos)
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 다른 사용자들의 기록을 북마크하는 함수입니다.
    func bookmarkRecord(recordId: Int,
                        _ networkService: NetworkServable = NetworkService(),
                        completion: @escaping (Result<BookmarkModel, NetworkError>) -> Void) {
        let api = BookmarkAPI(recordId: recordId)
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(BookmarkDTO.convertBookmarkDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
