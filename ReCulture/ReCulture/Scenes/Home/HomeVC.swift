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
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 145/2
        view.clipsToBounds = true
        return view
    }()
    
    private let tilNextLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "[다음 레벨]까지 22% 남았어요!💪"
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
        label.text = "5월 기록 한 눈에 보기"
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
        viewModel.getMyProfile(fromCurrentVC: self)
        setupNavigation()
    }
    
    // MARK: - Layouts
    
    private func setupNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .rcMain
      
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
                
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setContentView(){
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
    
    private func setUserLevelInfoView(){
        userLevelInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userLevelInfoView)
        
        NSLayoutConstraint.activate([
            userLevelInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userLevelInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userLevelInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            //userLevelInfoView.bottomAnchor.constraint(equalTo: calendarContainerView.topAnchor),
        ])
    }
    
    private func setCharacterImageView(){
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userLevelInfoView.addSubview(characterImageView)
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: userLevelInfoView.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: userLevelInfoView.topAnchor, constant: 24),
            characterImageView.widthAnchor.constraint(equalToConstant: 145),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setTilNextLevelLabel(){
        tilNextLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userLevelInfoView.addSubview(tilNextLevelLabel)
        
        NSLayoutConstraint.activate([
            tilNextLevelLabel.leadingAnchor.constraint(equalTo: userLevelInfoView.leadingAnchor, constant: 30),
            tilNextLevelLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 36)
        ])
    }
    
    private func setLevelProgressView(){
        levelProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        userLevelInfoView.addSubview(levelProgressView)
        
        NSLayoutConstraint.activate([
            levelProgressView.leadingAnchor.constraint(equalTo: userLevelInfoView.leadingAnchor, constant: 30),
            levelProgressView.trailingAnchor.constraint(equalTo: userLevelInfoView.trailingAnchor, constant: -30),
            levelProgressView.topAnchor.constraint(equalTo: tilNextLevelLabel.bottomAnchor, constant: 7),
            levelProgressView.bottomAnchor.constraint(equalTo: userLevelInfoView.bottomAnchor)
        ])
    }
    
    private func setCalendarContainerView(){
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
    
    private func setMonthlyRecordLabel(){
        monthlyRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        calendarContainerView.addSubview(monthlyRecordLabel)
        
        NSLayoutConstraint.activate([
            monthlyRecordLabel.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor, constant: 24),
            monthlyRecordLabel.topAnchor.constraint(equalTo: calendarContainerView.topAnchor, constant: 24)
        ])
    }
    
    private func setCalendarView(){
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
    
    private func setCharacterImage(){
        characterImageView.loadImage(urlWithoutBaseURL: viewModel.getProfileImage())
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
        let currentLevelName = viewModel.getLevelName()
        let totalScoreForThisLevel = LevelType.getTotalScoreOf(LevelType(rawValue: currentLevelName)!)

        levelProgressView.setProgress(Float(currentExp) / Float(totalScoreForThisLevel))
    }
    
    private func setTilNextLevelValues() {
        let currentLevelType = LevelType(rawValue: viewModel.getLevelName())!
        let nextLevelName = LevelType.getNextLevelOf(currentLevelType)
        let totalScoreForThisLevel = LevelType.getTotalScoreOf(currentLevelType)
        
        let percentLeftToNextLevel = 100 - Int((Float(viewModel.getExp()) / Float(totalScoreForThisLevel)) * 100)
        
        let text = "\(nextLevelName)까지 \(percentLeftToNextLevel)% 남았어요! 💪"
    
        tilNextLevelLabel.text = text
    }
    
    func setCalendarMonthTo(_ month: Int){
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
    
    private func bind(){
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
