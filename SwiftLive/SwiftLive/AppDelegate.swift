//
//  AppDelegate.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window?.frame = UIScreen.main.bounds
        self.window?.rootViewController = MNavigationController(rootViewController: HomeController())
        self.window?.makeKeyAndVisible()
        
        return true
    }


    
}

