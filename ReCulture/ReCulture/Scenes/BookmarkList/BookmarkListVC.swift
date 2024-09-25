//
//  BookmarkListVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/7/24.
//

import UIKit

final class BookmarkListVC: UIViewController {
    
    // MARK: - Properties
    
    private let tagMinimumLineSpacing: CGFloat = 0
    private let tagMinimumInterItemSpacing: CGFloat = 8
    private let viewModel = BookmarkListViewModel()
    private var isAllTagSelected = true  // 태그 필터링 초기화 - 전체로
    private var selectedCategory: RecordType = .all
    private var filteredRecords: [BookmarkListModel] = []  // 필터링한 기록들을 담을 배열
    
    // MARK: - Views
    
    private lazy var tagCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = tagMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = tagMinimumInterItemSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        return view
    }()
    
    private lazy var recordTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchContentCell.self, forCellReuseIdentifier: SearchContentCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTagCollectionView()
        setupRecordTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getBookmarkList(fromCurrentVC: self)
    }
    
    // MARK: - Layouts
    
    private func setupNavigationBar() {
        self.navigationItem.title = "내 북마크"
    }
    
    private func setupTagCollectionView() {
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tagCollectionView)
        
        NSLayoutConstraint.activate([
            tagCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 33),
            
        ])
    }
    
    private func setupRecordTableView() {
        recordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(recordTableView)
        
        NSLayoutConstraint.activate([
            recordTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            recordTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:  -16),
            recordTableView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            recordTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Functions
    
    private func filterRecordsBy(_ type: RecordType) {
        filteredRecords.removeAll()
        
        if type != .all {
            for i in 0 ..< viewModel.getBookmarkCount() {
                let data = viewModel.getBookmarkAt(i)
                if data.categoryType == type {
                    print(data)
                    filteredRecords.append(data)
                }
            }
        }
        
        recordTableView.reloadData()
    }
    
    private func bind() {
        viewModel.bookmarkListDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.recordTableView.reloadData()
            }
        }
    }
}

// MARK: - Extension: CollectionView

extension BookmarkListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecordType.allTypesWithAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                               for: indexPath) as? TagCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(tag: RecordType.allTypesWithAll[indexPath.item].rawValue)
        
        if indexPath.item == 0 && isAllTagSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isAllTagSelected = false
        selectedCategory = RecordType.allTypesWithAll[indexPath.item]
        print("selected filter item: \(selectedCategory.rawValue)")
        filterRecordsBy(selectedCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                               for: indexPath) as? TagCollectionViewCell
        else { return .zero }
        
        cell.configure(tag: RecordType.allTypesWithAll[indexPath.item].rawValue)

        let cellFrame = cell.getLabelFrame()
        let cellWidth = cellFrame.width + 24
        let cellHeight = cellFrame.height + 12

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Extension: UITableView

extension BookmarkListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCategory == .all {
            return viewModel.getBookmarkCount()
        }
        else {
            return filteredRecords.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchContentCell.cellId, for: indexPath) as? SearchContentCell else { return UITableViewCell() }
        cell.selectionStyle = .none

        var bookmarkData: BookmarkListModel?
        
        // 전체로 필터링하는 경우
        if selectedCategory == .all {
            bookmarkData = viewModel.getBookmarkAt(indexPath.row)
        }
        // 그외의 경우
        else {
            bookmarkData = filteredRecords[indexPath.row]
        }
                
        let authorId = bookmarkData?.postOwnerId
        
        cell.creatorLabel.text = bookmarkData?.postOwnerNickname ?? "unknown"
        cell.titleLabel.text = bookmarkData?.title ?? "unknown"
        if let profileImage = bookmarkData?.postOwnerProfileImage {
            cell.profileImageView.loadImage(urlWithoutBaseURL: profileImage)
        }

        if let date = bookmarkData?.date.toDate() {
            cell.createDateLabel.text = date.toString()
        } else {
            cell.createDateLabel.text = bookmarkData?.date
        }
        
        cell.categoryLabel.text = bookmarkData?.categoryType.rawValue
        
        if let urlString = bookmarkData?.firstImageURL {
            cell.contentImageView.loadImage(urlWithoutBaseURL: urlString)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번째 기록 선택됨")
        var bookmarkData: BookmarkListModel?
        
        // 전체로 필터링된 경우
        if selectedCategory == .all {
            bookmarkData = viewModel.getBookmarkAt(indexPath.row)
        }
        // 그외의 경우
        else {
            bookmarkData = filteredRecords[indexPath.row]
        }
        
        // TODO: 내가 작성한 글을 북마크하지는 못하므로 바로 search record detail vc로 .. (확인 필요)
        let vc = SearchRecordDetailVC()

        // 선택된 데이터를 디테일 뷰 컨트롤러에 전달
        if let postId = bookmarkData?.postId {
            vc.recordId = postId
        }
        if let postOwnerNickname = bookmarkData?.postOwnerNickname {
            vc.creator = "\(postOwnerNickname)"
        }

        // 뷰 컨트롤러 표시
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
