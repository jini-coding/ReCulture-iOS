//
//  TicketBookDetailVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/13/24.
//

import UIKit

class TicketBookDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private var isFrontImage = true
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "티켓 상세 보기"
        label.font = .rcFont16M()
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(.rcMain, for: .normal)
        button.titleLabel?.font = .rcFont16M()
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let contentView = UIView()
    
    private let ticketImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .rcMain
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: "TicketImage.png")
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 2
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .rcMain
        control.pageIndicatorTintColor = .rcGray000
        control.isUserInteractionEnabled = false
//        control.addTarget(self, action: #selector(pageChanged), for: .touchUpInside)
        return control
    }()
    
    private let tagStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private let tag1: TagLabel = {
        let label = TagLabel()
        label.text = "콘서트"
        label.font = .rcFont16M()
        label.backgroundColor = .rcGray100
        label.textColor = .rcMain
        label.layer.cornerRadius = 7.5
        label.clipsToBounds = true
        return label
    }()
    
    private let tag2: TagLabel = {
        let label = TagLabel()
        label.text = "데이식스"
        label.font = .rcFont16M()
        label.backgroundColor = .rcGray100
        label.textColor = .rcMain
        label.layer.cornerRadius = 7.5
        label.clipsToBounds = true
        return label
    }()
    
    private let tag3: TagLabel = {
        let label = TagLabel()
        label.text = "Welcome to the Show"
        label.font = .rcFont16M()
        label.backgroundColor = .rcGray100
        label.textColor = .rcMain
        label.layer.cornerRadius = 7.5
        label.clipsToBounds = true
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        var attributeTitle = AttributedString("저장")
        attributeTitle.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18M(), NSAttributedString.Key.foregroundColor: UIColor.white]))
        config.attributedTitle = attributeTitle
        config.background.cornerRadius = 10
        config.baseBackgroundColor = .rcMain
        config.contentInsets = .init(top: 15, leading: 10, bottom: 15, trailing: 10)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        var attributeTitle = AttributedString("공유")
        attributeTitle.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18M(), NSAttributedString.Key.foregroundColor: UIColor.rcMain]))
        config.attributedTitle = attributeTitle
        config.background.cornerRadius = 10
        config.baseBackgroundColor = .white
        config.contentInsets = .init(top: 15, leading: 10, bottom: 15, trailing: 10)

        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.rcMain.cgColor
        button.configuration = config
        button.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        setScrollView()
        setContentView()
        setTicketImageView()
        setPageControl()
        setTagStackView()
        setButtonStackView()
//        setSaveButton()
    }
    
    // MARK: - Layout
    
    private func setupNavigation(){
//        let appearance = UINavigationBarAppearance()
//        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
//        appearance.configureWithTransparentBackground()  // 내비게이션 바의 선을 지우고 뷰컨트롤러의 배경색을 사용
////
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.compactAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
//        self.navigationItem.title = "티켓 상세 보기"
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.rcFont16M()]
        
//        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(goBack))
        
        let editButtonItem = UIBarButtonItem(customView: editButton)
        editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)

        // left bar button을 추가하면 기존의 스와이프 pop 기능이 해제되므로 다시 세팅
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

//        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
    
    private func setTicketImageView() {
        ticketImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap)))
        
        ticketImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(ticketImageView)
        
        NSLayoutConstraint.activate([
            ticketImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            ticketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ticketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ticketImageView.heightAnchor.constraint(equalTo: ticketImageView.widthAnchor, multiplier: 26/17)
        ])
    }
    
    private func setPageControl(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: ticketImageView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: ticketImageView.centerXAnchor)
        ])
    }
    
    private func setTagStackView(){
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        tag1.translatesAutoresizingMaskIntoConstraints = false
        tag2.translatesAutoresizingMaskIntoConstraints = false
        tag3.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(tagStackView)
        
        [tag1, tag2, tag3].forEach {
            tagStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tagStackView.leadingAnchor.constraint(equalTo: ticketImageView.leadingAnchor),
            tagStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 15)
        ])
    }
    
    private func setButtonStackView(){
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(buttonStackView)
        
        [saveButton, shareButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 31),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonDidTap(){
        print("티켓북 수정")
    }
    
    @objc private func saveButtonDidTap(){
        print("티켓북 저장")
    }
    
    @objc private func shareButtonDidTap(){
        print("티켓북 공유")
    }
    
    @objc private func imageViewDidTap(){
        print("이미지 선택됨")
        if isFrontImage {
            isFrontImage = false
            pageControl.currentPage = 1
            ticketImageView.backgroundColor = .rcGray300
            UIView.transition(with: ticketImageView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        else {
            isFrontImage = true
            pageControl.currentPage = 0
            ticketImageView.backgroundColor = .rcMain
            UIView.transition(with: ticketImageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
}

// MARK: - Extensions: UIGestureRecognizerDelegate
extension TicketBookDetailVC: UIGestureRecognizerDelegate {
}
