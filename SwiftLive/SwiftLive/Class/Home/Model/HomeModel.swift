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
        city <- map["city"]
        creator <- map["creator"]
        extra <- map["extra"]
        group <- map["group"]
        id <- map["id"]
        image <- map["image"]
        landscape <- map["landscape"]
        like <- map["like"]
        link <- map["link"]
        liveType <- map["live_type"]
        multi <- map["multi"]
        name <- map["name"]
        onlineUsers <- map["online_users"]
        optimal <- map["optimal"]
        pubStat <- map["pub_stat"]
        roomId <- map["room_id"]
        rotate <- map["rotate"]
        shareAddr <- map["share_addr"]
        slot <- map["slot"]
        status <- map["status"]
        streamAddr <- map["stream_addr"]
        tagId <- map["tag_id"]
        token <- map["token"]
        version <- map["version"]
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
        birth <- map["birth"]
        descriptionField <- map["description"]
        emotion <- map["emotion"]
        gender <- map["gender"]
        gmutex <- map["gmutex"]
        hometown <- map["hometown"]
        id <- map["id"]
        inkeVerify <- map["inke_verify"]
        level <- map["level"]
        location <- map["location"]
        nick <- map["nick"]
        portrait <- map["portrait"]
        profession <- map["profession"]
        rankVeri <- map["rank_veri"]
        sex <- map["sex"]
        thirdPlatform <- map["third_platform"]
        veriInfo <- map["veri_info"]
        verified <- map["verified"]
        verifiedReason <- map["verified_reason"]

    }
}

struct SYExtra: Mappable {
    var cover : AnyObject!
    var label : [SYLabel]!
    
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        cover <- map["cover"]
        label <- map["label"]
    }
}

struct SYLabel: Mappable {
    
    var cl : [Int]!
    var tabKey : String!
    var tabName : String!
    
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        cl <- map["cover"]
        tabKey <- map["tab_key"]
        tabName <- map["tab_name"]
    }
}
