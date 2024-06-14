//
//  CustomizingTwoVC.swift
//  ReCulture
//
//  Created by Jini on 6/2/24.
//

import UIKit

class CustomizingTwoVC: UIViewController {
    
    let item = ["영화", "뮤지컬", "연극", "스포츠", "콘서트", "드라마", "독서", "전시회", "기타"]
    
    var selectedItem = ""

    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 문화생활을\n즐기고 오셨나요?"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCategoryCell.self, forCellWithReuseIdentifier: CustomCategoryCell.identifier)
        
        setupGuide()
        setupCollectionView()
    }
    
    func setupGuide() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(guideLabel)
        
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 25),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}

extension CustomizingTwoVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCategoryCell.identifier, for: indexPath) as? CustomCategoryCell else {
            return UICollectionViewCell()
        }
        cell.label.text = item[indexPath.item]
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = item[indexPath.item]
        print("선택된 카테고리: \(selectedItem)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 3 // 3*3
        return CGSize(width: width, height: width)
    }
}

class CustomCategoryCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                contentView.layer.borderColor = UIColor.rcMain.cgColor
                contentView.layer.borderWidth = 2
                contentView.backgroundColor = .rcLightPurple
                label.font = .rcFont18B()
                label.textColor = .rcMain
            }
            else {
                contentView.layer.borderColor = nil
                contentView.layer.borderWidth = 0
                contentView.backgroundColor = .rcGrayBg
                label.font = .rcFont18M()
                label.textColor = UIColor(hexCode: "A9ABB8")
            }
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .rcFont18M()
        label.textColor = UIColor(hexCode: "A9ABB8")
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .rcGrayBg
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
        
        setLabel()
    }
    
    private func setLabel(){
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

