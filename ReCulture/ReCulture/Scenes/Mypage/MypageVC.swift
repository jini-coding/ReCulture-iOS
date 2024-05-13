//
//  MypageVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class MypageVC: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "MypageVC"
        label.textColor = UIColor.blue
        
        return label
    }()
    
    // 티켓북 보기로 이동하기 위한 임시 버튼입니다.
    let tempButton: UIButton = {
        let button = UIButton()
        button.setTitle("티켓북 보러가기", for: .normal)
        button.setTitleColor(.rcMain, for: .normal)
        button.addTarget(self, action: #selector(goToTicketBook), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setTestLabel()
        setTempButton()
        
    }
    
    func setTestLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 23)
        ])
    }

    private func setTempButton(){
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tempButton)
        
        NSLayoutConstraint.activate([
            tempButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            tempButton.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
    
    @objc func goToTicketBook(){
        let ticketBookVC = TicketBookVC()
        ticketBookVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ticketBookVC, animated: true)
    }
}

