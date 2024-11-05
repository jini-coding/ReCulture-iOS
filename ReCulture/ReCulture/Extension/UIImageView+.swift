//
//  UIImageView+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/19/24.
//

import UIKit
import Kingfisher

extension UIImageView {
//    func load(url: URL){
//        print("==load==")
//        DispatchQueue.global().async { [weak self] in
//            print("이미지 로딩 시작")
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
    
    /// 이미지 경로만 주어졌을 때 이미지 로딩합니다. (with Kingfisher)
    func loadImage(urlWithoutBaseURL imagePath: String) {
        self.kf.cancelDownloadTask()
        if let url = URL(string: "http://34.64.120.187:8080\(imagePath)") {
            self.kf.setImage(with: url, placeholder: UIImage(), options: [.cacheOriginalImage]) { result in
                switch result {
                case .success(let value):
                    print("Image successfully loaded: \(value.image)")
                case .failure(let error):
                    print("Image failed to load with error: \(error.localizedDescription)")
                }
            }
        }
    }
}
