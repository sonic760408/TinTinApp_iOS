//
//  EventVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/22.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class EventVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //addSlideMenuButton()
        
        // Do any additional setup after loading the view.
        self.initViewObj()
        self.loadInfo()
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
        
        /*
         self.btn_shop.addTarget(self, action: #selector(ShopVC.buttonClicked(_:)), for: .touchUpInside)
         self.btn_shopmap.addTarget(self, action: #selector(ShopVC.buttonClicked(_:)), for: .touchUpInside)
         */
    }
    
    func loadInfo()
    {
        let url = URL(string: "https://www.norbelbaby.com.tw/TinTinAppServlet/action/json/todayAction")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["foo": "bar"]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
            NSLog("%s, line:%d - Error: JSON ERROR", #function, #line)
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
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        NSLog("%s, line:%d - success", #function, #line)
                    default:
                        self.view.makeToast("取得分店資訊失敗: 錯誤代碼: \(status)",duration: 3.0, position: .bottom)
                        NSLog("%s, line:%d - error code %d", #function, #line, status)
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    //_ = result as! NSDictionary
                    //print(result)
                    
                    guard result is JSON
                        else{fatalError()}
                    
                    //let shop = self.parseJSON(data: data as! JSON)
                    
                    //for i in 0 ..< Int(shop.count){
                    //    print("SHOP NAME: \(i) : \(shop[i].shop_name )")
                    //}
                    
                }
                
                break
                
            case .failure(let error):
                self.view.makeToast("請啟用網路連線取得分店資訊",duration: 3.0, position: .bottom)
                NSLog("%s, line:%d - Error: \(error)", #function, #line)
                break
            }
        }
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
