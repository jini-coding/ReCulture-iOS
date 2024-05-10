//
//  HomeVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Views
//    let label: UILabel = {
//        let label = UILabel()
//        label.text = "HomeVC"
//        label.textColor = UIColor.rcMain
//        label.font = UIFont.rcFont26B()
//
//        return label
//    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("이동", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let currentLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 레벨"
        label.font = UIFont.rcFont14M()
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .rcMain
        view.layer.cornerRadius = 155/2
        return view
    }()
    
    private let tilNextLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "[다음 레벨]까지 얼마 남지 않았어요!"
        label.font = UIFont.rcFont14B()
        return label
    }()
    
    private let levelProgressBar = LevelProgressBar()
    
    private let monthlyRecordLabel: UILabel = {
        let label = UILabel()
        label.text = "📊 4월 기록 한 눈에 보기"
        label.font = UIFont.rcFont20B()
        return label
    }()
    
    private lazy var calendarView = CustomCalendarView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNavigation()
        // set up layout
        setCurrentLevelLabel()
        setCharacterImageView()
        setTilNextLevelLabel()
        setLevelProgressBar()
        setMonthlyRecordLabel()
        setCalendarView()
    }
    
    // MARK: - Layouts
    
    private func setupNavigation(){
        self.navigationItem.title = "로고"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font
                                                                        : UIFont.rcFont20B()]
    }
    
//    func setTestLabel() {
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
//            label.heightAnchor.constraint(equalToConstant: 23)
//        ])
//    }
    
    private func setCurrentLevelLabel(){
        currentLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(currentLevelLabel)
        
        NSLayoutConstraint.activate([
            currentLevelLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            currentLevelLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func setCharacterImageView(){
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(characterImageView)
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: currentLevelLabel.bottomAnchor, constant: 10),
            characterImageView.widthAnchor.constraint(equalToConstant: 155),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setTilNextLevelLabel(){
        tilNextLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tilNextLevelLabel)
        
        NSLayoutConstraint.activate([
            tilNextLevelLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            tilNextLevelLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 15)
        ])
    }
    
    private func setLevelProgressBar(){
        levelProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(levelProgressBar)
        
        NSLayoutConstraint.activate([
            levelProgressBar.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            levelProgressBar.topAnchor.constraint(equalTo: tilNextLevelLabel.bottomAnchor, constant: 15),
        ])
    }
    
    private func setMonthlyRecordLabel(){
        monthlyRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(monthlyRecordLabel)
        
        NSLayoutConstraint.activate([
            monthlyRecordLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 19),
            monthlyRecordLabel.topAnchor.constraint(equalTo: levelProgressBar.bottomAnchor, constant: 45)
        ])
    }
    
    private func setCalendarView(){
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            calendarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            calendarView.topAnchor.constraint(equalTo: monthlyRecordLabel.bottomAnchor, constant: 10),
            calendarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
