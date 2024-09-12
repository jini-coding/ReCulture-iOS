//
//  CalendarDetailModal.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 7/25/24.
//

import UIKit

class CalendarDetailModal: UIViewController {
    
    // MARK: - Properties
    
    private static let minimumLineSpacing: CGFloat = 12
    private static let minimumInteritemSpacing: CGFloat = 12
    
    private var recordDetailDataList: [MyCalendarRecordDetailModel] = []
    
    // MARK: - Views
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024.07.25"
        label.font = .rcFont18B()
        label.textColor = .rcGray800
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = CalendarDetailModal.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = CalendarDetailModal.minimumInteritemSpacing
        flowLayout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.allowsSelection = true
        view.allowsMultipleSelection = false
        view.register(CalendarDetailCell.self, forCellWithReuseIdentifier: CalendarDetailCell.identifier)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.4)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve

        setContentView()
        setDateLabel()
        setCollectionView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Layout
    
    private func setContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.47),
            contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ])
    }
    
    private func setCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 18),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Functions
    
    func configure(_ data: MyCalendarData) {
        recordDetailDataList.removeAll()
        dateLabel.text = "\(data.year).\(data.month).\(data.day)"
        recordDetailDataList = data.records
        collectionView.reloadData()
    }
}

// MARK: - Extension: UICollectionView

// TODO: 데이터 불러오는거에 맞게 수정
extension CalendarDetailModal: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordDetailDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDetailCell.identifier, for: indexPath) as? CalendarDetailCell else { return UICollectionViewCell() }
        let dataForThisCell = recordDetailDataList[indexPath.item]
        cell.configure(recordId: dataForThisCell.recordId,
                       photoURL: dataForThisCell.photoURL,
                       title: dataForThisCell.title,
                       categoryId: dataForThisCell.categoryId)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDetailCell
        print(cell.recordId)
        let dataForThisCell = recordDetailDataList[indexPath.item]
        
        // TODO: 지금 열린 이 모달 내리기
        
        // 상세 페이지로 이동
        let vc = RecordDetailVC()
        vc.recordId = dataForThisCell.recordId
        vc.creator = UserDefaultsManager.shared.getData(type: String.self, forKey: .nickname)

        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}
