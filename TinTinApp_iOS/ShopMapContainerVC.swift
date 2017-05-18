//
//  ShopMapVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/17.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import Gloss
import MapKit
import GooglePlaces

class ShopMapContainerVC: UIViewController {

    @IBOutlet weak var viewMap: GMSMapView!

    var myshop: [ShopLoc] = []
    
    //@IBOutlet weak var btn_shop: UIButton!
    //@IBOutlet weak var btn_shopmap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewObj()
        self.loadInfo()
        //addSlideMenuButton()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //print("viewDidDisappear")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initMap()
    {
        
    }
    
    func initViewObj()
    {
        let logo = UIImage(named: "ic_title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.title=""
    
        let DEFAULT_ZOOM_LEVEL:Float = 17.0;
        
        //set camera as taiwan center
        let camera = GMSCameraPosition.camera(withLatitude: 22.670355,
                                                          longitude: 120.367622,
                                                          zoom: DEFAULT_ZOOM_LEVEL)
        self.viewMap.camera = camera
        self.viewMap.isMyLocationEnabled = true
        self.viewMap.settings.myLocationButton = true
        //self.view = viewMap
        
        /*
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(22.670355, 120.367622)
        marker.title = "丁丁藥局"
        marker.snippet = "TEST"
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        marker.map = viewMap
        */
        
        //add other position
        
        
        /*
        self.btn_shop.addTarget(self, action: #selector(ShopMapVC.buttonClicked(_:)), for: .touchUpInside)
        self.btn_shopmap.addTarget(self, action: #selector(ShopMapVC.buttonClicked(_:)), for: .touchUpInside)
        */
    }
    
    func addMarker()
    {
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "supermarket")!.withRenderingMode(.automatic)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        var marker: GMSMarker;
        for i:Int in 0  ..< Int(myshop.count)
        {
            //add marker
            //NSLog("%s, line:%d LNG: %f, LAT: %f", #function, #line, myshop[i].getShop_lng(), myshop[i].getShop_lat())
            
            marker = GMSMarker()
            marker.position =
                CLLocationCoordinate2DMake(myshop[i].getShop_lat(), myshop[i].getShop_lng())
            marker.title = myshop[i].getShop_name()
            marker.snippet = myshop[i].getShop_addr()
            //marker.icon = GMSMarker.markerImage(with: UIColor.green)
            marker.iconView = markerView
            marker.map = viewMap
            
        }
    }
    
    /*
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    */
    
    private func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("2 Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func loadInfo()
    {
        
        let url = URL(string: "https://www.norbelbaby.com.tw/tintinapp/w/store/json/grid")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["",""]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
            print("Error: JSON ERROR")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        manager.request(urlRequest).responseJSON { response in
            
            switch response.result{
            case .success (let data):
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    _ = result as! NSDictionary
                    //print(json_str)
                    guard data is JSON
                        else{fatalError()}
                    let shop = self.parseJSON(data: data as! JSON)
                    
                    //for i in 0 ..< Int(shop.count){
                    //    print("SHOP NAME: \(i) : \(shop[i].shop_name )")
                    //}
                    
                    self.myshop = shop
                    self.addMarker()
                    //self.regShopTable()
                }
                
                break
                
            case .failure(let error):
                print("Error: \(error)")
                break
            }
        }
    }
    
    /*
    func buttonClicked(_ sender: AnyObject?) {
        if sender === btn_shop {
            // do something
            print("2 SHOP\n")
            self.openViewControllerBasedOnIdentifier("ShopVC")
        } else if sender === btn_shopmap {
            // do something
            print("2 ShopMap\n")
            self.openViewControllerBasedOnIdentifier("ShopMapVC")
        }
    }
    */
    
    func parseJSON(data: Any) -> [ShopLoc]
    {
        //print(_dict)
        
        //parse the data
        //var array = [ShopLoc]() //alternatively (does the same): var array = Array<Country>()
        
        guard let value = data as? JSON,
            let eventsArrayJSON = value["rows"] as? [JSON]
            else { fatalError() }
        let shoplocs = [ShopLoc].from(jsonArray: eventsArrayJSON)//the JSON deserialization is done here, after this line you can do anything with your JSON
        //for i in 0 ..< Int((shoplocs?.count)!) {
        //    print("SHOP: \(i) : \(shoplocs?[i].shop_no ?? "")")
        
        //set to the object
        
        //}
        
        return shoplocs!
        //array.append(ShopLoc())
    }
}
