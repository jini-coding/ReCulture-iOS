//
//  SearchRecordDetailVC.swift
//  ReCulture
//
//  Created by Jini on 5/22/24.
//

import UIKit

class SearchRecordDetailVC: UIViewController {
    
    var titleText: String = ""
    var creator: String = ""
    var createdAt: String = ""
    var category: String = ""
    var contentImage: [String] = []
    
    struct ContentDetail {
        var version: String
        var location: String
        var casting: String
        var comment: String
    }
    
    let tempData = [
        ContentDetail(version: "3회차", location: "디큐브 링크아트센터", casting: "최정원, 아이비, 민경아, 박건형, 최재림", comment: "시카고는 정말 볼 때마다 너무 재미있다... 이번에\n눈, 귀 둘 다 호강하고 왔지롱")
    ]
    
    let contentScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.showsVerticalScrollIndicator = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollview
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blue
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont20B()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14R()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let separateLineImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "separate_line")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        return imageview
    }()
    
    let createDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14R()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.textColor = UIColor.rcMain
        label.backgroundColor = UIColor.rcGray100
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let contentImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 8
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageview
    }()
    
    let detailInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcGray000
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        setupScrollView()
        setupTitleInfo()
        setupImage()
        setupInfoView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "\(creator)님의 기록"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.rcFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
    
    func setupScrollView() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentsView)
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentsView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentsView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentsView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentsView.heightAnchor.constraint(equalToConstant: 800)
        ])
        
        view.layoutIfNeeded()
        contentScrollView.contentSize = contentsView.bounds.size
    }
    
    func setupTitleInfo() {
        titleLabel.text = titleText
        creatorLabel.text = creator
        createDateLabel.text = createdAt
        categoryLabel.text = category
        
        contentsView.addSubview(titleLabel)
        contentsView.addSubview(creatorLabel)
        contentsView.addSubview(separateLineImageView)
        contentsView.addSubview(createDateLabel)
        contentsView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            creatorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            creatorLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            creatorLabel.heightAnchor.constraint(equalToConstant: 14),
            
            separateLineImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separateLineImageView.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 8),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            
            createDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            createDateLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            createDateLabel.heightAnchor.constraint(equalToConstant: 14),
            
            categoryLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(equalToConstant: 49)
        ])
        
    }
    
    func setupImage() {
        if let firstImageName = contentImage.first, let image = UIImage(named: firstImageName) {
            contentImageView.image = image
        }
        
        contentsView.addSubview(contentImageView)
        
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            contentImageView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            contentImageView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16),
            contentImageView.heightAnchor.constraint(equalToConstant: 420)
        ])
    }
    
    //여기 미완...
    func setupInfoView() {
        
        contentsView.addSubview(detailInfoView)
        
        NSLayoutConstraint.activate([
            detailInfoView.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 20),
            detailInfoView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 16),
            detailInfoView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16),
            detailInfoView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        let titles = ["회차   ", "공연장", "캐스팅", "감상평"]
        let details = [tempData.first?.version ?? "", tempData.first?.location ?? "", tempData.first?.casting ?? "", tempData.first?.comment ?? ""]
        
        var previousView: UIView?
        for index in 0..<titles.count {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.rcFont14B()
            titleLabel.textColor = .black
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = titles[index]
            
            let detailLabel = UILabel()
            detailLabel.font = UIFont.rcFont14M()
            detailLabel.textColor = .black
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            detailLabel.text = details[index]
            detailLabel.numberOfLines = 0
            
            detailInfoView.addSubview(titleLabel)
            detailInfoView.addSubview(detailLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? detailInfoView.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: detailInfoView.leadingAnchor, constant: 16),
                
                detailLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
                detailLabel.trailingAnchor.constraint(equalTo: detailInfoView.trailingAnchor, constant: -16)
            ])
            
            previousView = titleLabel
        }
    }
}
