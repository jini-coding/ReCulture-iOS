//
//  ToolTipView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/18/24.
//

import UIKit

final class ToolTipView: UIView {
    
    // MARK: - Properties
    
    var levelProgressView: LevelProgressView?
    var tooltipViewTrailingConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .rcFont14M()
        label.textColor = .white
        return label
    }()
    
    private var shape = CAShapeLayer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        self.backgroundColor = .rcMain
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 9
    }
      
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    private func setLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Functions
    
    func configure(text: String) {
        self.label.text = text
    }
    
    func drawTip(tipStartX: CGFloat,
                 tipStartY: CGFloat,
                 tipWidth: CGFloat,
                 tipHeight: CGFloat) {
        setLabel()
        
        let path = CGMutablePath()

        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth

        path.move(to: CGPoint(x: tipStartX, y: tipStartY))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: tipStartY-tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: tipStartY))
        path.addLine(to: CGPoint(x: tipStartX, y: tipStartY))

        shape.path = path
        shape.fillColor = UIColor.rcMain.cgColor
        
        levelProgressView?.layer.insertSublayer(shape, at: 0)
    }
    
    func removeToolTipView() {
        label.removeFromSuperview()
        shape.removeFromSuperlayer()
    }
}
