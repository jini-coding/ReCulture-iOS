//
//  RecordTypeVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class RecordTypeVC: UIViewController {
    
    // MARK: - Properties
    
    private let recordTypeList:[RecordType] = [.movie, .musical, .play, .sports, .concert, .drama, .book, .exhibition, .etc]
    private let minimumLineSpacing:CGFloat = 8
    private let minimumInteritemSpacing:CGFloat = 8
    private var selectedType: RecordType?
    
    // MARK: - Views
    
    private let headerView = HeaderView()
    
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
        view.dataSource = self
        view.delegate = self
        view.register(RecordTypeCollectionViewCell.self, forCellWithReuseIdentifier: RecordTypeCollectionViewCell.identifier)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        self.modalPresentationStyle = .fullScreen
        
        setHeaderView()
        //setupNavigation()
        setWhatDidYouDoLabel()
        setCollectionView()
        setNextButton()
    }
    
    // MARK: - Layout
    
    private func setHeaderView(){
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        headerView.addBackButtonTarget(target: self, action: #selector(goBack), for: .touchUpInside)
    }
    
    private func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
    }
    
    private func setWhatDidYouDoLabel(){
        whatDidYouDoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(whatDidYouDoLabel)
        
        NSLayoutConstraint.activate([
            whatDidYouDoLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatDidYouDoLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
        ])
    }
    
    private func setCollectionView(){
        typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(typeCollectionView)
        
        NSLayoutConstraint.activate([
            typeCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 14),
            typeCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -14),
//            typeCollectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50),
            typeCollectionView.topAnchor.constraint(equalTo: whatDidYouDoLabel.bottomAnchor, constant: 50),
        ])
    }
    
    private func setNextButton(){
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nextButton.topAnchor.constraint(equalTo: typeCollectionView.bottomAnchor, constant: 50),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
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
        print(self.tabBarController?.selectedIndex)
        self.dismiss(animated: true, completion: nil)
    }
}

extension RecordTypeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordTypeList.count
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordTypeCollectionViewCell.identifier, for: indexPath) as? RecordTypeCollectionViewCell else {
                                return .zero
                            }
        cell.configure(recordTypeList[indexPath.item].rawValue)

        let cellFrame = cell.getLabelFrame()
        let cellHeight = cellFrame.height + 30
        let cellWidth = CGFloat(collectionView.frame.width - 14 * 2)

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
