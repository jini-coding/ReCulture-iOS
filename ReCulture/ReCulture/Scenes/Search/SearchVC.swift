//
//  SearchVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct SearchContent {
        var title: String
        var creator: String
        var createdAt: String
        var category: String
        var profileImage: String
        var contentImages: [String]
    }
    
    var selectedCategory: String = "전체"
    
    let tempData = [
        SearchContent(title: "오늘은 시카고를 봐서 너무 행복한 하루", creator: "@soohyun", createdAt: "4시간 전", category: "뮤지컬", profileImage: "temp1", contentImages: ["temp_img"]),
        SearchContent(title: "애니메이션 러버라면 타카하타 이사오전 필수", creator: "@anilover", createdAt: "12시간 전", category: "전시회", profileImage: "temp2", contentImages: ["temp_img2"]),
        SearchContent(title: "아이유 콘서트는 매번 가야겠다", creator: "@happygirl", createdAt: "3일 전", category: "콘서트", profileImage: "temp3", contentImages: ["temp_img2"]),
        SearchContent(title: "오늘은 시카고를 봐서 너무 행복한 하루", creator: "@lovelove", createdAt: "2024.04.20", category: "뮤지컬", profileImage: "temp4", contentImages: ["temp_img"])
    ]
    
    let searchTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "검색어를 입력해주세요"
        textfield.textColor = UIColor.black
        textfield.font = UIFont.rcFont16M()
        textfield.backgroundColor = UIColor.white
        textfield.layer.cornerRadius = 12
        textfield.layer.masksToBounds = true
        
        return textfield
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let categoryScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.showsHorizontalScrollIndicator = false
        
        return scrollview
    }()
    
    let contentTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        
        return tableview
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.rcMain
        
        setupSearchField()
        setupContentView()
        
        contentTableView.register(SearchContentCell.self, forCellReuseIdentifier: SearchContentCell.cellId)
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // 네비게이션 바 숨김 설정
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        // 다른 뷰로 이동할 때 네비게이션 바 보이도록 설정
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tempData[indexPath.row]
         
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchContentCell.cellId, for: indexPath) as! SearchContentCell
        cell.selectionStyle = .none
         // Assuming you have images added in assets
        cell.profileImageView.image = UIImage(named: data.profileImage)
        cell.titleLabel.text = data.title
        cell.creatorLabel.text = data.creator
        cell.createDateLabel.text = data.createdAt
        cell.categoryLabel.text = data.category
         // Assuming the first image for contentImages
        if let contentImage = data.contentImages.first {
            cell.contentImageView.image = UIImage(named: contentImage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let selectedData = tempData[indexPath.row]

        // 이동할 뷰 컨트롤러 초기화
        let vc = SearchRecordDetailVC()

        // 선택된 데이터를 디테일 뷰 컨트롤러에 전달
        vc.titleText = selectedData.title
        vc.creator = selectedData.creator
        vc.createdAt = selectedData.createdAt
        vc.category = selectedData.category
        vc.contentImage = selectedData.contentImages

        // 뷰 컨트롤러 표시
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupSearchField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.rcGray300,
            NSAttributedString.Key.font: UIFont.rcFont16M(),
            NSAttributedString.Key.baselineOffset: -1.0
        ])
        searchTextField.attributedPlaceholder = attributedPlaceholder
        
        let searchIconImageView = UIImageView(frame: CGRect(x: 10, y: 8, width: 21, height: 21))
        if let image = UIImage(named: "Search_icon")?.resizeImage(size: CGSize(width: 21, height: 21)) {
            searchIconImageView.image = image.withRenderingMode(.alwaysTemplate)
            searchIconImageView.tintColor = UIColor(hexCode: "#6B6D83")
        }
        searchIconImageView.contentMode = .center
        
        let imageContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 37, height: 37))
        imageContainerView.addSubview(searchIconImageView)
        // Set the left view of the text field to the search icon image view
        searchTextField.leftView = imageContainerView
        searchTextField.leftViewMode = .always
        
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func setupContentView() {
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentsView)
        contentsView.addSubview(categoryView)
        contentsView.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            contentsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            categoryView.topAnchor.constraint(equalTo: contentsView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 60),
            
            contentTableView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 0),
            contentTableView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        
        setupCategoryButtons()

    }
    
    func setupCategoryButtons() {
        
        // Add scrollView to categoryView

        categoryView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: categoryView.topAnchor),
            categoryScrollView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor),
            categoryScrollView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor)
        ])
        
        // Define categories
        let categories = ["전체", "뮤지컬", "전시회", "콘서트", "스포츠", "영화", "독서", "기타"]
        
        var previousButton: UIButton?

        for category in categories {
            // Create button
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
            button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false

            // Add button to scrollView
            categoryScrollView.addSubview(button)

            // Set button constraints
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: 65),
                button.heightAnchor.constraint(equalToConstant: 31)
            ])
            
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 8)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 16)
                ])
            }

            previousButton = button

            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
        }

        // Set content size of scrollView based on buttons
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -16)
            ])
        }
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        // Update UI based on selected category
        if let selectedCategory = sender.currentTitle {
            self.selectedCategory = selectedCategory
            updateCategoryButtonAppearance()
            print("\(selectedCategory) 버튼 선택됨")
            // Perform actions based on selected category...
        }
    }

    func updateCategoryButtonAppearance() {
        // Iterate through scrollView's subviews to update buttons
        for case let button as UIButton in categoryScrollView.subviews {
            if let category = button.currentTitle {
                button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
                button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            }
        }
    }

}

class SearchContentCell: UITableViewCell {
    
    static let cellId = "CellId"
    
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
        label.font = UIFont.rcFont16B()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
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
        label.font = UIFont.rcFont14M()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.textColor = UIColor.rcMain
        label.backgroundColor = UIColor.rcGrayBg
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
        imageview.layer.cornerRadius = 6
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(separateLineImageView)
        contentView.addSubview(createDateLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(contentImageView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),
            profileImageView.widthAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.widthAnchor.constraint(equalToConstant: 160),
            
            creatorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            creatorLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            creatorLabel.heightAnchor.constraint(equalToConstant: 14),
            
            separateLineImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            separateLineImageView.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 8),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            
            createDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            createDateLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            createDateLabel.heightAnchor.constraint(equalToConstant: 14),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(equalToConstant: 49),
            
            contentImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            contentImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentImageView.heightAnchor.constraint(equalToConstant: 78),
            contentImageView.widthAnchor.constraint(equalToConstant: 78)
            
        ])
        
    }
    
    
}


