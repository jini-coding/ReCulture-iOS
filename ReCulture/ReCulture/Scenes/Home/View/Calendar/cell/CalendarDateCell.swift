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
    
    private let cellBgColors = [
        "C1CFFF", // 1~2개
        "9997FF", // 3~4개
        // 5개 이상부터는 main색
    ]
    
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
        
        self.contentView.clipsToBounds = true
        
        setDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("=== calendar date cell, preparing for reuse ===")
        self.contentView.backgroundColor = .white
    }
    
    // MARK: - Layout
    
    private func setDateLabel(){
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: - Functions
    
    func configure(section: Int, dateOrDay: String, recordCount: Int = 0){
        if section == 0 {
            dateLabel.font = .rcFont14M()
            dateLabel.textColor = UIColor.rcGray400
        }
        else {
            dateLabel.font = .rcFont18M()
            dateLabel.textColor = .black
            // 날이 있는 셀에만! (공백인 셀도 있음)
            if dateOrDay != "" {
                var color = UIColor()
                
                if recordCount != 0 {
                    if recordCount == 1 || recordCount == 2 {
                        color = UIColor(hexCode: cellBgColors[0])
                    }
                    else if recordCount == 3 || recordCount == 4 {
                        color = UIColor(hexCode: cellBgColors[1])
                    }
                    else {
                        color = .rcMain
                    }
                }
                else {
                    color = .white
                }
                setBgColor(color)
            }
        }
        self.dateLabel.text = dateOrDay
    }
    
    private func setBgColor(_ color: UIColor){
        self.contentView.layer.cornerRadius = self.frame.width / 2
        self.contentView.backgroundColor = color
        
        if color != .white {
            self.dateLabel.textColor = .white
        }
    }
}
