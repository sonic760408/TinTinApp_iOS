//
//  SalesItemModel.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/6/1.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import Gloss

class SalesItem: Decodable{
    
    private var name: String
    private var smalliconUrl: String
    private var bigiconUrl: String
    private var description: String
    private var memo: String
    
    private var price1: Int
    private var price2: Int
    private var cid: Int
    private var prdtcode: String
    private var order: Int
    
    init()
    {
        self.name = ""
        self.smalliconUrl = ""
        self.bigiconUrl = ""
        self.description = ""
        self.memo = ""
        
        self.price1 = 0
        self.price2 = 0
        self.cid = 0
        self.prdtcode = ""
        self.order = 0
    }
    
    init(name: String, smalliconUrl: String, bigiconUrl: String, description: String, memo: String, price1: Int, price2: Int, cid: Int, prdtcode: String, order: Int)
    {
        self.name = ""
        self.smalliconUrl = ""
        self.bigiconUrl = ""
        self.description = ""
        self.memo = ""
        
        self.price1 = 0
        self.price2 = 0
        self.cid = 0
        self.prdtcode = ""
        self.order = 0
    }
    
    required init?(json: JSON)
    {
        self.name = ("name" <~~ json)!
        self.smalliconUrl = ("smallicon" <~~ json)!
        self.bigiconUrl = ("bigicon" <~~ json)!
        
        if(json.index(forKey: "desc") != nil)
        {
            self.description = ("desc" <~~ json)!
        }else{
            self.description = ""
        }
        if(json.index(forKey: "memo") != nil)
        {
            self.memo = ("memo" <~~ json)!
        }else
        {
            self.memo = ""
        }
        
        self.price1 = ("price1" <~~ json)!
        self.price2 = ("price2" <~~ json)!
        self.cid = ("cid" <~~ json)!
        self.prdtcode = ("prdtcode" <~~ json)!
        self.order = ("order" <~~ json)!
    }
    
    func setName(_name: String)
    {
        self.name = _name
    }
    
    func getName()->String
    {
        return self.name
    }
    
    func setSmalliconUrl(_smalliconUrl: String)
    {
        self.smalliconUrl = _smalliconUrl
    }
    
    func getSmalliconUrl()->String
    {
        return self.smalliconUrl
    }
    
    func setBigiconUrl(_bigiconUrl: String)
    {
        self.bigiconUrl = _bigiconUrl
    }
    
    func getBigiconUrl()->String
    {
        return self.bigiconUrl
    }
    
    func setDescription(_description: String)
    {
        self.description = _description
    }
    
    func getDescription()->String
    {
        return self.description
    }
    
    func setMemo(_memo: String)
    {
        self.memo = _memo
    }
    
    func getMemo()->String
    {
        return self.memo
    }
    
    func setPrice1(_price1: Int)
    {
        self.price1 = _price1
    }
    
    func getPrice1()->Int
    {
        return self.price1
    }
    
    func setPrice2(_price2: Int)
    {
        self.price2 = _price2
    }
    
    func getPrice2()->Int
    {
        return self.price2
    }
    
    func setCid(_cid: Int)
    {
        self.cid = _cid
    }
    
    func getCid()->Int
    {
        return self.cid
    }
    
    func setPrdtcode(_prdtcode: String)
    {
        self.prdtcode = _prdtcode
    }
    
    func getPrdtcode()->String
    {
        return self.prdtcode
    }
    
    func setOrder(_order: Int)
    {
        self.order = _order
    }
    
    func getOrder()->Int
    {
        return self.order
    }
}
