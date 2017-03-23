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


/// 网络请求回掉闭包 status:响应状态 result:JSON tipString: 提示给用户的信息
typealias NetworkFinished = (_ status: SYResponseStatus, _ result: JSON?, _ tipString: String?) -> ()

class SYNetworkTool: NSObject {
    
    /// 网络工具单例
    static let shared = SYNetworkTool()
    
}

// MARK: - 基础请求方法
extension SYNetworkTool {
    
    func get(_ APIString: String, parameters: [String: Any]?, finished: @escaping NetworkFinished) {
        Alamofire.request(APIString, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }
    }
    
    func post(_ APIString: String, parameters: [String: Any]?, finished: @escaping NetworkFinished) {
        Alamofire.request(APIString, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in
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
            if json["err_msg"].string == "success" {
                finished(.success, json, nil)
            }else {
                finished(.unusual, json, nil)
            }
        case .failure(let error):
            finished(.failure, nil, error.localizedDescription)
        }
    }
}

// MARK: 网络工具方法
extension SYNetworkTool {
    
}
















