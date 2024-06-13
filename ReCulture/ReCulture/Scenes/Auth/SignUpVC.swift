//
//  SignUpVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/2/24.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = SignupViewModel()
    
    private var isValidPw = false {
        willSet {
            // 비밀번호가 유효한 경우 유효하지 않음 라벨 삭제, 유효하지 않으면 추가
            newValue ? removePwIsNotValidLabel() : addPwIsNotValidLabel()
        }
    }
    
    var signupSuccess = false {
        didSet {
            moveToNewUserProfileVC(signupSuccess)
        }
    }
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .rcFont16M()
        return label
    }()
    
    private let emailStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .rcFont14M()
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "이메일을 입력해주세요"
        tf.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        return tf
    }()
    
    private let passwordStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .rcFont14M()
        return label
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "비밀번호를 입력해주세요"
        tf.textContentType = .newPassword
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        return tf
    }()
    
    private let pwIsNotValidLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호는 대소문자, 특수문자, 숫자 8자 이상의 조합이어야 합니다."
        label.font = .rcFont12M()
        label.textColor = .red.withAlphaComponent(0.5)
        return label
    }()
    
    private let passwordConfirmStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
    }()
    
    private let passwordConfirmLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.font = .rcFont14M()
        return label
    }()
    
    private let passwordConfirmTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "비밀번호를 다시 한 번 입력해주세요"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(tfDidChange), for: .editingChanged)
        return tf
    }()
    
    private let pwDoesNotMatchLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.font = .rcFont12M()
        label.textColor = .red.withAlphaComponent(0.5)
        return label
    }()
    
    private let signupButton: NextButton = {
        let button = NextButton("회원가입")
        button.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addKeyboardObserver()
        
        setupNavigation()
        setupEmailStackView()
        setupPasswordStackView()
        setupPasswordConfirmStackView()
        setupPwDoesNotMatchLabel()
        setupSignupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeKeyBoardObserver()
    }
    
    // MARK: - Layout
    
    private func setupNavigation(){
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupEmailStackView(){
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailStackView)
        
        [emailLabel, emailTextField].forEach { emailStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            emailStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            emailStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            emailStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupPasswordStackView(){
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordStackView)
        
        [passwordLabel, passwordTextField].forEach { passwordStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            passwordStackView.leadingAnchor.constraint(equalTo: emailStackView.leadingAnchor),
            passwordStackView.trailingAnchor.constraint(equalTo: emailStackView.trailingAnchor),
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 30),
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupPasswordConfirmStackView(){
        passwordConfirmStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordConfirmStackView)
        
        [passwordConfirmLabel, passwordConfirmTextField].forEach { passwordConfirmStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            passwordConfirmStackView.leadingAnchor.constraint(equalTo: passwordStackView.leadingAnchor),
            passwordConfirmStackView.trailingAnchor.constraint(equalTo: passwordStackView.trailingAnchor),
            passwordConfirmStackView.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 30),
        ])
        
        NSLayoutConstraint.activate([
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupPwDoesNotMatchLabel(){
        pwDoesNotMatchLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pwDoesNotMatchLabel)
        
        NSLayoutConstraint.activate([
            pwDoesNotMatchLabel.leadingAnchor.constraint(equalTo: passwordConfirmStackView.leadingAnchor),
            pwDoesNotMatchLabel.topAnchor.constraint(equalTo: passwordConfirmStackView.bottomAnchor, constant: 5),
        ])
        
        pwDoesNotMatchLabel.isHidden = true
    }
    
    private func setupSignupButton(){
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            signupButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signupButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signupButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func signUpButtonDidTap(){
        print("최종 회원가입하기")
        print("프로필 설정으로 이동")
        
        LoadingIndicator.showLoading()
        
        let requestDTO = SignupRequestDTO(email: emailTextField.text!, password: passwordTextField.text!)
        print("dto: \(requestDTO)")
        viewModel.postUserRegister(requestDTO: requestDTO, fromCurrentVC: self)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if emailTextField.isEditing == true{
                keyboardAnimate(keyboardRectangle: keyboardSize, textField: emailTextField)
            }
            else if passwordTextField.isEditing == true{
                keyboardAnimate(keyboardRectangle: keyboardSize, textField: passwordTextField)
            }
            else if passwordConfirmTextField.isEditing == true{
                keyboardAnimate(keyboardRectangle: keyboardSize, textField: passwordConfirmTextField)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func tfDidChange(_ sender: UITextField){
        isValidPw = if let text = passwordTextField.text { text.isValidPassword() } else { true }
        let isPwSame = isPasswordSame(passwordTextField, passwordConfirmTextField)
        let isValidEmail = if let text = emailTextField.text { text.isValidEmail() } else { false }
        
        if isValidEmail
            && isValidPw
            && !(passwordTextField.text?.isEmpty ?? true)
            && isPwSame {
            signupButton.isActive = true
        }
        else {
            signupButton.isActive = false
        }
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    private func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField){
        if keyboardRectangle.height > (self.view.frame.height - textField.frame.maxY){
            self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - textField.frame.maxY))
        }
    }
    
    private func isPasswordSame(_ first: UITextField,_ second: UITextField) -> Bool {
        // 두 텍스트필드 값이 같을 때 true
        if(first.text == second.text) {
            pwDoesNotMatchLabel.isHidden = true
            return true
        }
        // 두 텍스트필드 값이 다를 때
        else {
            // 비번 확인 창이 비어있으면 확인 불가하므로 false
            if second.text == "" {
                pwDoesNotMatchLabel.isHidden = true
                return false
            }
            // 비번 확인 창 내용이 있으면 값이 다른 거이므로 false
            else {
                pwDoesNotMatchLabel.isHidden = false
                return false
            }
        }
    }
    
    private func addPwIsNotValidLabel(){
        pwIsNotValidLabel.isHidden = false
        passwordStackView.addArrangedSubview(pwIsNotValidLabel)
    }
    
    private func removePwIsNotValidLabel(){
        // pwIsNotValidLabel이 스택뷰에 존재할 때만 삭제해야 하므로
        if passwordStackView.arrangedSubviews.count != 2 {
            passwordStackView.removeArrangedSubview(pwIsNotValidLabel)
            pwIsNotValidLabel.isHidden = true
        }
    }
    
    private func moveToNewUserProfileVC(_ signupSuccess: Bool){
        if signupSuccess {
            DispatchQueue.main.async {
                LoadingIndicator.hideLoading()
                self.navigationController?.pushViewController(NewUserProfileVC(), animated: true)
            }
        }
    }
}
