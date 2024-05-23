//
//  TicketBookVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/10/24.
//

import UIKit

class TicketBookVC: UIViewController {
    
    // MARK: - Properties
    
    private let minimumLineSpacing: CGFloat = 16
    private let minimumInteritemSpacing: CGFloat = 16
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 티켓북"
        label.font = .rcFont18B()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var ticketCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = minimumLineSpacing
        flowlayout.minimumInteritemSpacing = minimumLineSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        view.dataSource = self
        view.delegate = self
        view.register(TicketBookCollectionViewCell.self, forCellWithReuseIdentifier: TicketBookCollectionViewCell.identifier)
        return view
    }()
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .rcMain
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "tag.slash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        
        button.configuration = config
        button.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        button.configurationUpdateHandler =  { button in
            print("handler")
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "tag")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
            default:
                button.configuration?.image = UIImage(systemName: "tag.slash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
            }
        }
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setupNavigation()
        
        setCollectionView()
        setFloatingButton()  // 제일 마지막에 추가해야 모든 뷰 위에 추가됨
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingButton.frame = CGRect(x: view.frame.size.width - 50 - 25, y: view.frame.size.height - 50 - 25, width: 50, height: 50)
    }
    
    // MARK: - Layout
    
    private func setupNavigation(){
//        let appearance = UINavigationBarAppearance()
//        appearance.titlePositionAdjustment = UIOffset(horizontal: -(view.frame.width/2), vertical: 0)
//        appearance.configureWithTransparentBackground()  // 내비게이션 바의 선을 지우고 뷰컨트롤러의 배경색을 사용
//
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.compactAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = titleLabel
//        self.navigationItem.title = "내 티켓북"
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.rcFont18B()]
        
        
        let addNewButtonItem = UIBarButtonItem(image: UIImage.addIcon, style: .done, target: self, action: #selector(addNewTicket))

        // left bar button을 추가하면 기존의 스와이프 pop 기능이 해제되므로 다시 세팅
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.navigationItem.rightBarButtonItem = addNewButtonItem
    }
    
    private func setFloatingButton(){
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(floatingButton)
    }
    
    private func setCollectionView(){
        ticketCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ticketCollectionView)
        
        NSLayoutConstraint.activate([
            ticketCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            ticketCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            ticketCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            ticketCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewTicket(){
        print("새 티켓북 추가")
    }
    
    @objc func didTapFloatingButton(){
        print("플로팅 버튼 선택됨")
        floatingButton.isSelected.toggle()
        print(floatingButton.isSelected)
    }
}

// MARK: - Extension: UIGestureRecognizerDelegate

extension TicketBookVC: UIGestureRecognizerDelegate {
}

// MARK: - Extension: CollectionView

extension TicketBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ticketCollectionView.dequeueReusableCell(withReuseIdentifier: TicketBookCollectionViewCell.identifier, for: indexPath) as? TicketBookCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ticketBookDetailVC = TicketBookDetailVC()
        ticketBookDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ticketBookDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat((collectionView.frame.width - 16 * 2 - minimumInteritemSpacing) / 2)  // 16은 collectionview inset
        return CGSize(width: cellWidth, height: cellWidth * 26 / 17)
    }
}
