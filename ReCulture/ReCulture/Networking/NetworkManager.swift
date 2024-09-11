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
    
    /// 앨범들을 조회하는 함수입니다.
    func fetchNetworkingTest(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<TestDTO, NetworkError>) -> Void
    ) {
        let testAPI = TestAPI()
        networkService.request(testAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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
        let newUserProfileAPI = NewUserProfileAPI(requestDTO: newUserProfileRequestDTO.toDictionary!, profileImage: profileImage)
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
        let addRecordAPI = AddRecordAPI(requestDTO: addRecordRequestDTO.toDictionary!, photos: photos)
        networkService.request(addRecordAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 공개된 모든 기록 조회하는 함수
    func getAllRecords(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[RecordModel], NetworkError>) -> Void
    ) {
        let recordAPI = allRecordAPI()
        networkService.request(recordAPI) { result in
            switch result {
            case .success(let DTOs):
                let models = RecordResponseDTO.convertRecordDTOsToModels(DTOs: DTOs)
                print(models)
                completion(.success(models))
            case .failure(let error):
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
        let newTicketAPI = NewTicketAPI(requestDTO: newTicketRequestDTO.toDictionary!, photos: photos)
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
        completion: @escaping (Result<[FollowModel], NetworkError>) -> Void
    ) {
        let followAPI = FollowerAPI()
        networkService.request(followAPI) { result in
            switch result {
            case .success(let DTOs):
                let models = FollowDTO.convertFollowDTOsToModels(DTOs: DTOs)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getMyFollowings(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[FollowModel], NetworkError>) -> Void
    ) {
        let followAPI = FollowingAPI()
        networkService.request(followAPI) { result in
            switch result {
            case .success(let DTOs):
                let models = FollowDTO.convertFollowDTOsToModels(DTOs: DTOs)
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 사용자의 북마크 기록들 리스트를 조회하는 함수입니다.
    func getBookmarkList(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[BookmarkModel], NetworkError>) -> Void
    ){
        let api = BookmarkAPI()
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
}
