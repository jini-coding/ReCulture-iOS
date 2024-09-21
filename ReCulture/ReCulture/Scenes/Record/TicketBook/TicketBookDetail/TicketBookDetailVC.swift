//
//  TicketBookDetailVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/13/24.
//

import UIKit

final class TicketBookDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private var isFrontImage = true
    private let ticketBookModel: MyTicketBookModel
    
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
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isOpaque = true
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 2
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .rcMain
        control.pageIndicatorTintColor = .rcGray000
        control.isUserInteractionEnabled = false
        return control
    }()

    private let detailContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private let detailStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    private let ticketTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont20B()
        label.text = "title"
        return label
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont20B()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rcGray400
        label.text = "date"
        label.font = .rcFont14R()
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont16M()
        label.numberOfLines = 0
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        var attributeTitle = AttributedString("저장")
        attributeTitle.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18M(),
                                                         NSAttributedString.Key.foregroundColor: UIColor.white]))
        config.attributedTitle = attributeTitle
        config.background.cornerRadius = 10
        config.baseBackgroundColor = .rcMain
        config.contentInsets = .init(top: 15, leading: 10, bottom: 15, trailing: 10)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(model: MyTicketBookModel) {
        self.ticketBookModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        detailStackView.isHidden = true  // 초기 세팅
        
        setupNavigation()
        setScrollView()
        setContentView()
        setTicketImageView()
        setPageControl()
        setDetailContentView()
        setDetailStackView()
        setSaveButton()
        
        configure()
    }
    
    // MARK: - Layout
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel

        // left bar button을 추가하면 기존의 스와이프 pop 기능이 해제되므로 다시 세팅
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            //scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
    
    private func setTicketImageView() {
        ticketImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        
        ticketImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(ticketImageView)
        
        NSLayoutConstraint.activate([
            ticketImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            ticketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ticketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ticketImageView.heightAnchor.constraint(equalTo: ticketImageView.widthAnchor, multiplier: 26/17)
        ])
    }
    
    private func setPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: ticketImageView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: ticketImageView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setDetailContentView() {
        detailContentView.translatesAutoresizingMaskIntoConstraints = false
        
        ticketImageView.addSubview(detailContentView)
        
        detailContentView.addSubview(detailStackView)
        
        NSLayoutConstraint.activate([
            detailContentView.topAnchor.constraint(equalTo: ticketImageView.topAnchor),
            detailContentView.leadingAnchor.constraint(equalTo: ticketImageView.leadingAnchor),
            detailContentView.trailingAnchor.constraint(equalTo: ticketImageView.trailingAnchor),
            detailContentView.bottomAnchor.constraint(equalTo: ticketImageView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            detailStackView.centerYAnchor.constraint(equalTo: detailContentView.centerYAnchor),
            detailStackView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 33),
            detailStackView.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -33),
        ])
    }
    
    private func setDetailStackView() {
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [emojiLabel, ticketTitleLabel, dateLabel, reviewLabel].forEach {
            detailStackView.addArrangedSubview($0)
        }
    }
    
    private func setSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            saveButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        print("== 티켓북 저장 ==")
        ImageSaver().saveAsImage(ticketImageView.transfromToImage()!, target: self) {
            let alertVC = UIAlertController(title: "티켓북 저장에 성공하였습니다!", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @objc private func imageViewTapped() {
        print("이미지 선택됨")
        if isFrontImage {
            isFrontImage = false
            detailContentView.backgroundColor = .rcWhiteBg
            detailStackView.isHidden = false
            pageControl.currentPage = 1
            UIView.transition(with: ticketImageView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        else {
            isFrontImage = true
            detailContentView.backgroundColor = .clear
            detailStackView.isHidden = true
            pageControl.currentPage = 0
            UIView.transition(with: ticketImageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    // MARK: - Functions
    
    private func configure() {
        print("==configuring ticket book detail==")
        ticketImageView.loadImage(urlWithoutBaseURL: ticketBookModel.imageURL)        
        
        ticketTitleLabel.text = ticketBookModel.title
        emojiLabel.text = ticketBookModel.emoji
        dateLabel.text = String(ticketBookModel.date.split(separator: "T")[0]).replacingOccurrences(of: "-", with: ".")
        reviewLabel.text = ticketBookModel.review
    }
}

// MARK: - Extensions: UIGestureRecognizerDelegate

extension TicketBookDetailVC: UIGestureRecognizerDelegate { }
