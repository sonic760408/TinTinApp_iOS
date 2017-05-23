//
//  EventModel.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/22.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import Gloss

class Event: Decodable{
    
    private var name:String
    private var enabled:Bool
    private var order:Int
    private var actionurl:String
    private var iconurl:String
    private var rundate:String
    private var deadline:String
    
    init()
    {
        self.name = ""
        self.enabled = false
        self.order = 0
        self.actionurl = ""
        self.iconurl = ""
        self.rundate = ""
        self.deadline = ""
    }
    
    init(name: String, enabled: Bool, order: Int, actionurl: String,
         iconurl: String, rundate: String, deadline: String)
    {
        self.name = name
        self.enabled = enabled
        self.order = order
        self.actionurl = actionurl
        self.iconurl = iconurl
        self.rundate = rundate
        self.deadline = deadline
    }
    
    required init?(json: JSON)
    {
        self.name = ("name" <~~ json)!
        self.enabled = ("enabled" <~~ json)!
        self.order = ("order" <~~ json)!
        self.actionurl = ("actionurl" <~~ json)!
        self.iconurl = ("iconurl" <~~ json)!
        
        self.rundate = ("rundate" <~~ json)!
        self.deadline = ("deadline" <~~ json)!
    }
}
