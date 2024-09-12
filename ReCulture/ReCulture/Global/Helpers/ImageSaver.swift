//
//  ImageSaver.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 8/6/24.
//

import UIKit
import Photos

private var isPermissionDenied = false
private var imageSavedHandler: (() -> Void)?
private var viewController: UIViewController?

final class ImageSaver: NSObject {
    
    /// 이미지를 갤러리에 저장하는 메소드
    /// - Parameters:
    ///   - image: 저장할 image(UIImage)
    ///   - target: 이미지 저장 후 호출해야 할 메소드의 VC
    ///   - handler: 저장 완료 후 핸들러
    func saveAsImage(_ image: UIImage, target: UIViewController? = nil, handler: (() -> Void)?) {
        imageSavedHandler = handler
        viewController = target
        isPermissionDenied = checkPhotoPermission()
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(imageSaved),
                                       nil)
    }
    
    /// 이미지 저장 직후 호출되는 메소드(에러 발생 시 에러 처리 등)
    /// - Parameters:
    ///   - image: 저장하고자 하는 이미지(UIImage)
    ///   - error: 저장 과정에서 발생한 에러(없을 경우 nil)
    ///   - contextInfo: contextInfo
    @objc func imageSaved(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            NSLog("Failed to save image. Error = \(error)")
            if isPermissionDenied, let vc = viewController {
                // 이미지 저장 실패 알림창 띄우기
                let alert = UIAlertController(title: "갤러리 접근 권한",
                                              message: "티켓을 저장하려면 설정에서 앱의 사진 접근 권한을 허용해주세요.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                vc.present(alert, animated: true)
            }
        }
        else {
            imageSavedHandler?()
        }
    }
    
    /// 이미지 저장 권한 검사
    /// - Returns: 권한이 있는지 여부의 Bool값
    private func checkPhotoPermission() -> Bool {
        var status: PHAuthorizationStatus = .notDetermined
        status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        return status == .denied
    }
}
