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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MNavigationController(rootViewController: HomeController.controller())
        self.window?.makeKeyAndVisible()
        
    
        _ = SYLocationTool.shared
        
        
        
        var res: [String :Any] = [:]
        
        res["gps_info"] = SYLocationTool.shared.gps_info_string()
        res["loc_info"] = SYLocationTool.shared.loc_info_string()
        res["cv"] = "IK\(SYDevice.device.os_version())_Iphone"
        res["idfv"] = SYDevice.device.idfvString()
        res["idfa"] = SYDevice.device.idfaString()
        res["osversion"] = "ios_\(SYDevice.device.os_version()!)"
        res["imsi"] = ""
        res["imei"] = ""
        res["ua"] = SYDevice.device.device_name()
        dump(res)
        return true
    }


    
}

