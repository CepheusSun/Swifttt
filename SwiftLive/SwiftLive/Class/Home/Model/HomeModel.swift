//
//  HomeModel.swift
//  SwiftLive
//
//  Created by sunny on 2017/3/22.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import Foundation
import ObjectMapper

struct HomeLiveModel: Mappable {
    
    var city : String!
    var creator : SYCreator!
    var extra : SYExtra!
    var group : Int!
    var id : String!
    var image : String!
    var landscape : Int!
    var like : [AnyObject]!
    var link : Int!
    var liveType : String!
    var multi : Int!
    var name : String!
    var onlineUsers : Int!
    var optimal : Int!
    var pubStat : Int!
    var roomId : Int!
    var rotate : Int!
    var shareAddr : String!
    var slot : Int!
    var status : Int!
    var streamAddr : String!
    var tagId : Int!
    var token : String!
    var version : Int!
    
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        
    }
}


struct SYCreator: Mappable {

    var birth : String!
    var descriptionField : String!
    var emotion : String!
    var gender : Int!
    var gmutex : Int!
    var hometown : String!
    var id : Int!
    var inkeVerify : Int!
    var level : Int!
    var location : String!
    var nick : String!
    var portrait : String!
    var profession : String!
    var rankVeri : Int!
    var sex : Int!
    var thirdPlatform : String!
    var veriInfo : String!
    var verified : Int!
    var verifiedReason : String!
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        
    }
}

struct SYExtra: Mappable {
    var cover : AnyObject!
    var label : [SYLabel]!
    
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        
    }
}

struct SYLabel: Mappable {
    
    var cl : [Int]!
    var tabKey : String!
    var tabName : String!
    
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        
    }
}
