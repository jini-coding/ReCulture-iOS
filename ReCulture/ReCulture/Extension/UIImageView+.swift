//
//  UIImageView+.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/19/24.
//

import UIKit

extension UIImageView {
    func load(url: URL){
        print("==load==")
        DispatchQueue.global().async { [weak self] in
            print("이미지 로딩 시작")
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
