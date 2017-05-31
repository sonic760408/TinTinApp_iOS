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
import SDWebImage

class EventVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventtable: UITableView!

    var events : [Event] = []
    let cellSpacingHeight: CGFloat = 5
    
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
                        self.view.makeToast("取得活動資訊失敗: 錯誤代碼: \(status)",duration: 3.0, position: .bottom)
                        NSLog("%s, line:%d - error code %d", #function, #line, status)
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    //_ = result as! NSDictionary
                    //print(result)
                    
                    guard result is JSON
                        else{fatalError()}
                    
                    self.events = self.parseJSON(data: data as! JSON)
                    
                    //sort
                    self.events = self.events.sorted(by: { $0.order < $1.order })
                    
                    /*
                    for i in 0 ..< Int(self.events.count){
                        print("EVENT NAME: \(i) : \(self.events[i].getName() )")
                    }
                    */
                    
                    //picture
                    
                    //register 
                    self.regShopTable()
                }
                
                break
                
            case .failure(let error):
                self.view.makeToast("請啟用網路連線取得活動資訊",duration: 3.0, position: .bottom)
                NSLog("%s, line:%d - Error: \(error)", #function, #line)
                break
            }
        }
    }
    
    func regShopTable()
    {
        // 註冊 cell 的樣式及名稱
        //self.shoptable.register(ShopTableViewCell.self, forCellReuseIdentifier: "shop_cell")
        
        // 設置委任對象
        self.eventtable.delegate = self
        self.eventtable.dataSource = self
        
        // 分隔線的樣式
        self.eventtable.separatorStyle = .singleLine
        
        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
        //shoptable.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        
        // 是否可以點選 cell
        self.eventtable.allowsSelection = true
        
        // 是否可以多選 cell
        self.eventtable.allowsMultipleSelection = false
        
        //reload tableview
        DispatchQueue.main.async(execute: { () -> Void in
            //reload your tableView
            self.eventtable.reloadData()
        })
        
    }
    
    //delegate methods
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowsInSection")
        return self.events.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath")
        let cellIdentifier = "event_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! EventTableViewCell
        
        
        //download pic
        //print("URL: \(self.events[indexPath.row].getIconurl())")
        
        /*
        Alamofire.request(self.events[indexPath.row].getIconurl()).responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                //print("image downloaded: \(image)")
                cell.setBannerImg(image: image)
            }
            else{
                cell.setBannerImg(image: UIImage(named: "no_image")!)
            }
        }
        */
        
        //set http as https
        var url = self.events[indexPath.row].getIconurl()
        
        
        if(url.lowercased().range(of:"http://") != nil) {
            url = url.replacingOccurrences(of: "http://", with: "https://", options: .literal, range: nil)
        }
        
        
        cell.downloadImg(url: url)
        
        //cell.downloadImg(url: self.events[indexPath.row].getIconurl())
        cell.setEventLabel(event_name: self.events[indexPath.row].getName())
        
        var dateString = self.events[indexPath.row].getRundate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "zh_TW")
        
        var dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "MM-dd"
        
        var str = "活動期間: ".appending(dateFormatter.string(from: dateObj!))
        str = str.appending("~")
        
        dateString = self.events[indexPath.row].getDeadline()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM-dd"
        str = str.appending(dateFormatter.string(from: dateObj!))
        
        // add border and color
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        cell.setEventTimeLabel(event_time: str)
        
        return cell
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let name = info[indexPath.section][indexPath.row]
        let name = self.events[indexPath.row].getName()
        //print("按下的URL: \(self.events[indexPath.row].getIconurl())")
        
        //switch to webVC
        let url = self.events[indexPath.row].getActionurl()
        
        self.performSegue(withIdentifier: "WebVC", sender: url)
        
        //print("選擇的是 \(name)")
    }
    
    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("NUMBER OF SECTION: \(self.myshop.count)")
        //return self.myshop.count
        return 1
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return title
    }
    
    func parseJSON(data: Any) -> [Event]
    {
        //print(_dict)
        
        //parse the data
        //var array = [ShopLoc]() //alternatively (does the same): var array = Array<Country>()
        
        guard let value = data as? JSON,
            let eventsArrayJSON = value["rows"] as? [JSON]
            else { fatalError() }
        let events = [Event].from(jsonArray: eventsArrayJSON)//the JSON deserialization is done here, after this line you can do anything with your JSON
        //for i in 0 ..< Int((shoplocs?.count)!) {
        //    print("SHOP: \(i) : \(shoplocs?[i].shop_no ?? "")")
        
        //set to the object
        
        //}
        
        return events!
        //array.append(ShopLoc())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "WebVC" {
            
            if let webVC = segue.destination as? WebVC {
                webVC.weburl = (sender as? String)!
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
