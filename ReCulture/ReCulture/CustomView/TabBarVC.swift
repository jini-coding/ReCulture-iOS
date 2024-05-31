//
//  TabBarVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    let HEIGHT_TAB_BAR: CGFloat = 100
    var previousIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self

        setupLayout()
        setupShadow()
        selectedIndex = 0
    }

    func setupLayout() {
        
        view.backgroundColor = UIColor.white
        
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor.rcMain
        tabBar.unselectedItemTintColor = UIColor.rcGray300
        
        tabBar.isHidden = false
        tabBar.isTranslucent = false
        
        //글자 크기 12로 설정해두기 M12
        setTabBarItemAttributes()
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "Home_icon"), tag: 0)
        
        
        let searchVC = UINavigationController(rootViewController: SearchVC())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "Search_icon"), tag: 1)
        
        let addRecordVC = RecordTypeVC()
        addRecordVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Add_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
        addRecordVC.tabBarItem.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
        
        let recordVC = UINavigationController(rootViewController: RecordVC())
        recordVC.tabBarItem = UITabBarItem(title: "기록", image: UIImage(named: "Record_icon"), tag: 3)
        
        
        let mypageVC = UINavigationController(rootViewController: MypageVC())
        mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "User_icon"), tag: 4)
        
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        searchVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        //addRecordVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        recordVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        mypageVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        viewControllers = [homeVC, searchVC, addRecordVC, recordVC, mypageVC]
    }
    
    func setTabBarItemAttributes() {
        let attributes = [NSAttributedString.Key.font: UIFont.rcFont12M()]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    func setupShadow() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("should select")
//        print(selectedIndex)
//        if viewController == tabBarController.viewControllers?[2] {
//            let modalVC = RecordTypeVC() // 모달로 띄울 새로운 뷰 컨트롤러
//            modalVC.modalPresentationStyle = .fullScreen
//            self.present(modalVC, animated: true, completion: nil)
//            // false 리턴 -> 탭 선택이 일어나지 않게
//        }
//    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("did select")
        if item == tabBar.items?[2] {
            let modalVC = RecordTypeVC() // 모달로 띄울 새로운 뷰 컨트롤러
            modalVC.modalPresentationStyle = .fullScreen
            self.present(modalVC, animated: true, completion: nil)
            // false 리턴 -> 탭 선택이 일어나지 않게
        }
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        <#code#>
//    }
}


extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
}
