//
//  CompleteCustomizingModal.swift
//  ReCulture
//
//  Created by Jini on 6/5/24.
//

import UIKit

class CompleteCustomizingModal : UIViewController {
    
    let currentVC: UIViewController
    weak var delegate: CompleteModalDelegate?
    
    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 322, height: 200))
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.rcFont20B()
        
        return label
    }()
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.rcFont16M()
        
        return label
    }()
    
    let confirmButton : UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.rcMain
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        return button
    }()
    
    // 모달 제목 바꾸는 함수
    func changeTitle(title : String){
        titleLabel.text = title
    }
    
    init(currentVC: UIViewController){
        self.currentVC = currentVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentCustomModal()
        setupBackground()
        setupCompleteView()
    }
    
    func presentCustomModal() {
        customModal.backgroundColor = UIColor.white
        view.addSubview(customModal)
        customModal.center = view.center
    }
    
    private func setupBackground() {
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }
    
    
    
    private func setupCompleteView() {
        customModal.addSubview(titleLabel)
        customModal.addSubview(contentLabel)
        customModal.addSubview(confirmButton)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let titleAttributedText = NSAttributedString(string: "티켓 완성!", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.attributedText = titleAttributedText
        titleLabel.textAlignment = .center
       
        let contentAttributedText = NSAttributedString(string: "완성된 티켓은 티켓북에서 확인할 수 있어요", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        contentLabel.attributedText = contentAttributedText
        contentLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 35),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            contentLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            confirmButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
            confirmButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            confirmButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            confirmButton.heightAnchor.constraint(equalToConstant: 52)
            
        ])
        
        confirmButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func goBack() {
        
        print("이전 화면으로 돌아가기")
//         dismiss(animated: true){
//             let vc = self.currentVC as! TicketCustomizingVC
//             vc.popVC()
//         }

        delegate?.dismissCompleteModal()
        let vc = TabBarVC()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(vc, animated: false)
        
    }
    
    @objc func popupDismiss(){

        delegate?.dismissCompleteModal()
    }
}
