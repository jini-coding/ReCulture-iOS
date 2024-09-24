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
//        control.addTarget(self, action: #selector(pageChanged), for: .touchUpInside)
        return control
    }()
    
    private let tagStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
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
    
    private let lineView1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ticketLine")
        return view
    }()
    
    private let lineView2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ticketLine")
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
        label.font = .rcFont36B()
        label.text = "emoji"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rcGray400
        label.text = "date"
        label.font = .rcFont16B()
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .rcFont14SB()
        label.numberOfLines = 0
        return label
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "barcode")
        return imageView
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
        attributeTitle.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont18M(),
                                                         NSAttributedString.Key.foregroundColor: UIColor.white]))
        config.attributedTitle = attributeTitle
        config.background.cornerRadius = 10
        config.baseBackgroundColor = .rcMain
        config.contentInsets = .init(top: 15, leading: 10, bottom: 15, trailing: 10)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(model: MyTicketBookModel){
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
        //setDetailStackView()
        setSaveButton()
//        setTagStackView()
//        setButtonStackView()
        
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyImageMask(frameID: ticketBookModel.frame)
    }
    
    
    // MARK: - Layout
    
    private func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
        
//        let editButtonItem = UIBarButtonItem(customView: editButton)
//        editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)

        // left bar button을 추가하면 기존의 스와이프 pop 기능이 해제되므로 다시 세팅
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

//        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            //scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
            ticketImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            ticketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            ticketImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            ticketImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ticketImageView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func setPageControl(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: ticketImageView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: ticketImageView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setDetailContentView(){
        detailContentView.translatesAutoresizingMaskIntoConstraints = false
        
        ticketImageView.addSubview(detailContentView)
        //detailContentView.addSubview(detailStackView)
        
        detailContentView.isHidden = true
        
        detailContentView.addSubview(emojiLabel)
        detailContentView.addSubview(ticketTitleLabel)
        detailContentView.addSubview(dateLabel)
        detailContentView.addSubview(reviewLabel)
        detailContentView.addSubview(barcodeImageView)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        barcodeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        lineView1.translatesAutoresizingMaskIntoConstraints = false
        lineView2.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(lineView1)
        detailContentView.addSubview(lineView2)
        
        NSLayoutConstraint.activate([
            detailContentView.topAnchor.constraint(equalTo: ticketImageView.topAnchor),
            detailContentView.leadingAnchor.constraint(equalTo: ticketImageView.leadingAnchor),
            detailContentView.trailingAnchor.constraint(equalTo: ticketImageView.trailingAnchor),
            detailContentView.bottomAnchor.constraint(equalTo: ticketImageView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            lineView1.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 26),
            lineView1.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -26),
            lineView1.topAnchor.constraint(equalTo: detailContentView.topAnchor, constant: 65),
            lineView1.heightAnchor.constraint(equalToConstant: 2),

            // Ticket Title Label
            ticketTitleLabel.topAnchor.constraint(equalTo: lineView1.bottomAnchor, constant: 26),
            ticketTitleLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 28),
            ticketTitleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            lineView2.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 26),
            lineView2.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -26),
            lineView2.topAnchor.constraint(equalTo: ticketTitleLabel.bottomAnchor, constant: 26),
            lineView2.heightAnchor.constraint(equalToConstant: 2),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: lineView2.bottomAnchor, constant: 14),
            dateLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -28),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Review Label
            reviewLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 14),
            reviewLabel.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 26),
            reviewLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -26),
            
            emojiLabel.bottomAnchor.constraint(equalTo: barcodeImageView.topAnchor, constant: -14),
            emojiLabel.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -22),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Barcode Image View
            barcodeImageView.leadingAnchor.constraint(equalTo: detailContentView.leadingAnchor, constant: 20),
            barcodeImageView.trailingAnchor.constraint(equalTo: detailContentView.trailingAnchor, constant: -20),
            barcodeImageView.bottomAnchor.constraint(equalTo: detailContentView.bottomAnchor, constant: -65),
            barcodeImageView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
//    private func setButtonStackView(){
//        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        shareButton.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(buttonStackView)
//
//        [saveButton, shareButton].forEach {
//            buttonStackView.addArrangedSubview($0)
//        }
//
//        NSLayoutConstraint.activate([
//            buttonStackView.topAnchor.constraint(equalTo: tagStackView.bottomAnchor, constant: 31),
//            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
//        ])
//    }
    
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
    
    @objc private func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonDidTap(){
        print("티켓북 수정")
    }
    
    @objc private func saveButtonDidTap(){
        print("== 티켓북 저장 ==")
        ImageSaver().saveAsImage(ticketImageView.transfromToImage()!, target: self) {
            let alertVC = UIAlertController(title: "티켓북 저장에 성공하였습니다!", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @objc private func shareButtonDidTap(){
        print("티켓북 공유")
    }
    
    @objc private func imageViewDidTap() {
        print("이미지 선택됨")

        var flipTransform = CATransform3DIdentity
        flipTransform.m34 = -1.0 / 500.0

        if isFrontImage {
            isFrontImage = false
            detailContentView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
            detailContentView.isHidden = false
            
            detailContentView.backgroundColor = .rcWhiteBg
            pageControl.currentPage = 1

            flipTransform = CATransform3DRotate(flipTransform, CGFloat.pi, 0, 1, 0)
            UIView.animate(withDuration: 0.5, animations: {
                self.ticketImageView.layer.transform = flipTransform
            }, completion: { _ in
                //
            })

        } else {
            isFrontImage = true
            detailContentView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
            detailContentView.backgroundColor = .clear
            detailContentView.isHidden = true
            pageControl.currentPage = 0

            flipTransform = CATransform3DRotate(flipTransform, 0, 0, 1, 0)
            UIView.animate(withDuration: 0.5, animations: {
                self.ticketImageView.layer.transform = flipTransform
            }, completion: { _ in
                //
            })
        }
    }



    
    // MARK: - Functions
    
    private func configure(){
        print("==configuring ticket book detail==")
//        let imageUrlStr = "http://34.64.120.187:8080\(ticketBookModel.imageURL)"
//        imageUrlStr.loadAsyncImage(ticketImageView)
        
        let imageUrlStr = "http://34.64.120.187:8080\(ticketBookModel.imageURL)"
        imageUrlStr.loadAsyncImage(ticketImageView)
        //applyImageMask(frameID: ticketBookModel.frame)
        
        ticketTitleLabel.text = ticketBookModel.title
        emojiLabel.text = ticketBookModel.emoji
        dateLabel.text = String(ticketBookModel.date.split(separator: "T")[0]).replacingOccurrences(of: "-", with: ".")
        reviewLabel.text = ticketBookModel.review
        
        
        print("\(ticketBookModel.title)")
    }
    
    private func applyImageMask(frameID: Int) {
        // Assuming the mask images are named "frame1", "frame2", etc. based on the frameID
        guard let maskImage = UIImage(named: "frame\(frameID)")?.cgImage else { return }

        let maskLayer = CALayer()
        maskLayer.contents = maskImage
        maskLayer.frame = ticketImageView.bounds

        ticketImageView.layer.mask = maskLayer
        ticketImageView.layer.masksToBounds = true
    }
//    private func loadImageData() {
//        let url = URL(string: "http://34.22.96.154:8080\(self)")
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url!) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
}

// MARK: - Extensions: UIGestureRecognizerDelegate
extension TicketBookDetailVC: UIGestureRecognizerDelegate {
}
