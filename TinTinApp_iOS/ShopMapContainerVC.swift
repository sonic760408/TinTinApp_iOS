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
import Foundation

class ShopMapContainerVC: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var viewMap: GMSMapView!

    var myshop: [ShopLoc] = []
    
    var MapLocCounter = 0
    var SwiftTimer = Timer()
    
    let REFRESH_LOC_PERIOD:Int = 60
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    private var yourloc_marker = GMSMarker()
    
    private var your_Latitude:Double = 0 //latitude (-90 ~ 90)
    private var your_Longitude:Double = 0 //longitude (-180 ~ 180)
    
    let DEFAULT_ZOOM_LEVEL:Float = 15.0;
    
    private var isAddStartLoc : Bool = false
    
    // 1.創建 locationManager
    var locationManager : CLLocationManager!
    
    //@IBOutlet weak var btn_shop: UIButton!
    //@IBOutlet weak var btn_shopmap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("viewDidLoad")
        //addSlideMenuButton()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.viewMap.addSubview(self.viewMap)
        
        locationManager = CLLocationManager()
        SwiftTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ShopOneMapVC.updateCounter), userInfo: nil, repeats: true)
        self.initViewObj()
        self.loadInfo()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {

        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert("定位服務被設定拒絕使用, 請到設定->丁丁連鎖藥妝->位置啟用定位服務")
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways
            || CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            locationManager.startUpdatingLocation()
        }
        
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        //self.viewMap.clear()
        //self.viewMap.removeFromSuperview()
        //self.viewMap = nil
        print("viewDidDisappear")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewObj()
    {
        let logo = UIImage(named: "ic_title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.title=""
        
        //set camera as taiwan center
        
        let camera = GMSCameraPosition.camera(withLatitude: 22.670355,
                                                          longitude: 120.367622,
                                                          zoom: DEFAULT_ZOOM_LEVEL)
        self.viewMap.camera = camera
        self.viewMap.isMyLocationEnabled = true
        self.viewMap.settings.myLocationButton = true
        self.viewMap.settings.compassButton = true

        //self.view = viewMap
        
        let your_markerImage = UIImage(named: "your_loc")!.withRenderingMode(.automatic)
        
        //creating a marker view
        let your_markerView = UIImageView(image: your_markerImage)
        yourloc_marker.iconView = your_markerView
        //add other position
        
        
        /*
        self.btn_shop.addTarget(self, action: #selector(ShopMapVC.buttonClicked(_:)), for: .touchUpInside)
        self.btn_shopmap.addTarget(self, action: #selector(ShopMapVC.buttonClicked(_:)), for: .touchUpInside)
        */
    }
    
    func updateCounter() {
        MapLocCounter += 1
        //NSLog("\(MapLocCounter)")
        if(MapLocCounter % REFRESH_LOC_PERIOD == 0)
        {
            //NSLog("REFRESH LOCATION")
            locationFixAchieved = false
        }
    }
    
    //get location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        _ = locationObj.coordinate
        
        //refresh location every 30 sec
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            
            //print(" --- 2 --- ")
            //print("LAT \(coord.latitude), LNG: \(coord.longitude)")
            //print(coord.longitude)
            
            //add marker to map
            //let marker = GMSMarker()
            yourloc_marker.map = nil
            let userLocation = locations.last
            yourloc_marker.position = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
            yourloc_marker.title = "我的位置"
            yourloc_marker.snippet = ""
            yourloc_marker.map = viewMap
            viewMap.selectedMarker = yourloc_marker
            
            your_Latitude = userLocation!.coordinate.latitude
            your_Longitude = userLocation!.coordinate.longitude
            
            //find to nearest shop
            let nearest_shop = findNearestShop()
            //print("NEAREST SHOP: \(nearest_shop?.getShop_name() ?? "none")")
            
            if(nearest_shop != nil){
                let url = getDirectionsUrl(origin_lat: your_Latitude, origin_lng: your_Longitude, dest_lat: nearest_shop!.getShop_lat(), dest_lng: nearest_shop!.getShop_lng())
            
                //move camera
                let camera = GMSCameraPosition.camera(withLatitude: your_Latitude,
                                                      longitude: your_Longitude,
                                                      zoom: DEFAULT_ZOOM_LEVEL)
                self.viewMap.camera = camera
                drawShopRoute(_url: url)
                
                
            }
            //let url = getDirectionsUrl(origin_lat: coord.latitude, origin_lng: coord.longitude,dest_lat: oneshop.getShop_lat(), dest_lng: oneshop.getShop_lng())
            
            //print(" URL: \(url)")
            //drawShopRoute(_url: url)
            
        }
    }
    
    private func getDirectionsUrl(origin_lat: Double, origin_lng: Double, dest_lat: Double, dest_lng: Double) ->String
    {
        // Origin of route
        var str_origin: String  = "origin="
        str_origin += String(format:"%f", origin_lat)
        str_origin += ","
        str_origin += String(format:"%f", origin_lng)
        
        // Destination of route
        var str_dest:String = "destination="
        str_dest += String(format:"%f", dest_lat)
        str_dest += ","
        str_dest += String(format:"%f", dest_lng)
        
        // Sensor enabled
        let sensor:String  = "sensor=false";
        
        // Building the parameters to the web service
        let parameters:String  = str_origin + "&" + str_dest + "&" + sensor;
        
        // Output format
        let output:String  = "json";
        
        // Building the url to the web service
        var url:String = "https://maps.googleapis.com/maps/api/directions/"
        url += output
        url += "?"
        url += parameters
        
        return url;
    }
    
    private func drawShopRoute(_url: String)
    {
        let url = URL(string: _url)!
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
                //print(response.request)  // original URL request
                //print(response.response) // HTTP URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    
                    let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
                    
                    let routesArray = (mapResponse["routes"] as? Array) ?? []
                    
                    let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    
                    let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                    let polypoints = (overviewPolyline["points"] as? String) ?? ""
                    let line  = polypoints
                    
                    self.addPolyLine(encodedString: line)
                }
                break
            case .failure(let error):
                self.view.makeToast("請啟用網路連線進行路線規劃",duration: 3.0, position: .bottom)
                NSLog("%s, line:%d - Error: \(error)", #function, #line)
                break
            }
        }
        
    }
    
    private func addPolyLine(encodedString: String) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.init(red: 102, green: 179, blue: 255)
        polyLine.map = viewMap
        
        //show toast only one time
        if (isAddStartLoc == false) {
            self.view.makeToast("規劃路線已完成",duration: 3.0, position: .bottom)
            isAddStartLoc = true;
        }

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
            var str = myshop[i].getShop_addr().appending("\n")
            str = str.appending(myshop[i].getShop_phone())
            marker.snippet = str
            //marker.icon = GMSMarker.markerImage(with: UIColor.green)
            marker.iconView = markerView
            marker.map = viewMap
            
        }
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
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
    
    private func findNearestShop() -> ShopLoc?
    {
        var minDistance: Double = Double.greatestFiniteMagnitude
        var distance: Double, shop_lat: Double, shop_lng: Double
        
        var nearestShop_index: Int = 0
        
        if (myshop.count != 0)
        {
            for i in 0 ..< Int(myshop.count){
                shop_lat = myshop[i].getShop_lat()
                shop_lng = myshop[i].getShop_lng()
                distance = self.calDistance(lat_start: your_Latitude, lat_end: shop_lat, lon_start: your_Longitude, lon_end: shop_lng, el_start: 0, el_end: 0)
                
                if (distance < minDistance)
                {
                    nearestShop_index = i;
                    minDistance = distance;
                }
                print("1 nearestShop_index = \(nearestShop_index)")
                
            }
            print("2 nearestShop_index = \(nearestShop_index)")
            return myshop[nearestShop_index]
        }
        else{
            NSLog("%s, line:%d - ERROR: NO SHOP AVAILABLE", #function, #line)
            return nil
        }
    }
    
    private func calDistance(lat_start: Double, lat_end: Double, lon_start: Double,
                             lon_end: Double, el_start: Double, el_end: Double) -> Double
    {
        let R:Double = 6371.0; // Radius of the earth
        
        let latDistance:Double = Double(lat_end - lat_start).degreesToRadians
        let lonDistance:Double = Double(lon_end - lon_start).degreesToRadians
        let a:Double  = sin(latDistance / 2) * sin(latDistance / 2)
            + cos(Double(lat_start).degreesToRadians) * cos(Double(lat_end).degreesToRadians)
            * sin(lonDistance / 2) * sin(lonDistance / 2)
        let c:Double = 2 * atan2(sqrt(a), sqrt(1 - a))
        var distance:Double = R * c * 1000; // convert to meters
        
        let height:Double = el_start - el_end;
        
        distance = pow(distance, 2) + pow(height, 2)
    
        return sqrt(distance);
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

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
