//
//  SceneDelegate.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuk on 29.11.2022.
//  Copyright © 2022 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit

class SecondWidnow {
    
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var secondWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        print("scenescene \(scene) \(connectionOptions)  \(session.role)")
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        switch session.role {
        case .windowApplication:
            window = UIWindow(windowScene: scene)
            AppRouter.runOnLoadFlow(window: window)
            window?.makeKeyAndVisible()
            
        case .windowExternalDisplay:
            secondWindow = UIWindow(windowScene: scene)
            let vc = UIViewController()
            vc.view.backgroundColor = .orange
            secondWindow?.rootViewController = vc
            secondWindow?.isHidden = false
            
        default: break
        }
    }
}
