//
//  CalendarDetailCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 7/30/24.
//

import UIKit

class CalendarDetailCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CalendarDetailCell"
    
    // MARK: - Views
    
    private let recordImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    private let titleCategoryStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 6
        view.alignment = .leading
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "민경아 록시를 드디어 보다!"
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .rcFont16M()
        return label
    }()
    
    private let categoryLabel: LabelWithPadding = {
        let label = LabelWithPadding(top: 4, left: 5, bottom: 4, right: 5)
        label.text = "뮤지컬"
        label.font = .rcFont12M()
        label.textColor = .rcMain
        label.backgroundColor = .rcGrayBg
        return label
    }()
    
    private let moveToRecordImageView: UIImageView = {
        let view = UIImageView()
        view.image = .chevronRightBig
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setupRecordImageView()
        setupContentStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupRecordImageView() {
        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(recordImageView)
        
        NSLayoutConstraint.activate([
            recordImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            recordImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recordImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recordImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recordImageView.widthAnchor.constraint(equalTo: recordImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setupContentStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        titleCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
        moveToRecordImageView.translatesAutoresizingMaskIntoConstraints = false

        titleCategoryStackView.addArrangedSubview(titleLabel)
        titleCategoryStackView.addArrangedSubview(categoryLabel)
        
        contentStackView.addArrangedSubview(titleCategoryStackView)
        contentStackView.addArrangedSubview(moveToRecordImageView)
        
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: recordImageView.trailingAnchor, constant: 10),
            contentStackView.centerYAnchor.constraint(equalTo: recordImageView.centerYAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupTitleCategoryStackView() {
        titleCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleCategoryStackView)
        
        titleCategoryStackView.addArrangedSubview(titleLabel)
        titleCategoryStackView.addArrangedSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            titleCategoryStackView.leadingAnchor.constraint(equalTo: recordImageView.trailingAnchor, constant: 15),
            titleCategoryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleCategoryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    
    private func setupMoveToRecordButton() {
        moveToRecordImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(moveToRecordImageView)
        
        NSLayoutConstraint.activate([
            moveToRecordImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleCategoryStackView.trailingAnchor, constant: 5),
            moveToRecordImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            moveToRecordImageView.centerYAnchor.constraint(equalTo: titleCategoryStackView.centerYAnchor),
            moveToRecordImageView.heightAnchor.constraint(equalTo: moveToRecordImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    // MARK: - Actions
    
    // MARK: - Functions
}
