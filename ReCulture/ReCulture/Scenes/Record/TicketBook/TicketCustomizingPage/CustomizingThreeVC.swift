//
//  CustomizingThreeVC.swift
//  ReCulture
//
//  Created by Jini on 6/2/24.
//

import UIKit

class CustomizingThreeVC: UIViewController, UITextViewDelegate {
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "기록하고 싶은 내용을\n입력해주세요"
        label.font = UIFont.rcFont24B()
        label.numberOfLines = 0
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let titleTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "무엇을 즐기고 오셨나요?"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: placeholderAttributes)
        
        return textfield
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    //datepicker로 교체 예정
    let dateTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "관람한 날짜를 입력해주세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: placeholderAttributes)
        
        return textfield
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "총평"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let placeholder = "간단한 메모를 입력해주세요"
    
    let commentTextView : UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor.rcGrayBg
        textview.layer.cornerRadius = 8
        textview.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textview.font = UIFont.rcFont16M()
        textview.textColor = UIColor.rcGray300
        textview.tintColor = UIColor.rcMain
            
        return textview
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "총평"
        label.textColor = UIColor.rcGray400
        label.font = UIFont.rcFont14M()
        
        return label
    }()
    
    let emojiTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "총평을 이모지로 표현해보세요"
        textfield.backgroundColor = UIColor.rcGrayBg
        textfield.font = UIFont.rcFont16M()
        textfield.textColor = UIColor.black
        textfield.layer.cornerRadius = 8
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.rcFont16M()
         ]
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: placeholderAttributes)
        
        return textfield
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupGuide()
        setupInputTitle()
        setupInputDate()
        setupInputComment()
        setupInputEmoji()
    }
    
    func setupGuide() {
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(guideLabel)
        
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            guideLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            guideLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupInputTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: titleTextfield.frame.height))
        titleTextfield.leftView = leftPaddingView
        titleTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            titleTextfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            titleTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupInputDate() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dateLabel)
        view.addSubview(dateTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: dateTextfield.frame.height))
        dateTextfield.leftView = leftPaddingView
        dateTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleTextfield.bottomAnchor, constant: 24),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            dateTextfield.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            dateTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func setupInputComment() {
        commentTextView.delegate = self
        commentTextView.text = placeholder
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(commentLabel)
        view.addSubview(commentTextView)
        
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: dateTextfield.bottomAnchor, constant: 24),
            commentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commentLabel.heightAnchor.constraint(equalToConstant: 20),
            
            commentTextView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 5),
            commentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            commentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            commentTextView.heightAnchor.constraint(equalToConstant: 156)
        ])
    }
    
    func setupInputEmoji() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emojiLabel)
        view.addSubview(emojiTextfield)
        
        // Left padding view
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: emojiTextfield.frame.height))
        emojiTextfield.leftView = leftPaddingView
        emojiTextfield.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 24),
            emojiLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emojiLabel.heightAnchor.constraint(equalToConstant: 20),
            
            emojiTextfield.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 5),
            emojiTextfield.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emojiTextfield.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emojiTextfield.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.rcGray300
        }
    }
}

