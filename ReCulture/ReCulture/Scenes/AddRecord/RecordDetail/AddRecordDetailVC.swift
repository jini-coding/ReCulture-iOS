//
//  AddRecordDetailVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/24/24.
//

import UIKit

class AddRecordDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private let selectedType: String
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 추가"
        label.font = .rcFont16M()
        return label
    }()
    
    private let writeDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "문화 생활에 대해\n기록해주세요"
        label.font = .rcFont26B()
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initialization
    
    init(type: String) {
        self.selectedType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setWriteDetailLabel()
    }
    
    // MARK: - Layout
    
    private func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
    }
    
    private func setWriteDetailLabel(){
        writeDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(writeDetailLabel)
        
        NSLayoutConstraint.activate([
            writeDetailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            writeDetailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
        ])
    }
    
    // MARK: - Functions
}
