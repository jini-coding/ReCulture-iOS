//
//  HomeVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    let viewModel = HomeViewModel()
    
    // MARK: - Views
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .appLogo
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcMain
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.backgroundColor = UIColor(hexCode: "F5F6FA")
        return view
    }()
    
    private let contentView = UIView()
    
    private let userLevelInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rcGrayBg
        return view
    }()
    
    private let currentLevelLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont16R()
        label.textColor = .white
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let tilNextLevelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14B()
        return label
    }()
    
    private let levelProgressView = LevelProgressView()
    
    private let calendarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let monthlyRecordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont20B()
        return label
    }()
    
    private lazy var calendarView: CustomCalendarView = {
        let view = CustomCalendarView()
        view.parentVC = self
        return view
    }()
    
    private lazy var tooltipView = ToolTipView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.rcMain

        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        print("앱 최초 실행 값: \(isFirstLaunch)")
        let userId = UserDefaults.standard.integer(forKey: "userId")
        print("id: \(userId)")
        print("access token: \(KeychainManager.shared.getToken(type: .accessToken))")
        print("refresh token: \(KeychainManager.shared.getToken(type: .refreshToken))")
        view.backgroundColor = .rcMain
        
        bind()
        viewModel.getMyProfile(fromCurrentVC: self)
        viewModel.getMyCalendar(yearAndMonthFormatted: getTodaysYearAndMonth(), fromCurrentVC: self)
        setupNavigation()
        
        // set up layout
        setupHeaderView()
        setScrollView()
        setContentView()
        setUserLevelInfoView()
        setCharacterImageView()
        setTilNextLevelLabel()
        setLevelProgressView()
        setCalendarContainerView()
        setMonthlyRecordLabel()
        setCalendarView()
        
        setCalendarMonthTo(calendarView.currentDateComponents.month!)
        
        scrollView.updateContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getMyProfile(fromCurrentVC: self)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Layouts
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground()
//        appearance.backgroundColor = .rcMain
//      
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        currentLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        headerView.addSubview(logoImageView)
        headerView.addSubview(currentLevelLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 35),
            
            logoImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            logoImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 45),
            logoImageView.heightAnchor.constraint(equalToConstant: 45),
            
            currentLevelLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            currentLevelLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            currentLevelLabel.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    private func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
                
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setUserLevelInfoView() {
        userLevelInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userLevelInfoView)
        
        NSLayoutConstraint.activate([
            userLevelInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userLevelInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userLevelInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            //userLevelInfoView.bottomAnchor.constraint(equalTo: calendarContainerView.topAnchor),
        ])
    }
    
    private func setCharacterImageView() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userLevelInfoView.addSubview(characterImageView)
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: userLevelInfoView.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: userLevelInfoView.topAnchor, constant: 24),
            characterImageView.widthAnchor.constraint(equalToConstant: 145),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setTilNextLevelLabel() {
        tilNextLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userLevelInfoView.addSubview(tilNextLevelLabel)
        
        NSLayoutConstraint.activate([
            tilNextLevelLabel.centerXAnchor.constraint(equalTo: userLevelInfoView.centerXAnchor),
            tilNextLevelLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 36)
        ])
    }
    
    private func setLevelProgressView() {
        levelProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        userLevelInfoView.addSubview(levelProgressView)
        
        NSLayoutConstraint.activate([
            levelProgressView.leadingAnchor.constraint(equalTo: userLevelInfoView.leadingAnchor, constant: 30),
            levelProgressView.trailingAnchor.constraint(equalTo: userLevelInfoView.trailingAnchor, constant: -30),
            levelProgressView.topAnchor.constraint(equalTo: tilNextLevelLabel.bottomAnchor, constant: 7),
            levelProgressView.bottomAnchor.constraint(equalTo: userLevelInfoView.bottomAnchor)
        ])
    }
    
    private func setCalendarContainerView() {
        calendarContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(calendarContainerView)
        
        calendarContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        calendarContainerView.layer.cornerRadius = 12
        calendarContainerView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            calendarContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            calendarContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendarContainerView.topAnchor.constraint(equalTo: levelProgressView.bottomAnchor),
            calendarContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10)
        ])
    }
    
    private func setMonthlyRecordLabel() {
        monthlyRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        calendarContainerView.addSubview(monthlyRecordLabel)
        
        NSLayoutConstraint.activate([
            monthlyRecordLabel.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 24),
            monthlyRecordLabel.topAnchor.constraint(equalTo: calendarContainerView.topAnchor, constant: 24)
        ])
    }
    
    private func setCalendarView() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarContainerView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor, constant: -16),
            calendarView.topAnchor.constraint(equalTo: monthlyRecordLabel.bottomAnchor, constant: 15),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor, constant: -27)
        ])
        
        calendarContainerView.layoutIfNeeded()
    }
    
    // MARK: - Functions
    
    private func setCharacterImage() {
        switch viewModel.getLevelNum() {
        case 1: characterImageView.image = UIImage.character1
        case 2: characterImageView.image = UIImage.character2
        case 3: characterImageView.image = UIImage.character3
        default: characterImageView.image = UIImage.character4
        }
    }
    
    private func setLevelAttributes() {
        let levelNum = viewModel.getLevelNum()
        let text = "\(viewModel.getNickname())님은 Level \(levelNum)"
        print(text)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont.rcFont16B(), range: (text as NSString).range(of: "Level \(levelNum)"))
        currentLevelLabel.attributedText = attributedString
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: currentLevelLabel)
    }
    
    private func setLevelProgress() {
        let currentExp = viewModel.getExp()
        let totalScoreForThisLevel = LevelType.getTotalScoreOf(LevelType.getLevelTypeByLevelNum(viewModel.getLevelNum()))

        levelProgressView.setProgress(Float(currentExp) / Float(totalScoreForThisLevel))
    }
    
    private func setTilNextLevelValues() {
        let currentLevelType = LevelType.getLevelTypeByLevelNum(viewModel.getLevelNum())
        let nextLevelName = LevelType.getNextLevelOf(currentLevelType)
        let totalScoreForThisLevel = LevelType.getTotalScoreOf(currentLevelType)
        
        let percentLeftToNextLevel = 100 - Int((Float(viewModel.getExp()) / Float(totalScoreForThisLevel)) * 100)
        
        let text = (nextLevelName == .End) ? "✨ 탐험을 모두 마쳤어요! ✨" : "\(nextLevelName)가 되기까지 \(percentLeftToNextLevel)% 남았어요! 💪"
    
        tilNextLevelLabel.text = text
    }
    
    func setCalendarMonthTo(_ month: Int) {
        monthlyRecordLabel.text = "\(month)월 기록 한 눈에 보기"
    }
    
    /// 2024-09 와 같은형식으로 날짜 리턴
    private func getTodaysYearAndMonth() -> String {
        let now = Date()
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            df.dateFormat = "yyyy-MM"
            return df
        }()
        let currentYearAndMonth = dateFormatter.string(from: now)
        return currentYearAndMonth
    }
    
    private func bind() {
        viewModel.myProfileModelDidChange = { [weak self] in
            
            DispatchQueue.main.async {
                self?.setCharacterImage()
                self?.setLevelAttributes()
                self?.setLevelProgress()
                self?.setTilNextLevelValues()
            }
        }
        
        viewModel.myCalendarDataListDidSet = { [weak self] in
            self?.calendarView.setRecordDataList(self!.viewModel.getMyCalendarDataList())
        }
    }
}
