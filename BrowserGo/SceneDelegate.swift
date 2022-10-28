//
//  SceneDelegate.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit
import FBSDKCoreKit
import Firebase


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        FirebaseApp.configure()
        
        GADUtil.share.requestRemoteConfig()
        
        if let url = connectionOptions.urlContexts.first?.url {
            ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                )
        }
        
        AppRootVC = RootVC()
        
        window?.rootViewController = AppRootVC
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
        GADUtil.share.requestRemoteConfig()
        AppInActive = false
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        AppInActive = true
    }
    

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NotificationCenter.default.post(name: .willLaunhceing, object: nil)
                
        AppEnterBackground = false
        
        AppInActive = false

        
        if AppEnterBackgrounded {
            FirebaseUtil.logEvent(name: .openHot)
        }
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        AppEnterBackground = true
        if !AppEnterBackgrounded {
            AppEnterBackgrounded = true
        }
        
        if let vc = window?.rootViewController?.presentedViewController, let pr = vc.presentedViewController {
            pr.dismiss(animated: true) {
                vc.dismiss(animated: false)
            }
        } else  if  let vc = window?.rootViewController?.presentedViewController {
            vc.dismiss(animated: true)
        }
    }


}

