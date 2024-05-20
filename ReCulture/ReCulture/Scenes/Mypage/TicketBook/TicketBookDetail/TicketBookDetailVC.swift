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
        label.font = .rcFont20B()
        return label
    }()
    
    private let ticketImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .rcMain
        view.contentMode = .scaleAspectFit
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap)))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let tagStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        return view
    }()
    
    private let tag1: TagLabel = {
        let label = TagLabel()
        label.text = "태그1"
        label.font = .rcFont16M()
        label.backgroundColor = .rcGray100
        label.textColor = .rcMain
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private let tag2: TagLabel = {
        let label = TagLabel()
        label.text = "태그2"
        label.font = .rcFont16M()
        label.backgroundColor = .rcGray100
        label.textColor = .rcMain
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        var attributeTitle = AttributedString("저장")
        attributeTitle.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18B(), NSAttributedString.Key.foregroundColor: UIColor.white]))
        config.attributedTitle = attributeTitle
        config.background.cornerRadius = 5
        config.baseBackgroundColor = .rcMain
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        var attributeTitle = AttributedString("공유")
        attributeTitle.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18B(), NSAttributedString.Key.foregroundColor: UIColor.white]))
        config.attributedTitle = attributeTitle
        config.background.cornerRadius = 5
        config.baseBackgroundColor = .rcMain
        
        button.configuration = config
        button.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        setTicketImageView()
        setTagStackView()
        setButtonStackView()
//        setSaveButton()
    }
    
    // MARK: - Layout
    
    private func setupNavigation(){
        let appearance = UINavigationBarAppearance()
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        appearance.configureWithTransparentBackground()  // 내비게이션 바의 선을 지우고 뷰컨트롤러의 배경색을 사용

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
        
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(goBack))
        
        let addNewButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .done, target: self, action: #selector(editButtonDidTap))

        // left bar button을 추가하면 기존의 스와이프 pop 기능이 해제되므로 다시 세팅
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.rightBarButtonItem = addNewButtonItem
    }
    
    private func setTicketImageView() {
        ticketImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap)))
        
        ticketImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ticketImageView)
        
        NSLayoutConstraint.activate([
            ticketImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ticketImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            ticketImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            ticketImageView.heightAnchor.constraint(equalTo: ticketImageView.widthAnchor, multiplier: 3 / 2)
        ])
    }
    
    private func setTagStackView(){
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        tag1.translatesAutoresizingMaskIntoConstraints = false
        tag2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tagStackView)
        
        [tag1, tag2].forEach {
            tagStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tagStackView.leadingAnchor.constraint(equalTo: ticketImageView.leadingAnchor),
            tagStackView.topAnchor.constraint(equalTo: ticketImageView.bottomAnchor, constant: 15)
        ])
    }
    
    private func setButtonStackView(){
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        
        [saveButton, shareButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 31),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: - Actions
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonDidTap(){
        print("티켓북 수정")
    }
    
    @objc func saveButtonDidTap(){
        print("티켓북 저장")
    }
    
    @objc func shareButtonDidTap(){
        print("티켓북 공유")
    }
    
    @objc func imageViewDidTap(){
        print("이미지 선택됨")
        if isFrontImage {
            isFrontImage = false
//            let toImage = UIImage(named: "Image-1")
//            imageView.image = toImage
            ticketImageView.backgroundColor = .rcGray300
            UIView.transition(with: ticketImageView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        else {
            isFrontImage = true
//            let toImage = UIImage(named: "Image")
//            imageView.image = toImage
            ticketImageView.backgroundColor = .rcMain
            UIView.transition(with: ticketImageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
}

// MARK: - Extensions: UIGestureRecognizerDelegate
extension TicketBookDetailVC: UIGestureRecognizerDelegate {
}
