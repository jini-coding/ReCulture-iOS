//
//  RecordTypeVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class RecordTypeVC: UIViewController {
    
    // MARK: - Properties
    
    static var previousSelectedTabbarIndex = 0
    private let recordTypeList: [RecordType] = [.movie, .musical, .play, .sports, .concert, .drama, .book, .exhibition, .etc]
    private let minimumLineSpacing:CGFloat = 8
    private let minimumInteritemSpacing:CGFloat = 8
    private var selectedType: RecordType?
    
    // MARK: - Views
    
    private let headerView = HeaderView(title: "기록 추가", withCloseButton: false)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 추가"
        label.font = .rcFont16M()
        return label
    }()
    
    private lazy var typeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        return view
    }()
    
    private let whatDidYouDoLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 문화 생활을\n즐기셨나요?"
        label.font = .rcFont26B()
        label.numberOfLines = 2
        return label
    }()
    
    private let nextButton: NextButton = {
        let button = NextButton()
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        modalPresentationStyle = .fullScreen
        
        setHeaderView()
        setWhatDidYouDoLabel()
        setCollectionView()
        setNextButton()
    }
    
    override func viewDidLayoutSubviews() {
        print(typeCollectionView.bounds)

        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        typeCollectionView.register(RecordTypeCollectionViewCell.self,
                      forCellWithReuseIdentifier: RecordTypeCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Layout
    
    private func setHeaderView(){
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        headerView.addBackButtonTarget(target: self, action: #selector(goBack), for: .touchUpInside)
    }
    
    private func setWhatDidYouDoLabel(){
        whatDidYouDoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(whatDidYouDoLabel)
        
        NSLayoutConstraint.activate([
            whatDidYouDoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatDidYouDoLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
        ])
    }
    
    private func setCollectionView(){
        typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(typeCollectionView)
        
        NSLayoutConstraint.activate([
            typeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            typeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            typeCollectionView.topAnchor.constraint(equalTo: whatDidYouDoLabel.bottomAnchor, constant: 50),
        ])
    }
    
    private func setNextButton(){
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nextButton.topAnchor.constraint(equalTo: typeCollectionView.bottomAnchor, constant: 40),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonDidTap(){
        let addRecordDetailVC = AddRecordDetailVC(type: selectedType!)
        addRecordDetailVC.modalPresentationStyle = .fullScreen
        self.present(addRecordDetailVC, animated: true)
    }
    
    @objc private func goBack() {
        print("이전 탭으로 이동")
        print(tabBarController?.selectedIndex)
        
        let alertController = UIAlertController(title: "정말 기록 추가를 그만하시겠어요?",
                                                message: "작성된 내용은 저장되지 않습니다.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        alertController.addAction(UIAlertAction(title: "나가기", style: .destructive, handler: { [weak self] action in
            self?.initializeViews()
            self?.tabBarController?.selectedIndex = RecordTypeVC.previousSelectedTabbarIndex
        }))
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Functions
    
    func initializeViews(){
        selectedType = nil
        typeCollectionView.deselectAllItems(animated: false)
        nextButton.isActive = false
    }
}

// MARK: - Extension: UICollectionView

extension RecordTypeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection: \(recordTypeList.count)")
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordTypeCollectionViewCell.identifier, for: indexPath) as? RecordTypeCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(recordTypeList[indexPath.item].rawValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextButton.isActive = true
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        selectedType = recordTypeList[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("size for item at: \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordTypeCollectionViewCell.identifier, for: indexPath) as? RecordTypeCollectionViewCell
        else { return .zero }
        cell.configure(recordTypeList[indexPath.item].rawValue)
//        let label = UILabel()
//        label.font = .rcFont18M()
//        label.text = "뮤지컬"
        
        let cellFrame = cell.getLabelFrame()
        let cellHeight = cellFrame.height + 30
        let cellWidth = CGFloat(collectionView.frame.width - 14 * 2)

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
