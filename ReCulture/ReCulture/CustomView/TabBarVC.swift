//
//  TabBarVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class TabBarVC: UITabBarController {
    
    let HEIGHT_TAB_BAR: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        selectedIndex = 0
        
    }

    func setupLayout() {
        
        view.backgroundColor = UIColor.white
        
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = UIColor.gray
        
        tabBar.isHidden = false
        tabBar.isTranslucent = false
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home_icon"), tag: 0)
        
        
        let searchVC = UINavigationController(rootViewController: SearchVC())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "search_icon"), tag: 1)
        
        
        let recordVC = UINavigationController(rootViewController: RecordVC())
        recordVC.tabBarItem = UITabBarItem(title: "기록", image: UIImage(named: "pill_icon"), tag: 2)
        
        
        let mypageVC = UINavigationController(rootViewController: MypageVC())
        mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "person_icon"), tag: 3)
        
        viewControllers = [homeVC, searchVC, recordVC, mypageVC]
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
}
