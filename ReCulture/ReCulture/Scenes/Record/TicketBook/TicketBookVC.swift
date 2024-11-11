//
//  TicketBookVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/10/24.
//

import UIKit

final class TicketBookVC: UIViewController, TicketCustomizingDelegate {
    
    // MARK: - Properties
    
    private let tagMinimumLineSpacing: CGFloat = 0
    private let tagMinimumInterItemSpacing: CGFloat = 8
    private let ticketMinimumLineSpacing: CGFloat = 16
    private let ticketMinimumInteritemSpacing: CGFloat = 16
    
    private let viewModel = TicketBookViewModel()
    private var filteredTickets: [MyTicketBookModel] = []  // 필터링한 티켓북을 담을 배열
    private var isFiltering = false  // 필터링 되고 있는 상태인지의 유무 - false면 viewModel의 데이터 사용
    private var selectedCategory: RecordType = .all
    
    private var isAllTagSelected = true  // 태그 필터링 초기화 - 전체로
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 티켓북"
        label.font = .rcFont18B()
        label.textAlignment = .left
        return label
    }()
    
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
    
    private lazy var ticketCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = ticketMinimumLineSpacing
        flowlayout.minimumInteritemSpacing = ticketMinimumLineSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        view.dataSource = self
        view.delegate = self
        view.register(TicketBookCollectionViewCell.self, forCellWithReuseIdentifier: TicketBookCollectionViewCell.identifier)
        return view
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        let label = UILabel()
        
        label.text = "아직 만들어진 티켓이 없어요"
        label.textColor = UIColor.rcGray300
        label.font = UIFont.rcFont16M()
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        bind()
        
        setupNavigation()
        
        setTagCollectionView()
        setTicketCollectionView()
        
        setupEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getMyTicketBook(fromCurrentVC: self)
    }
    
    // MARK: - Layout
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
        
        let addNewButtonItem = UIBarButtonItem(image: UIImage.addIcon, style: .done, target: self, action: #selector(addNewButtonTapped))

        // left bar button을 추가하면 기존의 스와이프 pop 기능이 해제되므로 다시 세팅
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.navigationItem.rightBarButtonItem = addNewButtonItem
    }
    
    private func setTagCollectionView() {
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tagCollectionView)
        
        NSLayoutConstraint.activate([
            tagCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 33),
            
        ])
    }
    
    private func setTicketCollectionView() {
        ticketCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ticketCollectionView)
        
        NSLayoutConstraint.activate([
            ticketCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            ticketCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            ticketCollectionView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 20),
            ticketCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupEmptyView() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func updateEmptyView() {
        let hasData = viewModel.getMyTicketBookCount() > 0
        emptyView.isHidden = hasData
    }
    
    private func bind() {
        viewModel.myTicketBookListDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.updateEmptyView()
                self?.ticketCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewButtonTapped() {
        let vc = TicketCustomizingVC()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFinishCustomizingTicket() {
        // Fetch the updated list of tickets
        viewModel.getMyTicketBook(fromCurrentVC: self)
    }
    
    // MARK: - Functions
    
    private func filterTicketsBy(_ type: RecordType) {
        filteredTickets.removeAll()
        
        if type != .all {
            for i in 0 ..< viewModel.getMyTicketBookCount() {
                let data = viewModel.getMyTicketBookDetailAt(i)
                if data.categoryType == type {
                    print(data)
                    filteredTickets.append(data)
                }
            }
        }
        
        ticketCollectionView.reloadData()
    }
}

// MARK: - Extension: UIGestureRecognizerDelegate

extension TicketBookVC: UIGestureRecognizerDelegate { }

// MARK: - Extension: CollectionView

extension TicketBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView{
            return RecordType.allTypesWithAll.count
        }
        else{
            if selectedCategory == .all {
                return viewModel.getMyTicketBookCount()
            }
            else {
                return filteredTickets.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(tag: RecordType.allTypesWithAll[indexPath.item].rawValue)
            if indexPath.item == 0 && isAllTagSelected {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                cell.isSelected = true
            }
            return cell
        }
        else {
            guard let cell = ticketCollectionView.dequeueReusableCell(withReuseIdentifier: TicketBookCollectionViewCell.identifier, for: indexPath) as? TicketBookCollectionViewCell else { return UICollectionViewCell() }
            
            // 전체로 필터링하는 경우
            if selectedCategory == .all {
                cell.configure(viewModel.getMyTicketBookDetailAt(indexPath.item))
            }
            // 그외의 경우
            else {
                cell.configure(filteredTickets[indexPath.item])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            isAllTagSelected = false
            selectedCategory = RecordType.allTypesWithAll[indexPath.item]
            print("selected filter item: \(selectedCategory.rawValue)")
            filterTicketsBy(selectedCategory)
        }
        else {
            if selectedCategory == .all {
                let ticketBookDetailVC = TicketBookDetailVC(model: viewModel.getMyTicketBookDetailAt(indexPath.item))
                ticketBookDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ticketBookDetailVC, animated: true)
            }
            else {
                let ticketBookDetailVC = TicketBookDetailVC(model: filteredTickets[indexPath.item])
                ticketBookDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(ticketBookDetailVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == tagCollectionView{
            return tagMinimumLineSpacing
        }
        else {
            return ticketMinimumLineSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == tagCollectionView {
            return tagMinimumInterItemSpacing
        }
        else {
            return ticketMinimumInteritemSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
                        return .zero
                    }
            
            cell.configure(tag: RecordType.allTypesWithAll[indexPath.item].rawValue)

            let cellFrame = cell.getLabelFrame()
            let cellWidth = cellFrame.width + 24
            let cellHeight = cellFrame.height + 12

            return CGSize(width: cellWidth, height: cellHeight)
        }
        else {
            let cellWidth = CGFloat((collectionView.frame.width - 16 * 2 - ticketMinimumInteritemSpacing) / 2)  // 16은 collectionview inset
            return CGSize(width: cellWidth, height: cellWidth * 26 / 17)
        }
    }
}
