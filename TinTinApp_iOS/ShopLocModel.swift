//
//  ShopLoc.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/11.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import Gloss

class ShopLoc: Decodable{
    
    var shop_no: String;
    var shop_name: String;
    var shop_lat: Double;  //latitude
    var shop_lng: Double;  //longitude
    var shop_addr: String;  //shop address
    
    var shop_phone: String; //shop phone no
    var shop_fpark: Bool; //shop parking (0: none, 1: private, 2:public)
    var shop_ppark: Bool; //shop parking (0: none, 1: private, 2:public)
    var isHiShop: Bool;  //is health insurance pharmacy
    var shop_onBus: String; //shop on business
    var shop_offBus: String; //shop off business
    
    var isMetro: Bool; //metro shop
    
    init()
    {
        shop_no = "";
        shop_name = "";
        shop_lat = 0.0;
        shop_lng = 0.0;
        shop_addr = "";
        
        shop_phone = "";
        shop_fpark = false;
        shop_ppark = false;
        isHiShop = false;
        shop_onBus = "";
        shop_offBus = "";
        
        isMetro = false;
    }
    
    init(shop_no: String, shop_name: String, shop_lat: Double, shop_lng: Double,
         shop_addr: String, shop_phone: String, shop_fpark: Bool, shop_ppark: Bool,
         isHiShop: Bool, shop_onBus: String, shop_offBus: String, isMetro: Bool)
    {
        self.shop_no = shop_no;
        self.shop_name = shop_name;
        self.shop_lat = shop_lat;
        self.shop_lng = shop_lng;
        self.shop_addr = shop_addr;
        
        self.shop_phone = shop_phone;
        self.shop_fpark = shop_fpark;
        self.shop_ppark = shop_ppark;
        self.isHiShop = isHiShop;
        self.shop_onBus = shop_onBus;
        self.shop_offBus = shop_offBus;
        
        self.isMetro = isMetro;
    }
    
    required init?(json: JSON)
    {
        self.shop_no = ("id" <~~ json)!
        self.shop_name = ("name" <~~ json)!
        self.shop_lat = ("lat" <~~ json)!
        self.shop_lng = ("lng" <~~ json)!
        self.shop_addr = ("address" <~~ json)!
        
        self.shop_phone = ("phone" <~~ json)!
        self.shop_fpark = ("fpark" <~~ json)!
        self.shop_ppark = ("ppark" <~~ json)!
        self.isHiShop = ("hi" <~~ json)!
        self.shop_onBus = ("timerun" <~~ json)!
        self.shop_offBus = ("timeup" <~~ json)!
        
        self.isMetro = ("metro" <~~ json)!
    }
    
    func setShop_no(_shop_no: String)
    {
        self.shop_no = _shop_no
    }
    
    func getShop_no()->String
    {
        return self.shop_no
    }
    
    func setShop_name(_shop_name: String)
    {
        self.shop_name = _shop_name
    }
    
    func getShop_name()->String
    {
        return self.shop_name
    }
    
    func setShop_lat(_shop_lat: Double){
        self.shop_lat = _shop_lat
    }
    
    func getShop_lat()->Double{
        return self.shop_lat
    }
    
    func setShop_lng(_shop_lng: Double){
        self.shop_lng = _shop_lng
    }
    
    func getShop_lng()->Double{
        return self.shop_lng
    }
    
    func setShop_addr(_shop_addr: String){
        self.shop_addr = _shop_addr
    }
    
    func getShop_addr()->String{
        return self.shop_addr
    }
    
    func setShop_phone(_shop_phone: String){
        self.shop_phone = _shop_phone
    }
    
    func getShop_phone()->String{
        return shop_phone
    }
    
    func setShop_fpark(_shop_fpark: Bool){
        self.shop_fpark = _shop_fpark
    }
    
    func getShop_fpark()->Bool{
        return shop_fpark
    }
    
    func setShop_ppark(_shop_ppark: Bool){
        self.shop_ppark = _shop_ppark
    }
    
    func getShop_ppark()->Bool{
        return shop_ppark
    }
    
    func setIsHiShop(_isHiShop: Bool){
        self.isHiShop = _isHiShop
    }
    
    func getIsHiShop()->Bool{
        return isHiShop
    }
    
    func setShop_onBus(_shop_onBus: String){
        self.shop_onBus = _shop_onBus
    }
    
    func getShop_onBus()->String{
        return shop_onBus
    }
    
    func setShop_offBus(_shop_offBus: String){
        self.shop_offBus = _shop_offBus
    }
    
    func getShop_offBus()->String{
        return shop_offBus
    }
    
    func setIsMetro(_isMetro: Bool){
        self.isMetro = _isMetro
    }
    
    func getIsMetro()->Bool{
        return isMetro
    }
    
    
}
