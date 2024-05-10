//
//  LevelProgressBar.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/3/24.
//

import UIKit

class LevelProgressBar: UIView {
    
    // MARK: - Views
    
    let levelDot0 = LevelProgressDot()
    let levelDot1 = LevelProgressDot()
    let levelDot2 = LevelProgressDot()
    let levelDot3 = LevelProgressDot()
    
    let levelBar0 = LevelProgressLine()
    let levelBar1 = LevelProgressLine()
    let levelBar2 = LevelProgressLine()
    
    let levelLabel0: UILabel = {
        let label = UILabel()
        label.text = "🌱"
        label.font = UIFont.rcFont16B()
        return label
    }()
    
    let levelLabel1: UILabel = {
        let label = UILabel()
        label.text = "☘️"
        label.font = UIFont.rcFont16B()
        return label
    }()
    
    let levelLabel2: UILabel = {
        let label = UILabel()
        label.text = "🍀"
        label.font = UIFont.rcFont16B()
        return label
    }()
    
    let levelLabel3: UILabel = {
        let label = UILabel()
        label.text = "🌿"
        label.font = UIFont.rcFont16B()
        return label
    }()
    
    // MARK: - Properties
    
    let lineWidth = (UIScreen.main.bounds.size.width - 15 * 2 - 11 * 4) / 3
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLevelProgressViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupLevelProgressViews(){
        levelDot0.translatesAutoresizingMaskIntoConstraints = false
        levelDot1.translatesAutoresizingMaskIntoConstraints = false
        levelDot2.translatesAutoresizingMaskIntoConstraints = false
        levelDot3.translatesAutoresizingMaskIntoConstraints = false
        
        levelBar0.translatesAutoresizingMaskIntoConstraints = false
        levelBar1.translatesAutoresizingMaskIntoConstraints = false
        levelBar2.translatesAutoresizingMaskIntoConstraints = false
        
        levelLabel0.translatesAutoresizingMaskIntoConstraints = false
        levelLabel1.translatesAutoresizingMaskIntoConstraints = false
        levelLabel2.translatesAutoresizingMaskIntoConstraints = false
        levelLabel3.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(levelDot0)
        addSubview(levelDot1)
        addSubview(levelDot2)
        addSubview(levelDot3)
        
        addSubview(levelBar0)
        addSubview(levelBar1)
        addSubview(levelBar2)
        
        addSubview(levelLabel0)
        addSubview(levelLabel1)
        addSubview(levelLabel2)
        addSubview(levelLabel3)
        
        NSLayoutConstraint.activate([
            levelDot0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            levelDot0.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            levelDot0.widthAnchor.constraint(equalToConstant: 11),
            levelDot0.heightAnchor.constraint(equalTo: levelDot0.widthAnchor, multiplier: 1)
        ])
            
        NSLayoutConstraint.activate([
            levelBar0.leadingAnchor.constraint(equalTo: levelDot0.trailingAnchor),
            levelBar0.trailingAnchor.constraint(equalTo: levelDot1.leadingAnchor),
            levelBar0.heightAnchor.constraint(equalToConstant: 2),
            levelBar0.widthAnchor.constraint(equalToConstant: lineWidth),
            levelBar0.centerYAnchor.constraint(equalTo: levelDot0.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            levelDot1.widthAnchor.constraint(equalToConstant: 11),
            levelDot1.heightAnchor.constraint(equalTo: levelDot1.widthAnchor, multiplier: 1),
            levelDot1.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            levelBar1.leadingAnchor.constraint(equalTo: levelDot1.trailingAnchor),
            levelBar1.trailingAnchor.constraint(equalTo: levelDot2.leadingAnchor),
            levelBar1.heightAnchor.constraint(equalToConstant: 2),
            levelBar1.widthAnchor.constraint(equalToConstant: lineWidth),
            levelBar1.centerYAnchor.constraint(equalTo: levelDot1.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            levelDot2.widthAnchor.constraint(equalToConstant: 11),
            levelDot2.heightAnchor.constraint(equalTo: levelDot2.widthAnchor, multiplier: 1),
            levelDot2.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            levelBar2.leadingAnchor.constraint(equalTo: levelDot2.trailingAnchor),
            levelBar2.trailingAnchor.constraint(equalTo: levelDot3.leadingAnchor),
            levelBar2.heightAnchor.constraint(equalToConstant: 2),
            levelBar2.widthAnchor.constraint(equalToConstant: lineWidth),
            levelBar2.centerYAnchor.constraint(equalTo: levelDot2.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            levelDot3.widthAnchor.constraint(equalToConstant: 11),
            levelDot3.heightAnchor.constraint(equalTo: levelDot3.widthAnchor, multiplier: 1),
            levelDot3.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            levelDot3.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            levelLabel0.topAnchor.constraint(equalTo: levelDot0.bottomAnchor, constant: 2),
            levelLabel0.centerXAnchor.constraint(equalTo: levelDot0.centerXAnchor),
            levelLabel0.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            levelLabel1.topAnchor.constraint(equalTo: levelDot1.bottomAnchor, constant: 2),
            levelLabel1.centerXAnchor.constraint(equalTo: levelDot1.centerXAnchor),
            levelLabel1.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            levelLabel2.topAnchor.constraint(equalTo: levelDot2.bottomAnchor, constant: 2),
            levelLabel2.centerXAnchor.constraint(equalTo: levelDot2.centerXAnchor),
            levelLabel2.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            levelLabel3.topAnchor.constraint(equalTo: levelDot3.bottomAnchor, constant: 2),
            levelLabel3.centerXAnchor.constraint(equalTo: levelDot3.centerXAnchor),
            levelLabel3.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
