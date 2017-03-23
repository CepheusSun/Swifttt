//
//  SYNetworkTool.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReachabilitySwift

/// 请求响应状态
///
/// - success: 响应成功  - 成功
/// - unusual: 响应异常  - 例如:
/// - failure: 请求错误  - 例如: 网络错误
enum SYResponseStatus: Int {
    case success = 0
    case unusual = 1
    case failure = 3
}

let BASE_URL = "http://service.ingkee.com/api/"

/// 网络请求回掉闭包 status:响应状态 result:JSON tipString: 提示给用户的信息
typealias NetworkFinished = (_ status: SYResponseStatus, _ result: JSON?, _ tipString: String?) -> ()

class SYNetworkTool: NSObject {
    
    var connectionState: Int = 0
    /// 网络工具单例
    static let shared = SYNetworkTool()
    
    override init() {
        super.init() 
        
        self.startMonitor()
    }
}

// MARK: - 基础请求方法
extension SYNetworkTool {
    
    /// GET 请求
    ///
    /// - Parameters:
    ///   - APIString: urlSting
    ///   - parameters: 参数
    ///   - finished: 回调用
    func get(_ APIString: String, parameters: [String: Any]?, finished: @escaping NetworkFinished) {
        Alamofire.request("\(BASE_URL)\(APIString)",
                    method: .get,
                    parameters: self.appendPublicParameters(parameters),
                    headers: nil)
            .responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }
    }
    
    /// POST 请求
    ///
    /// - Parameters:
    ///   - APIString: urlSting
    ///   - parameters: 参数
    ///   - finished: 回调用
    func post(_ APIString: String, parameters: [String: Any]?, finished: @escaping NetworkFinished) {
        Alamofire.request("\(BASE_URL)\(APIString)",
                method: .post,
                parameters: self.appendPublicParameters(parameters),
                headers: nil)
            .responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }
    }
    
    /// 处理响应结果
    ///
    /// - Parameters:
    ///   - response: 响应对象
    ///   - finished: 完成回掉
    private func handle(response: DataResponse<Any>, finished: @escaping NetworkFinished) {
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("json \(json)")
            if json["dm_error"].int == 0 {
                finished(.success, json, nil)
            }else {
                finished(.unusual, nil, json["error_msg"].string)
            }
        case .failure(let error):
            finished(.failure, nil, error.localizedDescription)
        }
    }
    
    /// 参数处理,拼接共有参数
    ///
    /// - Parameter parameters: 原始参数
    /// - Returns: 完整参数
    private func appendPublicParameters(_ parameters: [String: Any]!) -> [String: Any]! {
        var res = parameters
        
        res?["gps_info"] = SYLocationTool.shared.gps_info_string()
        res?["loc_info"] = SYLocationTool.shared.loc_info_string()
        res?["cv"] = "IK\(SYDevice.device.app_version()!)_Iphone"
        res?["idfv"] = SYDevice.device.idfvString()
        res?["idfa"] = SYDevice.device.idfaString()
        res?["osversion"] = "ios_\(SYDevice.device.os_version()!)"
        res?["imsi"] = ""
        res?["imei"] = ""
        res?["ua"] = SYDevice.device.device_name()
        
        res?["uid"] = "17800399"
        res?["count"] = "5"
        
        print(res!)
        return res
    }
    
}

// MARK: 网络工具方法
extension SYNetworkTool {
    
    func startMonitor() {
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    self.connectionState = 1
                } else {
                    self.connectionState = 2
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.connectionState = 3
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            
        }
    }
}




