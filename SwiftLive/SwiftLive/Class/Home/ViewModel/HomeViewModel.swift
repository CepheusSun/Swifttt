//
//  HomeViewModel.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/23.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    
    var data:[Any] = []
    
    
    
    
    func loadHotList() {
        SYNetworkTool.shared.get("live/gettop", parameters: [:]) { (status, resp, des) in
            
            
            
            
            
            dump(resp)
            
            
            
            
        }
    }
}
