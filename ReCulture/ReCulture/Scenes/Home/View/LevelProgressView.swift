//
//  LevelProgressView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/18/24.
//

import UIKit

final class LevelProgressView: UIView {
    
    // MARK: - Properties
    
    private var progress: Float = 0
    
    // MARK: - Views
    
    private let progressBar: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        //view.progress = 0.78
        view.progressTintColor = .rcMain
        view.trackTintColor = UIColor(hexCode: "DFD8F5", alpha: 1)
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.layer.sublayers![1].cornerRadius = 6
        view.subviews[1].clipsToBounds = true
        return view
    }()
    
    private let tooltipView = ToolTipView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tooltipView.levelProgressView = self
        
        setupProgressBar()
        setupToolTipView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupProgressBar() {
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: self.topAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupToolTipView() {
        tooltipView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tooltipView)
        
        NSLayoutConstraint.activate([
            tooltipView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            tooltipView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ])
    }
    
    // MARK: - Function
    
    func setProgress(_ progress: Float) {
        tooltipView.removeToolTipView()
        tooltipView.removeFromSuperview()
        setupToolTipView()
        
        tooltipView.tooltipViewTrailingConstraint?.isActive = false
        
        progressBar.progress = progress
        
        self.layoutIfNeeded()
        print("self.frame.width: \(self.frame.width)")
        print("progressBar.frame.height: \(progressBar.frame.height)")
        // tool tip의 tip의 위치, 크기 세팅, 그리기
        tooltipView.drawTip(tipStartX: self.frame.width * CGFloat(progress) - 8 / 2,
                            tipStartY: progressBar.frame.height + 8,
                            tipWidth: 8,
                            tipHeight: 7)
        print("tooltipView.frame.width: \(tooltipView.frame.width)") // 32
        // 툴팁에 text 지정
        tooltipView.configure(text: "\(Int(progress * 100))% 달성!")
        tooltipView.layoutIfNeeded()
        print("tooltipView.frame.width: \(tooltipView.frame.width)")
        print("tooltipView.frame.x: \(tooltipView.frame.origin.x)")
        tooltipView.tooltipViewTrailingConstraint = tooltipView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.width * CGFloat((1-progress)) + tooltipView.frame.width / 2)
        tooltipView.tooltipViewTrailingConstraint?.isActive = true
//        tooltipView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.width * CGFloat((1-progress)) + tooltipView.frame.width / 2).isActive = true
    }
}
