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
    
    func loadImage(urlWithoutBaseURL: String) {
        if let url = URL(string: "http://34.64.120.187:8080\(urlWithoutBaseURL)") {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                    }
                }
            }
        }   
    }
}
