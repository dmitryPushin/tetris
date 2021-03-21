//
//  AppDelegate.swift
//  Tetris
//
//  Created by Dmitry Pushin on 26/10/2018.
//  Copyright © 2018 Dmitry Pushin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let gameController = GameController(grid: GameGrid())
        let vc = GameViewController(gameController: gameController, elementSize: CGSize(width: 30, height: 30))
        gameController.delegate = vc

        let navVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}
