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

class HomeViewModel: NSObject {
    
    var data:[HomeLiveModel] = [] {
        didSet{
            
        }
    }
    
    func loadHotList() {
        SYNetworkTool.shared.get("live/gettop", parameters: [:]) { (status, resp, des) in
            if status == .success {
                self.data = Mapper<HomeLiveModel>().mapArray(JSONArray: resp?["lives"] as! [[String : Any]])!
            } 
        }
    }
}
