//
//  PhotoService.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/31/24.
//

import Foundation
import Photos
import UIKit

class PhotoService: NSObject{
    
    // MARK: - Properties
    
    let requiredAccessLevel: PHAccessLevel = .readWrite
    var fetchResult: PHFetchResult<PHAsset>?
    var accessibleImages: [UIImage] = []
    var delegate: PHPhotoLibraryChangeObserver?
//    func checkAlbumPermission(completion: @escaping (Result<Void, NSError>) -> Void) {
//        switch PHPhotoLibrary.authorizationStatus() {
//        case .denied:
//            print("거부")
//            DispatchQueue.main.async { self.showAlert("앨범") }
//        case .authorized:
//            print("허용")
//            DispatchQueue.main.async { completion(.success(())) }
//        case .notDetermined, .restricted:
//            print("아직 결정하지 않은 상태")
//            PHPhotoLibrary.requestAuthorization { state in
//                if state == .authorized {
//                    DispatchQueue.main.async { completion(.success(())) }
//                } else {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//        default:
//            break
//        }
//    }
    
    func requestPHPhotoLibraryAuth(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
            switch authorizationStatus {
            case .limited:
                PHPhotoLibrary.shared().register(self)
                completion(true)
            case .authorized:
                completion(true)
            case .denied, .notDetermined, .restricted:
                completion(false)
                DispatchQueue.main.async { self.showAlert("앨범") }
            default:
                break
            }
        }
    }
    
    func getAccessibleImages(
        size: CGSize,
        contentMode: PHImageContentMode,
        completion: @escaping ([UIImage]) -> Void
    ) {
        self.accessibleImages = []
        print("접근가능한 이미지 불러오는 중")
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)  // 모든 asset을 불러옴
        print(fetchResult)
        /// fetchResult를 돌면서 image 요청
        self.fetchResult?.enumerateObjects { (asset, _, _) in
            PHImageManager().requestImage(for: asset, targetSize: size, contentMode: contentMode, options: options) { (image, info) in
                guard let image = image else { return }
                self.accessibleImages.append(image)
            }
        }
        completion(self.accessibleImages)
    }
    
    func showAlert(_ type: String) {
        if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            let alertVC = UIAlertController(
                title: "접근 권한 설정",
                message: "\(appName)이(가) \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
            
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            
            alertVC.addAction(cancelAction)
            alertVC.addAction(confirmAction)
            
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                windowScene.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
            }
        }
    }
}

extension PhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
}
