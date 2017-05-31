//
//  HomeVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/10.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import ImageSlideshow

class HomeVC: BaseViewController {
    //@IBOutlet weak var galleryScrollView: UIScrollView!
    //@IBOutlet weak var galleryPageControl: UIPageControl!
    
    @IBOutlet weak var galleryScrollView: ImageSlideshow!
    
    
    @IBOutlet weak var btn_shop: UIButton!
    @IBOutlet weak var btn_fb: UIButton!
    @IBOutlet weak var btn_event: UIButton!
    
    @IBOutlet weak var btn_dm: UIButton!
    @IBOutlet weak var btn_sales: UIButton!
    @IBOutlet weak var btn_ticket: UIButton!
    
    var timer:Timer!
    //var bannerImages:[UIImage?] = []
    var scrollViewWidth:CGFloat = 0.0
    var scrollViewHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set current layout is void
        self.view.setNeedsLayout()
        
        //force layout to refresh scrollview width
        self.view.layoutIfNeeded()
        
        self.initViewObj()
        addSlideMenuButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

    }
    
    func initViewObj()
    {
        let logo = UIImage(named: "ic_title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        //galleryScrollView.translatesAutoresizingMaskIntoConstraints = true
        //galleryScrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth;UIViewAutoresizing.flexibleHeight
        
        btn_shop.setImage(UIImage(named: "ic_m_shop.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        btn_fb.setImage(UIImage(named: "ic_m_fb.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        btn_event.setImage(UIImage(named: "ic_m_event.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        btn_dm.setImage(UIImage(named: "ic_m_dm.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        btn_sales.setImage(UIImage(named: "ic_m_sales.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        btn_ticket.setImage(UIImage(named: "ic_m_ecoupon.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        
        btn_shop.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn_fb.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn_event.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn_dm.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn_sales.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn_ticket.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        btn_shop.addTarget(self, action: #selector(HomeVC.buttonClicked(_:)), for: .touchUpInside)
        btn_fb.addTarget(self, action: #selector(HomeVC.buttonClicked(_:)), for: .touchUpInside)
        btn_event.addTarget(self, action: #selector(HomeVC.buttonClicked(_:)), for: .touchUpInside)
        btn_dm.addTarget(self, action: #selector(HomeVC.buttonClicked(_:)), for: .touchUpInside)
        btn_sales.addTarget(self, action: #selector(HomeVC.buttonClicked(_:)), for: .touchUpInside)
        btn_ticket.addTarget(self, action: #selector(HomeVC.buttonClicked(_:)), for: .touchUpInside)
        
        //scrollview banner
        //1
        self.galleryScrollView.frame = CGRect(x:0, y:0, width:self.galleryScrollView.frame.width, height:self.galleryScrollView.frame.height)

        let scrollViewSize:CGSize = self.galleryScrollView.frame.size
        //let scrollViewWidth:CGFloat = self.galleryScrollView.frame.width
        //let scrollViewHeight:CGFloat = self.galleryScrollView.frame.height-64
        
        self.scrollViewWidth = scrollViewSize.width
        self.scrollViewHeight = scrollViewSize.height
        
        //download banner image
        downloadBannerImageURL()

    }
    
    private func downloadBannerImageURL()
    {
        let RANDOMPIC_URL:String  = "https://www.norbelbaby.com.tw/TinTinAppServlet/randompic/json/todayPic";
        
        let url = URL(string: RANDOMPIC_URL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["",""]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
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
                    
                    //print("HOME JSON: \(JSON)") // class NSDictionary

                    let jsonarray = JSON as? [String:AnyObject] //NSDictionary to array
                    
                    do{
                        let piclurl = jsonarray!["piclurl"] as! String
                        let indexfrom = jsonarray!["picfrom"] as! Int
                        let picto = jsonarray!["picto"] as! Int
                        
                        let img_urls = self.genPicUrl(url: piclurl, startindex: indexfrom , endindex: picto)
                        
                        
                        //download picture
                        self.downloadBannerImg(urls: img_urls)
                        
                        /*
                        for (index, element) in self.bannerImages.enumerated() {
                            if(element == nil)
                            {
                                print("Item \(index): nil")
                            }
                            else{
                                print("Item \(index): \(element)")
                            }
                        }
                        */
                        
                    }catch let error as NSError {
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
                
                break
            case .failure(let error):
                self.view.makeToast("請啟用網路連線下載圖片",duration: 3.0, position: .bottom)
                NSLog("%s, line:%d - Error: \(error)", #function, #line)
                break
            }
        }
    }
    
    private func downloadBannerImg(urls: [String])
    {
        //var countNum:Int = 0
        
        var src = [SDWebImageSource]()
        
        for index in 0...urls.count-1 {
            src.append(SDWebImageSource(urlString: urls[index])!)
        }
        
        self.galleryScrollView.setImageInputs(src)
        self.galleryScrollView.contentScaleMode = .scaleToFill
        self.galleryScrollView.slideshowInterval = 5
        self.galleryScrollView.zoomEnabled = false
        self.galleryScrollView.pageControlPosition = .insideScrollView
        self.galleryScrollView.activityIndicator = DefaultActivityIndicator()
        self.galleryScrollView.preload = ImagePreload.fixed(offset: 3)
        
    }
    
    private func genPicUrl(url: String, startindex: Int, endindex: Int) -> [String]
    {
        let pattern:String = "%02d";  //regular expression
        var img_urls:[String] = []
        var tmp_str:String
        
        for index in startindex...endindex {
            tmp_str = url.replacingOccurrences(of: pattern, with: String(format: "%02d", index), options: .regularExpression, range: nil)
            img_urls.append(tmp_str)
        }
        
        return img_urls
    }
    
    func buttonClicked(_ sender: AnyObject?) {
        if sender === btn_shop {
            // do something
            print("SHOP\n")
            
            self.openViewControllerBasedOnIdentifier("ShopVC")
            
        } else if sender === btn_fb {
            // do something
            print("FB\n")
            self.openViewControllerBasedOnIdentifier("WebVC")
        } else if sender === btn_event {
            // do something
            print("EVENT\n")
            self.openViewControllerBasedOnIdentifier("EventVC")
        }else if sender === btn_dm{
            print("DM\n")
            self.openViewControllerBasedOnIdentifier("DMVC")
        }else if sender === btn_sales{
            print("SALES\n")
        }else if sender === btn_ticket{
            print("TICKET\n")
        }
    }
    
    private func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            NSLog("%s, line:%d - same VC", #function, #line)
        } else {
            
            if(strIdentifier == "WebVC")
            {
                guard let detailVC = destViewController as? WebVC else {
                    // uh oh, casting failed. maybe do some error handling.
                    NSLog("%s, line:%d - Error: detailVC is not WebVC", #function, #line)
                    return
                }
                
                detailVC.weburl = "https://www.facebook.com/norbelbaby.tintin"
                self.navigationController!.pushViewController(detailVC, animated: true)
            }
            else{
                self.navigationController!.pushViewController(destViewController, animated: true)
            }
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FacebookVC{
            print(" xxxx FB xxxx ")
            let controller = segue.destination as! FacebookVC
            controller.myurl = "myurl"
        }
        else{
            print(" xxxx NO FB xxxx ")
        }
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
