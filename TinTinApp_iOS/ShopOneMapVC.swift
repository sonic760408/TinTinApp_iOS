//
//  ShopOneVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/19.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import MapKit
import Alamofire
import Toast_Swift

class ShopOneMapVC: BaseViewController, CLLocationManagerDelegate {
    
    // This variable will hold the data being passed from the First View Controller
    var oneshop : ShopLoc!
    let DEFAULT_ZOOM_LEVEL:Float = 15.0
    
    var monitoredRegions: Dictionary<String, Date> = [:]
    private var yourloc_marker = GMSMarker()
    
    @IBOutlet weak var shoploc_btn: UIButton!
    @IBOutlet weak var refresh_btn: UIButton!
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    var MapLocCounter = 0
    var SwiftTimer = Timer()
    
    let REFRESH_LOC_PERIOD:Int = 60
    
    private var isAddStartLoc : Bool = false
    
    //var seenError : Bool = false
    var locationFixAchieved : Bool = false
    //var locationStatus : NSString = "Not Started"
    
    // 1.創建 locationManager
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        SwiftTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ShopOneMapVC.updateCounter), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
        //print("SHOP NAME: \(oneshop?.getShop_name() ?? "")")
        initViewObj()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
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
        //drawRoute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewMap.clear()
        //self.viewMap.stopRendering()
        self.viewMap.removeFromSuperview()
        self.viewMap = nil
        //print("viewDidDisappear")
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
    
    //get location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        
        //refresh location every 30 sec
        
        if (locationFixAchieved == false && viewMap != nil) {
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
            
            //route
            let url = getDirectionsUrl(origin_lat: coord.latitude, origin_lng: coord.longitude,dest_lat: oneshop.getShop_lat(), dest_lng: oneshop.getShop_lng())
            
            //print(" URL: \(url)")
            drawShopRoute(_url: url)
            
        }
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
                    //print("JSON: \(JSON)")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func initViewObj()
    {
        let logo = UIImage(named: "ic_title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.title=""
        
        //set button
        shoploc_btn.backgroundColor = .clear
        shoploc_btn.layer.cornerRadius = 5
        shoploc_btn.layer.borderWidth = 1
        shoploc_btn.layer.borderColor = UIColor.blue.cgColor
        
        refresh_btn.backgroundColor = .clear
        refresh_btn.layer.cornerRadius = 5
        refresh_btn.layer.borderWidth = 1
        refresh_btn.layer.borderColor = UIColor.blue.cgColor
        
        //set camera as taiwan center
        let camera = GMSCameraPosition.camera(withLatitude: oneshop.getShop_lat(),
                                              longitude: oneshop.getShop_lng(),
                                              zoom: DEFAULT_ZOOM_LEVEL)
        self.viewMap.camera = camera
        self.viewMap.isMyLocationEnabled = true
        self.viewMap.settings.myLocationButton = true
        self.viewMap.settings.compassButton = true
        
        //add marker
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "supermarket")!.withRenderingMode(.automatic)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        var marker: GMSMarker;
        
        //add marker
        //NSLog("%s, line:%d LNG: %f, LAT: %f", #function, #line, myshop[i].getShop_lng(), myshop[i].getShop_lat())
        
        marker = GMSMarker()
        marker.position =
            CLLocationCoordinate2DMake(oneshop.getShop_lat(), oneshop.getShop_lng())
        marker.title = oneshop.getShop_name()
        var str = oneshop.getShop_addr().appending("\n")
        str = str.appending(oneshop.getShop_phone())
        marker.snippet = str
        //marker.icon = GMSMarker.markerImage(with: UIColor.green)
        marker.isFlat = true
        marker.iconView = markerView
        
        marker.map = viewMap
        viewMap.selectedMarker = marker
        
        shoploc_btn.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        refresh_btn.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        
        let your_markerImage = UIImage(named: "your_loc")!.withRenderingMode(.automatic)
        
        //creating a marker view
        let your_markerView = UIImageView(image: your_markerImage)
        yourloc_marker.iconView = your_markerView
        
    }
    
    func buttonClicked(_ sender: AnyObject?) {
        if sender === shoploc_btn {
            // do something
            //set camera as taiwan center
            let camera = GMSCameraPosition.camera(withLatitude: oneshop.getShop_lat(),
                                                  longitude: oneshop.getShop_lng(),
                                                  zoom: DEFAULT_ZOOM_LEVEL)
            self.viewMap.camera = camera
            
        } else if sender === refresh_btn {
            // do something
            self.resetShopLoc()
        }
    }
    
    func resetShopLoc()
    {
        //print("RESET SHOP LOC")
        viewMap.clear()
        let DEFAULT_ZOOM_LEVEL:Float = 15.0;
        
        //set camera as taiwan center
        let camera = GMSCameraPosition.camera(withLatitude: oneshop.getShop_lat(),
                                              longitude: oneshop.getShop_lng(),
                                              zoom: DEFAULT_ZOOM_LEVEL)
        self.viewMap.camera = camera
        self.viewMap.isMyLocationEnabled = true
        self.viewMap.settings.myLocationButton = true
        self.viewMap.settings.compassButton = true
        self.viewMap.settings.myLocationButton = true
        
        //add marker
        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "supermarket")!.withRenderingMode(.automatic)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        var marker: GMSMarker;
        
        //add marker
        //NSLog("%s, line:%d LNG: %f, LAT: %f", #function, #line, myshop[i].getShop_lng(), myshop[i].getShop_lat())
        
        marker = GMSMarker()
        marker.position =
            CLLocationCoordinate2DMake(oneshop.getShop_lat(), oneshop.getShop_lng())
        marker.title = oneshop.getShop_name()
        var str = oneshop.getShop_addr().appending("\n")
        str = str.appending(oneshop.getShop_phone())
        marker.snippet = str
        //marker.icon = GMSMarker.markerImage(with: UIColor.green)
        marker.isFlat = true
        marker.iconView = markerView
        marker.map = viewMap
        viewMap.selectedMarker = marker
        
        //route
        /*
         let url = getDirectionsUrl(origin_lat: coord.latitude, origin_lng: coord.longitude,dest_lat: oneshop.getShop_lat(), dest_lng: oneshop.getShop_lng())
         
         //print(" URL: \(url)")
         drawShopRoute(_url: url)
         */
        
        locationFixAchieved = false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
