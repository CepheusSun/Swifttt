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

class HomeViewModel {
    
    
    
    func loadHotList() -> Observable<ResponseInfo> {
        
        return Observable.create {
            (observer: AnyObserver<ResponseInfo>) -> Disposable in

            let req = SYNetworkTool.shared.get("live/gettop", parameters: [:], finished: { (status, resp, err) in

                switch status {
                case .success:
                    let array = Mapper<HomeLiveModel>().mapArray(JSONArray: resp?["lives"] as! [[String: Any]])
                    observer.onNext(["info": array!])
                    observer.onCompleted()
                case .unusual:
                    observer.onError(err!)
                case .failure:
                    observer.onError(err!)
                }
            })
            
            return Disposables.create {
                req.cancel()
            }
        }
    }
}
