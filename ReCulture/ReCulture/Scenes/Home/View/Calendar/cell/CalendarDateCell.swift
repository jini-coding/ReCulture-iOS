//
//  CalendarDateCell.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/3/24.
//

import UIKit

class CalendarDateCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CalendarDateCell"
    
    // MARK: - Views
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .rcFont14M()
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setDateLabel(){
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
//            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Functions
    
    func configure(section: Int, dateOrDay: String){
        if section == 0 {
            dateLabel.font = .rcFont14M()
            dateLabel.textColor = UIColor(hexCode: "85888A")
        }
        else {
            dateLabel.font = .rcFont18M()
            dateLabel.textColor = .black
        }
        self.dateLabel.text = dateOrDay
    }
}
