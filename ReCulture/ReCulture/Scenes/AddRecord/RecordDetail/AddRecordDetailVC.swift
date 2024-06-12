//
//  AddRecordDetailVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class AddRecordDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let recordType: RecordType
    private var selectedDate = Date()
    private var isFourTextFieldsView = false
    private var textFieldPlaceholders = [
        [RecordType.movie: [["영화 이름", "어떤 영화인가요?"],
                            ["출연진 및 감독", "출연진 및 감독을 적어주세요"],
                            ["장르", "어떤 장르의 영화인가요?"],
                            ["간단한 후기", "간단한 후기를 작성해주세요"]
                           ]
        ],
        [RecordType.musical: [["작품명", "어떤 뮤지컬인가요?"],
                              ["극장", "어디에서 보셨나요?"],
                              ["캐스팅", "출연자를 작성해주세요"],
                              ["간단한 후기", "간단한 후기를 작성해주세요"]
                             ]
        ],
        [RecordType.play: [["작품명", "어떤 연극인가요?"],
                           ["공연장", "어디에서 보셨나요?"],
                           ["캐스팅", "출연자를 작성해주세요"],
                           ["간단한 후기", "간단한 후기를 작성해주세요"]
                          ]
        ],
        [RecordType.sports: [["스포츠 종류", "어떤 스포츠인가요?"],
                             ["장소 및 상대팀", "어디에서, 누가 한 경기인가요?"],
                             ["경기 결과", "경기 결과를 입력해주세요"],
                             ["선발 라인업", "선발 라인업을 입력해주세요"],
                             ["간단한 후기", "간단한 후기를 작성해주세요"]
                            ]
        ],
        [RecordType.concert: [["공연명", "어떤 공연인가요?"],
                              ["공연장", "어디에서 한 공연인가요?"],
                              ["출연진/연주자", "출연진/연주자를 입력해주세요"],
                              ["셋리스트/프로그램", "셋리스트/프로그램을 입력해주세요"],
                              ["간단한 후기", "간단한 후기를 작성해주세요"]
                             ]
        ],
        [RecordType.drama: [["제목", "어떤 드라마인가요?"],
                            ["장르", "어떤 장르의 드라마인가요?"],
                            ["출연진 및 감독/극본", "출연진, 감독, 극본을 입력해주세요"],
                            ["간단한 후기", "간단한 후기를 작성해주세요"]
                           ]
        ],
        [RecordType.book: [["책 이름", "어떤 책인가요?"],
                           ["저자", "누구의 책인가요?"],
                           ["독서 기간", "언제부터 언제까지 읽으셨나요?"],
                           ["인상깊은 구절", "인상깊은 구절을 입력해주세요"],
                           ["간단한 후기", "간단한 후기를 작성해주세요"]
                          ]
        ],
        [RecordType.exhibition: [["주제", "어떤 전시회인가요?"],
                                 ["장소", "어디에서 열렸나요?"],
                                 ["인상깊은 전시물", "인상깊은 전시물을 입력해주세요"],
                                 ["간단한 후기", "간단한 후기를 작성해주세요"]
                                ]
        ],
        [RecordType.etc: [["내용", "무엇을 했나요?"],
                          ["장소", "어디에서 했나요?"],
                          ["함께한 사람들", "누구와 했나요?"],
                          ["간단한 후기", "간단한 후기를 작성해주세요"]
                         ]
        ]
    ]
    
    private let publicOrPrivateList: [String] = ["공개", "비공개"]
    private var rangeIsSet: Bool = false
    private var disclosure: DisclosureType = .Private
    
    var menuItems: [UIAction] {
        let isPublic = UIAction(
            title: "공개",
            handler: { _ in
                print("공개")
                self.recordRangeMenuBtn.configuration?.attributedTitle = "공개"
                self.recordRangeMenuBtn.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                    NSAttributedString.Key.foregroundColor: UIColor.black])
                )
                self.rangeIsSet = true
                self.disclosure = .Public
                self.validateInputField()
            })

        let isPrivate = UIAction(
            title: "비공개",
            handler: { _ in
                print("비공개")
                self.recordRangeMenuBtn.configuration?.attributedTitle = "비공개"
                self.recordRangeMenuBtn.configuration?.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                    NSAttributedString.Key.foregroundColor: UIColor.black])
                )
                self.rangeIsSet = true
                self.disclosure = .Private
                self.validateInputField()
            })
        return [isPublic, isPrivate]
    }
    
    private var nextButtonBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    
    private let headerView = HeaderView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 추가"
        label.font = .rcFont16M()
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let writeDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "문화 생활에 대해\n기록해주세요"
        label.font = .rcFont26B()
        label.numberOfLines = 2
        return label
    }()
    
    private let recordTitleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let recordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let recordTitleTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "제목을 입력해주세요"
        textField.isUserInteractionEnabled = true
        textField.addTarget(self, action: #selector(titleTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let dateStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private lazy var dateTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "언제의 기록인가요?"
        textField.delegate = self
        textField.tintColor = .clear
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
        return picker
    }()
    
    private lazy var fourTextFieldsView = FourTextFieldsView(self)
    private lazy var fiveTextFieldsView = FiveTextFieldsView(self)
    
    private let emojiStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "이모지 총평"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let emojiTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "이모지로 감상을 표현해주세요"
        textField.addTarget(self, action: #selector(emojiTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let recordRangeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let recordRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "공개여부"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let recordRangeMenuBtn: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .rcGrayBg
        config.attributedTitle = "공개여부를 설정해주세요"
        config.attributedTitle?.setAttributes(AttributeContainer([NSAttributedString.Key.font: UIFont.rcFont16M(),
                                                                 NSAttributedString.Key.foregroundColor: UIColor.black]))
        config.image = UIImage.chevronDown
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.titleAlignment = .leading
        config.background.cornerRadius = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 12)
        
        button.contentHorizontalAlignment = .leading
        button.configuration = config
        return button
    }()
    
    private let recordRangeMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "공개여부 설정"
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let nextButton: NextButton = {
        let button = NextButton()
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
        
    // MARK: - Initialization
    
    init(type: RecordType) {
        self.recordType = type
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Keyboard 보여지고 숨겨질 때 발생되는 이벤트 등록 */
        addKeyboardObserver()
        
        setHeaderView()
        //setupNavigation()
        setScrollView()
        setContentView()
        setWriteDetailLabel()
        setTitleStackView()
        setDateStackView()
        // 영화, 뮤지컬, 연극, 드라마, 전시회, 기타이면 4칸짜리 뷰를 넣어야 함
        if (recordType == .movie
            || recordType == .musical
            || recordType == .play
            || recordType == .drama
            || recordType == .exhibition
            || recordType == .etc) {
            isFourTextFieldsView = true
            setFourTextFieldsView()
        }
        // 그 외에는 5칸짜리 뷰 필요
        else{
            isFourTextFieldsView = false
            setFiveTextFieldsView()
        }
        
        setEmojiStackView()
        setRecordRangeStackView()
        setNextButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeKeyBoardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.scrollView.endEditing(true)
        self.contentView.endEditing(true)
    }
    
    // MARK: - Layout
    
    private func setHeaderView(){
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        headerView.addBackButtonTarget(target: self, action: #selector(goBack), for: .touchUpInside)
    }
    
    private func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
    }
    
    private func setScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped)))
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
    
    private func setWriteDetailLabel(){
        writeDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(writeDetailLabel)
        
        NSLayoutConstraint.activate([
            writeDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            writeDetailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
        ])
    }
    
    private func setTitleStackView(){
        recordTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        recordTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recordTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(recordTitleStackView)
        
        recordTitleStackView.addArrangedSubview(recordTitleLabel)
        recordTitleStackView.addArrangedSubview(recordTitleTextField)
        
        NSLayoutConstraint.activate([
            recordTitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recordTitleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recordTitleStackView.topAnchor.constraint(equalTo: writeDetailLabel.bottomAnchor, constant: 38),
        ])
        
        NSLayoutConstraint.activate([
            recordTitleTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setDateStackView(){
        dateTextField.inputView = datePicker
        dateTextField.text = dateFormatToString(date: Date())
        
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateStackView)
        
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            dateStackView.leadingAnchor.constraint(equalTo: recordTitleStackView.leadingAnchor),
            dateStackView.trailingAnchor.constraint(equalTo: recordTitleStackView.trailingAnchor),
            dateStackView.topAnchor.constraint(equalTo: recordTitleStackView.bottomAnchor, constant: 28),
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setFourTextFieldsView(){
        print("4칸짜리 세팅 중")
        guard let index = textFieldPlaceholders.firstIndex(where: { $0.keys.contains(recordType) }) else { return }
//        print(textFieldPlaceholders.)
        let placeholderList = textFieldPlaceholders[index].map{ $0.1 }
        //print(placeholderList.description)
        
        fourTextFieldsView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(fourTextFieldsView)
        
        NSLayoutConstraint.activate([
            fourTextFieldsView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            fourTextFieldsView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            fourTextFieldsView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 28),
        ])
        
        fourTextFieldsView.configure(placeholderList[0])
        
    }
    
    private func setFiveTextFieldsView(){
        print("5칸짜리 세팅 중")
        guard let index = textFieldPlaceholders.firstIndex(where: { $0.keys.contains(recordType) }) else { return }
        let placeholderList = textFieldPlaceholders[index].map{ $0.1 }
        
        fiveTextFieldsView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(fiveTextFieldsView)
        
        NSLayoutConstraint.activate([
            fiveTextFieldsView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor),
            fiveTextFieldsView.trailingAnchor.constraint(equalTo: dateStackView.trailingAnchor),
            fiveTextFieldsView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 28),
        ])
        
        fiveTextFieldsView.configure(placeholderList[0])
    }
    
    private func setEmojiStackView(){
        emojiStackView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emojiStackView)
        
        emojiStackView.addArrangedSubview(emojiLabel)
        emojiStackView.addArrangedSubview(emojiTextField)
        
        if(isFourTextFieldsView){
            NSLayoutConstraint.activate([
                emojiStackView.leadingAnchor.constraint(equalTo: fourTextFieldsView.leadingAnchor),
                emojiStackView.trailingAnchor.constraint(equalTo: fourTextFieldsView.trailingAnchor),
                emojiStackView.topAnchor.constraint(equalTo: fourTextFieldsView.bottomAnchor, constant: 28),
            ])
        }
        else{
            NSLayoutConstraint.activate([
                emojiStackView.leadingAnchor.constraint(equalTo: fiveTextFieldsView.leadingAnchor),
                emojiStackView.trailingAnchor.constraint(equalTo: fiveTextFieldsView.trailingAnchor),
                emojiStackView.topAnchor.constraint(equalTo: fiveTextFieldsView.bottomAnchor, constant: 28),
            ])
        }
        
        NSLayoutConstraint.activate([
            emojiTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setRecordRangeStackView(){
        recordRangeStackView.translatesAutoresizingMaskIntoConstraints = false
        recordRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        recordRangeMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(recordRangeStackView)
        
        recordRangeStackView.addArrangedSubview(recordRangeLabel)
        recordRangeStackView.addArrangedSubview(recordRangeMenuBtn)
        
        NSLayoutConstraint.activate([
            recordRangeStackView.leadingAnchor.constraint(equalTo: emojiStackView.leadingAnchor),
            recordRangeStackView.trailingAnchor.constraint(equalTo: emojiStackView.trailingAnchor),
            recordRangeStackView.topAnchor.constraint(equalTo: emojiStackView.bottomAnchor, constant: 28),
        ])
        
        NSLayoutConstraint.activate([
            recordRangeMenuBtn.heightAnchor.constraint(equalToConstant: 52),
            recordRangeMenuBtn.widthAnchor.constraint(equalTo: recordRangeStackView.widthAnchor)
        ])
        
        let menu = UIMenu(children: menuItems)
        recordRangeMenuBtn.menu = menu
        recordRangeMenuBtn.showsMenuAsPrimaryAction = true
    }
    
    private func setNextButton(){
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nextButton.topAnchor.constraint(equalTo: recordRangeStackView.bottomAnchor, constant: 108),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func datePickerValueDidChange(_ sender: UIDatePicker){
        dateTextField.text = dateFormatToString(date: datePicker.date)
    }
    
    @objc private func emojiTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc private func keyboardWillShow(_ notification: NSNotification){
        guard let userInfo = notification.userInfo as NSDictionary?,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
        /// 키보드의 높이
        let keyboardHeight = keyboardFrame.size.height
        scrollView.contentInset.bottom = keyboardHeight
            
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }

    // 키보드 숨겨질 때 -> 원래 상태로
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let animationDuration = notification.userInfo![ UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        scrollView.contentInset.bottom = .zero
                
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func scrollViewTapped(){
        scrollView.endEditing(true)
    }
    
    @objc private func nextButtonDidTap(){
        print("다음으로")
        var detailsModel: DetailsModel?
        if isFourTextFieldsView {
            detailsModel = fourTextFieldsView.getDetails()
        }
        else {
            detailsModel = fiveTextFieldsView.getDetails()
        }
        let addRecordPhotoVC = AddRecordPhotoVC(
            requestDTO: AddRecordRequestDTO(title: recordTitleTextField.text!,
                                            emoji: emojiTextField.text!,
                                            date: ISO8601DateFormatter.string(from: datePicker.date,
                                                                              timeZone: TimeZone(abbreviation: "KST")!,
                                                                              formatOptions: [.withInternetDateTime]),
                                            categoryId: String(RecordType.getCategoryIdOf(recordType)),
                                            disclosure: disclosure.rawValue,
                                            review: detailsModel!.review,
                                            detail1: detailsModel!.detail1,
                                            detail2: detailsModel!.detail2,
                                            detail3: detailsModel!.detail3,
                                            detail4: detailsModel!.detail4
                                            )
            )
        addRecordPhotoVC.modalPresentationStyle = .fullScreen
        self.present(addRecordPhotoVC, animated: true)
    }
    
    @objc private func goBack() {
        print("기록 종류 선택 화면으로 이동")
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Functions
    
    private func dateFormatToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyBoardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    /// 필요한 내용이 다 쓰였는지 확인
    func validateInputField() {
        self.nextButton.isActive = !(self.recordTitleTextField.text?.isEmpty ?? true) && !(self.emojiTextField.text?.isEmpty ?? true) && rangeIsSet && (isFourTextFieldsView ? fourTextFieldsView.shortReviewIsSet : fiveTextFieldsView.shortReviewIsSet)
    }

}

// MARK: - Extensions; UITextField

extension AddRecordDetailVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            return false
        }
        return true
    }
}
