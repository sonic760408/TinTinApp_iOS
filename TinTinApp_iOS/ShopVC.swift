//
//  PlayVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/10.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class ShopVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //addSlideMenuButton()
        // Do any additional setup after loading the view.
        initViewObj()
        loadInfo()
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
    }
    
    func loadInfo()
    {
        /*
        let parameters: Parameters = ["foo": "bar"]
        Alamofire.request("https://www.norbelbaby.com.tw/tintinapp/w/store/json/grid", parameters: parameters, encoding: URLEncoding.default).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
        */
        
        
        let url = URL(string: "https://www.norbelbaby.com.tw/tintinapp/w/store/json/grid")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["foo": "bar"]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
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
                    
                    for i in 0 ..< Int(shop.count){
                        print("SHOP NAME: \(i) : \(shop[i].shop_name )")
                    }
                    
                    //use data to refresh UI info
                    
                }
                
                break
                
            case .failure(let error):
                print("Error: \(error)")
                break
            }
        }
    }

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
    
    func refreshList()
    {
        
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let backItem = UIBarButtonItem()
     backItem.title = " "
     navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
     
     }
     */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
