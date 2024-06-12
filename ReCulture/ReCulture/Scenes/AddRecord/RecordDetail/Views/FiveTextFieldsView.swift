//
//  FiveTextFieldsView.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/28/24.
//

import UIKit

/// 기록 중 스포츠, 콘서트, 독서를 위한 뷰입니다.

class FiveTextFieldsView: UIView {
    
    // MARK: - Properties
    
    private let parentVC: AddRecordDetailVC
    private let textViewPlaceHolder = "간단한 후기를 작성해주세요"
    var shortReviewIsSet: Bool = false {
        didSet {
            parentVC.validateInputField()
        }
    }
    
    // MARK: - Views
    
    private let stackView1: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let label1: UILabel = {
        let label = UILabel()
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let textField1 = CustomTextField()
    
    private let stackView2: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let textField2 = CustomTextField()
    
    private let stackView3: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let label3: UILabel = {
        let label = UILabel()
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let textField3 = CustomTextField()

    private let stackView4: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let label4: UILabel = {
        let label = UILabel()
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let textField4 = CustomTextField()
    
    // 마지막은 간단한 후기임
    private let stackView5: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private let label5: UILabel = {
        let label = UILabel()
        label.text = "간단한 후기"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private lazy var textView5: UITextView = {
        let view = UITextView()
        view.backgroundColor = .rcGrayBg
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 20.0, bottom: 16.0, right: 20.0)
        view.font = .rcFont16M()
        view.text = textViewPlaceHolder
        view.textColor = .rcGray200  // placeholder 색상
        view.delegate = self
        view.textContainer.lineFragmentPadding = 0
        return view
    }()

    // MARK: - Initialization
    
    init(_ parentVC: UIViewController){
        self.parentVC = (parentVC as? AddRecordDetailVC)!

        super.init(frame: .zero)
        
        setStackView1()
        setStackView2()
        setStackView3()
        setStackView4()
        setStackView5()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setStackView1()
//        setStackView2()
//        setStackView3()
//        setStackView4()
//        setStackView5()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setStackView1(){
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        textField1.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView1)
        
        stackView1.addArrangedSubview(label1)
        stackView1.addArrangedSubview(textField1)
        
        NSLayoutConstraint.activate([
            stackView1.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView1.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            textField1.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setStackView2(){
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        textField2.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView2)
        
        stackView2.addArrangedSubview(label2)
        stackView2.addArrangedSubview(textField2)

        NSLayoutConstraint.activate([
            stackView2.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 28),
        ])
        
        NSLayoutConstraint.activate([
            textField2.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setStackView3(){
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        textField3.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView3)

        stackView3.addArrangedSubview(label3)
        stackView3.addArrangedSubview(textField3)

        NSLayoutConstraint.activate([
            stackView3.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView3.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: 28),
        ])
        
        NSLayoutConstraint.activate([
            textField3.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setStackView4(){
        stackView4.translatesAutoresizingMaskIntoConstraints = false
        label4.translatesAutoresizingMaskIntoConstraints = false
        textField4.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView4)

        stackView4.addArrangedSubview(label4)
        stackView4.addArrangedSubview(textField4)

        NSLayoutConstraint.activate([
            stackView4.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView4.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView4.topAnchor.constraint(equalTo: stackView3.bottomAnchor, constant: 28),
        ])
        
        NSLayoutConstraint.activate([
            textField4.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setStackView5(){
        stackView5.translatesAutoresizingMaskIntoConstraints = false
        label5.translatesAutoresizingMaskIntoConstraints = false
        textView5.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView5)
        
        stackView5.addArrangedSubview(label5)
        stackView5.addArrangedSubview(textView5)

        NSLayoutConstraint.activate([
            stackView5.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView5.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView5.topAnchor.constraint(equalTo: stackView4.bottomAnchor, constant: 28),
            stackView5.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textView5.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    // MARK: - Functions
    
    func configure(_ placeholderInfoList: [[String]]){
        print(placeholderInfoList)
        label1.text = placeholderInfoList[0][0]
        textField1.placeholder = placeholderInfoList[0][1]
        
        label2.text = placeholderInfoList[1][0]
        textField2.placeholder = placeholderInfoList[1][1]
        
        label3.text = placeholderInfoList[2][0]
        textField3.placeholder = placeholderInfoList[2][1]
        
        label4.text = placeholderInfoList[3][0]
        textField4.placeholder = placeholderInfoList[3][1]
    }
    
    func getDetails() -> DetailsModel {
        return DetailsModel(review: textView5.text!,
                            detail1: textField1.text ?? "",
                            detail2: textField2.text ?? "",
                            detail3: textField3.text ?? "",
                            detail4: textField4.text ?? "")
    }
}

// MARK: - Extensions

extension FiveTextFieldsView: UITextViewDelegate {
    
    // textview에 focus -> placholder가 남아있다면 없애고 글 색상을 검은색으로 변경
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // textview가 focus르 잃으면 -> placholder 세팅
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .rcGray200
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        shortReviewIsSet = textView.text != "" ? true : false
    }
}
