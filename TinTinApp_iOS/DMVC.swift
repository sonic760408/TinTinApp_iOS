//
//  DMVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/22.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import SDWebImage
//import SwiftPhotoGallery
import ImageSlideshow

class DMVC: BaseViewController {

    @IBOutlet weak var dmview: ImageSlideshow!
    
    @IBOutlet weak var index_label: UILabel!
    
    @IBOutlet weak var prev_btn: UIButton!
    @IBOutlet weak var next_btn: UIButton!
    
    let DM_UNSCRIBE_URL:String = "https://www.norbelbaby.com.tw/TinTinAppServlet/dm/json/cancelDM";
    
    var cur_page: Int = 0
    var max_page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addSlideMenuButton()
        // Do any additional setup after loading the view.
        self.initViewObj()
        
        
        self.downloadDMImageURL()
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
        dmview.removeFromSuperview()
        dmview = nil
        //print("viewDidDisappear")
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
    
    private func downloadDMImageURL()
    {
        let DM_URL:String = "https://www.norbelbaby.com.tw/TinTinAppServlet/dm/json/todayDM";
        
        let url = URL(string: DM_URL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["",""]
        
        do {
            self.view.makeToastActivity(.center)
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
            self.view.hideToastActivity()
            self.view.makeToast("無法取得JSON資訊",duration: 3.0, position: .bottom)
            NSLog("%s, line:%d - Error: Cannot get JSON INFO ", #function, #line)
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
                    
                    print("HOME JSON: \(JSON)") // class NSDictionary
                    
                    let jsonarray = JSON as? [String:AnyObject] //NSDictionary to array
                    
                    do{
                        let dmurl = jsonarray!["dmurl"] as! String
                        let indexfrom = jsonarray!["dmfrom"] as! Int
                        let indexto = jsonarray!["dmto"] as! Int
                        
                        let img_urls = self.genPicUrl(url: dmurl, startindex: indexfrom , endindex: indexto)
                        
                        let str = "1/".appending(String(img_urls.count))
                        self.index_label.text = str
                        
                        //download picture
                        self.downloadDMImg(urls: img_urls)
                        self.view.hideToastActivity()
                    }catch let error as NSError {
                        self.view.hideToastActivity()
                        self.view.makeToast("發生未預期的錯誤",duration: 3.0, position: .bottom)
                        NSLog("%s, line:%d - Error: \(error) ", #function, #line)
                        
                    }
                    
                    /* get json
                     do {
                     
                     let parsedData = try JSONSerialization.data(withJSONObject: JSON, options: JSONSerialization.WritingOptions.prettyPrinted) //class data
                     
                     let dataString = NSString(data: parsedData, encoding: String.Encoding.utf8.rawValue)! //data to dictionary
                     
                     //print(" xxx \(dataString)")
                     
                     let parsedData1 = self.convertToDictionary(text: dataString as String)
                     
                     let currentConditions = parsedData1?["piclurl"]
                     
                     print(" xxx \(currentConditions ?? "none")")
                     
                     //set picture
                     
                     
                     } catch let error as NSError {
                     print(error)
                     }
                     */
                }
                else
                {
                    self.view.hideToastActivity()
                    self.view.makeToast("無法取得DM response",duration: 3.0, position: .bottom)
                    NSLog("%s, line:%d - Error: 無法取得DM response", #function, #line)
                }
                
                break
            case .failure(let error):
                self.view.hideToastActivity()
                self.view.makeToast("請啟用網路連線下載DM圖片",duration: 3.0, position: .bottom)
                NSLog("%s, line:%d - Error: \(error)", #function, #line)
                break
            }
        }
    }
    
    private func genPicUrl(url: String, startindex: Int, endindex: Int) -> [String]
    {
        let pattern:String = "%03d";  //regular expression
        var img_urls:[String] = []
        var tmp_str:String
        
        for index in startindex...endindex {
            tmp_str = url.replacingOccurrences(of: pattern, with: String(format: "%03d", index), options: .regularExpression, range: nil)
            img_urls.append(tmp_str)
        }
        
        return img_urls
    }
    
    func downloadDMImg(urls: [String])
    {
        var src = [SDWebImageSource]()
        
        
        for index in 0...urls.count-1 {
            src.append(SDWebImageSource(urlString: urls[index])!)
        }
        
        //manual implement imageslide
        
        self.dmview.setImageInputs(src)
        self.dmview.contentScaleMode = .scaleAspectFit
        self.dmview.slideshowInterval = 0
        self.dmview.zoomEnabled = true
        self.dmview.pageControlPosition = .hidden
        self.dmview.circular = false
        self.dmview.preload = ImagePreload.fixed(offset: 1)

        self.dmview.didEndDecelerating = {
            //implement func
            //print(" CURRENT PAGE: \(self.dmview.currentPage)")
            self.index_label.text = String(self.dmview.currentPage + 1).appending("/").appending(String(urls.count))
            self.cur_page = self.dmview.currentPage
            
            if(self.cur_page == 0)
            {
                self.prev_btn.isHidden = true
                self.next_btn.isHidden = false
            }
            else if(self.cur_page == self.max_page)
            {
                self.prev_btn.isHidden = false
                self.next_btn.isHidden = true
            }else
            {
                self.prev_btn.isHidden = false
                self.next_btn.isHidden = false
            }
        }
        
        self.max_page = urls.count-1
        
        if(self.cur_page == 0)
        {
            prev_btn.isHidden = true
        }else{
            prev_btn.isHidden = false
        }
        
        if(self.max_page == 0){
            next_btn.isHidden = true
        }else
        {
            next_btn.isHidden = false
        }

        //self.dmview.activityIndicator = DefaultActivityIndicator()
    }
    
    @IBAction func prevPage(sender: UIButton) {
        if(cur_page == 0)
        {
            //print(" END OF PREVIOUS DM")
        }
        else{
            self.dmview.setCurrentPage(cur_page - 1, animated: true)
            cur_page = cur_page - 1
            self.index_label.text = String(cur_page + 1).appending("/").appending(String(max_page + 1))
            self.cur_page = self.dmview.currentPage
            
            if(cur_page == 0)
            {
                prev_btn.isHidden = true
                next_btn.isHidden = false
            }
            else{
                prev_btn.isHidden = false
                next_btn.isHidden = false
            }
        }
    }
    
    @IBAction func nextPage(sender: UIButton) {
        if(cur_page == max_page)
        {
            //print(" END OF NEXT DM")
        }
        else{
            self.dmview.setCurrentPage(cur_page + 1, animated: true)
            cur_page = cur_page + 1
            self.index_label.text = String(cur_page + 1).appending("/").appending(String(max_page + 1))
            self.cur_page = self.dmview.currentPage
            
            if(cur_page == max_page)
            {
                prev_btn.isHidden = false
                next_btn.isHidden = true
            }
            else{
                prev_btn.isHidden = false
                next_btn.isHidden = false
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
