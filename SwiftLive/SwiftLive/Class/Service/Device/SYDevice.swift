//
//  SYDevice.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import AdSupport


class SYDevice: NSObject {
    
    
    let app_info_dictionary = Bundle.main.infoDictionary!
    /// 单例对象
    static let device = SYDevice()
    
    /// 获取设备IDFA
    ///
    /// - Returns: IDFA string
    func idfaString() -> String! {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /// 获取设备IDFV
    ///
    /// - Returns: IDFV string
    func idfvString() -> String! {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// 获取设备 os 版本号
    ///
    /// - Returns: 10.000000
    func os_version() -> String! {
        let string = UIDevice.current.systemVersion
        let strArray = string.components(separatedBy: ".")
        let count = 6 - strArray[1].characters.count
        var str = ""
        for _ in 0..<count {
            str.append("0")
        }
        return "\(strArray.first!).\(strArray[1])\(str)"
    }
    
    /// 获取设备名称
    ///
    /// - Returns: iPhone7_1    -> 6p
    func device_name() -> String! {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }.replacingOccurrences(of: ",", with: "_")

//        return UIDevice.current.systemName
    }
    
    
}


extension SYDevice {
    /// 获取 app 版本信息
    ///
    /// - Returns: 1.0.0
    func app_version() -> String! {
        return app_info_dictionary["CFBundleShortVersionString"] as! String!
    }
}
