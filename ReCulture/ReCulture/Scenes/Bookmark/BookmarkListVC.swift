//
//  BookmarkListVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/7/24.
//

import UIKit

class BookmarkListVC: UIViewController {
    
    // MARK: - Properties
    
    private let tagMinimumLineSpacing: CGFloat = 0
    private let tagMinimumInterItemSpacing: CGFloat = 8
    private var isAllTagSelected = true  // 태그 필터링 초기화 - 전체로
    private var selectedCategory: RecordType = .all
    
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
            recordTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            recordTableView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            recordTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Functions
    
    private func filterRecordsBy(_ type: RecordType){
//        filteredTickets.removeAll()
//        
//        if type != .all {
//            for i in 0 ..< viewModel.getMyTicketBookCount() {
//                let data = viewModel.getMyTicketBookDetailAt(i)
//                if data.categoryType == type {
//                    print(data)
//                    filteredTickets.append(data)
//                }
//            }
//        }
//        
//        ticketCollectionView.reloadData()
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
        // ✅ sizeToFit() : 텍스트에 맞게 사이즈가 조절

        // ✅ cellWidth = 글자수에 맞는 UILabel 의 width + 24(여백)
        let cellFrame = cell.getLabelFrame()
        let cellWidth = cellFrame.width + 24
        let cellHeight = cellFrame.height + 12

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Extension: UITableView

extension BookmarkListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchContentCell.cellId, for: indexPath) as? SearchContentCell else { return UITableViewCell() }
        
        return cell
    }
}
