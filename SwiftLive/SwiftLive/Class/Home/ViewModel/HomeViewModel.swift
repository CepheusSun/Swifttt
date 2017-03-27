//
//  HomeViewModel.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa


typealias ResponseInfo = Dictionary<String, [HomeLiveModel]>
typealias ResponseTickerInfo = Dictionary<String, [SYTicker]>


enum ResponseType{
    case live
    case ticker
}

typealias HomeVMCallBackClosure = (_ type: ResponseType, _ res: Any?) -> Void
typealias HomeVMErrorCallBackClosure = (_ err: NSError?) -> Void


class HomeViewModel {
    
    /// 回调 Closure
    var closure: HomeVMCallBackClosure?
    var errorClosure: HomeVMErrorCallBackClosure?
    //／ set 的时候回调
    var result: ResponseInfo? {
        didSet {
            self.closure?(.live,result)
        }
    }
    
    var ticker: ResponseTickerInfo? {
        didSet {
            self.closure?(.ticker, ticker)
        }
    }
    
    //／ set 的时候回调
    var error: NSError? {
        didSet {
            self.errorClosure?(error)
        }
    }
    
    /// 刷新数据
    func loadData() {
        return self.loadHotList(true)
    }
    
    /// 加载下一页数据
    func loadMoreData() {
        return self.loadHotList(false)
    }
    
    
    private func loadHotList(_ ticker: Bool) {
        
        _ = SYNetworkTool.shared
            .get("live/gettop", parameters: [:], finished: { (status, resp, err) in
                
                switch status {
                case .success:
                    let array = Mapper<HomeLiveModel>().mapArray(JSONArray: resp?["lives"] as! [[String: Any]])
                    self.result = ["info": array!]
                case .unusual:
                    self.error = err
                case .failure:
                    self.error = err
                }
            })
        if !ticker { return }
        _ = SYNetworkTool.shared
            .get("live/ticker", parameters: [:], finished: { (status, resp, err) in
                
                switch status {
                case .success:
                    let array = Mapper<SYTicker>().mapArray(JSONArray: resp?["ticker"] as! [[String : Any]])
                    self.ticker = ["info": array!]
                case .unusual:
                    self.error = err
                case .failure:
                    self.error = err
                }
            })
    }
}
