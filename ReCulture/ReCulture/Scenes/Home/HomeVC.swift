//
//  HomeVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Properties
    private var lastContentOffset: CGFloat = 0.0
    
    // MARK: - Views
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "LOGO"
        label.font = .rcFont16M()
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.delegate = self
        return view
    }()
    
    private let contentView = UIView()
    
    private let currentLevelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    //LabelWithPadding(top: 12, left: 16, bottom: 12, right: 16)
    private let currentLevelLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont16R()
        label.textColor = .white
        return label
    }()
    private let characterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 145/2
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
    
    private lazy var calendarView = CustomCalendarView()
    
    private lazy var tooltipView = ToolTipView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(hexCode: "F5F6FA")
        
        setupNavigation()
        
        // set up layout
        setScrollView()
        setContentView()
        setCurrentLevelView()
        setCurrentLevelLabel()
        setCharacterImageView()
        setTilNextLevelLabel()
        setLevelProgressView()
        setCalendarContainerView()
        setMonthlyRecordLabel()
        setCalendarView()
        
        levelProgressView.setProgress(0.78)
        
        scrollView.updateContentSize()
    }
    
    // MARK: - Layouts
    
    private func setupNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: currentLevelLabel)
        //self.navigationController?.navigationBar.tintColor = .white
        //self.navigationController?.navigationBar.backgroundColor = .rcMain
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .rcMain
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
////        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .rcMain
//        appearance.backgroundImage = UIImage()
//        appearance.shadowImage = UIImage()
//        
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
    
    private func setCurrentLevelView(){
        currentLevelView.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addSubview(currentLevelView)
        
        NSLayoutConstraint.activate([
            currentLevelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            currentLevelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            currentLevelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }
    
    private func setCurrentLevelLabel(){
        setLevelAttributes()
        
        currentLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currentLevelView.addSubview(currentLevelLabel)

        NSLayoutConstraint.activate([
            currentLevelLabel.leadingAnchor.constraint(equalTo: currentLevelView.leadingAnchor, constant: 16),
            currentLevelLabel.topAnchor.constraint(equalTo: currentLevelView.topAnchor, constant: 12),
            currentLevelLabel.bottomAnchor.constraint(equalTo: currentLevelView.bottomAnchor, constant: -12),
        ])
    }
    
    private func setCharacterImageView(){
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(characterImageView)
        
        NSLayoutConstraint.activate([
            characterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            characterImageView.topAnchor.constraint(equalTo: currentLevelView.bottomAnchor, constant: 29),
            characterImageView.widthAnchor.constraint(equalToConstant: 145),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setTilNextLevelLabel(){
        tilNextLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(tilNextLevelLabel)
        
        NSLayoutConstraint.activate([
            tilNextLevelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            tilNextLevelLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 39)
        ])
    }
    
    private func setLevelProgressView(){
        levelProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(levelProgressView)
        
        NSLayoutConstraint.activate([
            levelProgressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            levelProgressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            levelProgressView.topAnchor.constraint(equalTo: tilNextLevelLabel.bottomAnchor, constant: 7)
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
            calendarContainerView.topAnchor.constraint(equalTo: levelProgressView.bottomAnchor, constant: 24),
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
    
    // MARK: - Helpers
    
    private func setLevelAttributes(){
        let text = "윤진님은 Level 02"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont.rcFont16B(),  range: (text as NSString).range(of: "Level 02"))
        currentLevelLabel.attributedText = attributedString
    }
}

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
