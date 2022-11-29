//
//  AppRouter.swift
//  GalleryTestProject
//
//  Created by Vladislav Nikolaychuck on 09.09.2020.
//  Copyright © 2020 Vladislav Nikolaychuck. All rights reserved.
//

import UIKit

final class AppRouter {
    
    static var window: UIWindow?
    
    static func runOnLoadFlow(window: UIWindow?) {
        self.window = window
        AppRouter.runMainFlow()
    }
    
    static func runMainFlow() {
        let mainController = InitialViewController()
        let navigation = UINavigationController(rootViewController: mainController)
        changeFlowTo(controller: navigation)
    }
    
    // MARK: Helpers
    static private func runFadeAnimationForWindow(_ window: UIWindow?) {
        guard let window = window else {
            return
        }
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.5
        UIView.transition(with: window, duration: duration,
                          options: options, animations: {},
                          completion: { _ in })
    }
    
    static func changeFlowTo(controller: UIViewController) {
        window?.rootViewController = controller
        runFadeAnimationForWindow(window)
    }
}
