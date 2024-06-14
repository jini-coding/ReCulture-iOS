//
//  SceneDelegate.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        print("sceneDelegate -- 앱 최초 실행 값: \(isFirstLaunch)")
        let tabBarVC = TabBarVC() // 첫 시작 화면
        let loginNavVC = UINavigationController(rootViewController: LoginVC()) // 이거로 root 설정 시 로그인부터 시작함
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = isFirstLaunch ? tabBarVC :loginNavVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    /// 로그인, 회원가입 완료 후 홉으로 넘어가게 하기 위해!
    func changeRootVcTo(_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환

        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}

extension SceneDelegate {
    func changeRootVC(_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
        UIView.transition(with: window, duration: 0.26, options: [.transitionCrossDissolve], animations: nil, completion: nil)
      }
}
