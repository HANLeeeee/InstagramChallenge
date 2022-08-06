//
//  SceneDelegate.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/26.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var isLogged: Bool = false
    var usertoken = UserDefaultsData.shared.getToken().jwt

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        print(usertoken ?? "")
        APIUserGet().autoSignIn(accessToken: usertoken!, completion: { result in
            switch result {
            case .success(let result):
                if result.code == 1001 {
                    let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
                    guard let FeedTabBarViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedTabBarViewController") as? FeedTabBarViewController else {
                        return
                    }
                    self.window?.rootViewController = FeedTabBarViewController
                } else {
                    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
                    guard let LoginNavigationViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as? LoginNavigationViewController else {
                        return
                    }
                    self.window?.rootViewController = LoginNavigationViewController
                }
                
            case .failure(let error):
                print(error)
            }
        })
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func changeRootVC (_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else {
            return
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
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
}

