//
//  LoginVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    
    var loginSuccess = false {
        didSet {
            moveToHomeVC(loginSuccess)
        }
    }

    // MARK: - Views
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = .appICON
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Re:Culture"
        label.font = .rcFont26B()
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "이메일을 입력해주세요"
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "비밀번호를 입력해주세요"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(title: "로그인")
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let signUpButton: CustomButton = {
        let button = CustomButton(title: "회원가입")
        button.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "계정이 없다면?"
        label.font = .rcFont14M()
        label.textColor = .rcGray400
        return label
    }()
    
    private let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .rcGray400
        return view
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .rcGray400
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        addKeyboardObserver()
        
        setupLogoImageView()
        //setupWelcomeLabel()
        setEmailTextField()
        setPasswordTextField()
        setupLoginButton()
        setNoAccountLabel()
        setNoAccountLeftLine()
        setNoAccountRightLine()
        setupSignUpButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeKeyBoardObserver()
    }
    
    // MARK: - Layout
    
    private func setupLogoImageView(){
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
        ])
    }
    
    private func setupWelcomeLabel(){
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30)
        ])
    }
    
    private func setEmailTextField(){
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 85),
            emailTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setPasswordTextField(){
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupLoginButton(){
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setNoAccountLabel() {
        noAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(noAccountLabel)
        
        NSLayoutConstraint.activate([
            noAccountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 80),
        ])
    }
    
    private func setNoAccountLeftLine() {
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(leftLine)
        
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.trailingAnchor.constraint(equalTo: noAccountLabel.leadingAnchor, constant: -20),
            leftLine.centerYAnchor.constraint(equalTo: noAccountLabel.centerYAnchor)
        ])
    }
    
    private func setNoAccountRightLine() {
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(rightLine)
        
        NSLayoutConstraint.activate([
            rightLine.leadingAnchor.constraint(equalTo: noAccountLabel.trailingAnchor, constant: 20),
            rightLine.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.centerYAnchor.constraint(equalTo: noAccountLabel.centerYAnchor)
        ])
    }
    
    private func setupSignUpButton(){
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            signUpButton.topAnchor.constraint(equalTo: noAccountLabel.bottomAnchor, constant: 15),
            signUpButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonDidTap(){
        print("로그인 버튼 선택됨")
        let email = emailTextField.text
        let password = passwordTextField.text
        
        // 정보 모두 입력됐는지 확인
        if (email?.isEmpty ?? true) || (password?.isEmpty ?? true) {
            let alert = UIAlertController(title: "정보를 모두 입력해주세요!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        let requestDTO = LoginRequestDTO(email: email!, password: password!)
        print("dto: \(requestDTO)")
        viewModel.postUserLogin(requestDTO: requestDTO, fromCurrentVC: self)
    }
    
    @objc private func signUpButtonDidTap(){
        print("회원가입 선택됨")
        self.navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
    
    private func moveToHomeVC(_ loginSuccess: Bool){
        if loginSuccess {
            let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
            print("앱 최초 실행 값: \(isFirstLaunch)")
            DispatchQueue.main.async {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVcTo(TabBarVC(), animated: false)
            }
        }
    }
}


