//
//  ShopListContainerVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/17.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class ShopListContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet private weak var shoptable: UITableView!
    
    var myshop: [ShopLoc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        /*
         self.btn_shop.addTarget(self, action: #selector(ShopVC.buttonClicked(_:)), for: .touchUpInside)
         self.btn_shopmap.addTarget(self, action: #selector(ShopVC.buttonClicked(_:)), for: .touchUpInside)
         */
    }
    
    
    
    func loadInfo()
    {
        self.view.makeToastActivity(.center)
        let url = URL(string: "https://www.norbelbaby.com.tw/tintinapp/w/store/json/grid")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["foo": "bar"]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
            self.view.hideToastActivity()
            NSLog("%s, line:%d - Error: JSON ERROR", #function, #line)
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
                        NSLog("%s, line:%d - success", #function, #line)
                        //print("example success")
                    default:
                        self.view.hideToastActivity()
                        self.view.makeToast("取得分店資訊失敗: 錯誤代碼: \(status)",duration: 3.0, position: .bottom)
                        NSLog("%s, line:%d - error code %d", #function, #line, status)
                        //print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    _ = result as! NSDictionary
                    //print(json_str)
                    guard data is JSON
                        else{
                            NSLog("%s, line:%d - error: data is not JSON", #function, #line)
                            fatalError()
                        }
                    let shop = self.parseJSON(data: data as! JSON)
                    
                    //for i in 0 ..< Int(shop.count){
                    //    print("SHOP NAME: \(i) : \(shop[i].shop_name )")
                    //}
                    
                    self.myshop = shop
                    self.regShopTable()
                    self.view.hideToastActivity()
                }
                else
                {
                    self.view.hideToastActivity()
                    self.view.makeToast("請啟用網路連線取得分店資訊",duration: 3.0, position: .bottom)
                    NSLog("%s, line:%d - Error: No Response Data", #function, #line)
                }
                break
                
            case .failure(let error):
                self.view.hideToastActivity()
                self.view.makeToast("請啟用網路連線取得分店資訊",duration: 3.0, position: .bottom)
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
        self.shoptable.delegate = self
        self.shoptable.dataSource = self
        
        // 分隔線的樣式
        self.shoptable.separatorStyle = .singleLine
        
        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
        //shoptable.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        
        // 是否可以點選 cell
        self.shoptable.allowsSelection = true
        
        // 是否可以多選 cell
        self.shoptable.allowsMultipleSelection = false
        
        //reload tableview
        DispatchQueue.main.async(execute: { () -> Void in
            //reload your tableView
            self.shoptable.reloadData()
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //delegate methods
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowsInSection")
        return self.myshop.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath")
        let cellIdentifier = "shop_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! ShopTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        //    as! ShopTableViewCell
        
        
        // Configure the cell...
        
        //print("INDEXPATH: \(indexPath)")
        //print("SHOP: \(self.myshop[indexPath.row].getShop_name())")
        
        //cell.textLabel?.text = self.myshop[indexPath.row].getShop_name()
        
        cell.setNameLabel(shopname: self.myshop[indexPath.row].getShop_name())
        var str = "地址:"
        str = str.appending(self.myshop[indexPath.row].getShop_addr())
        cell.setAddrLabel(addr: str)
        str = "電話:"
        str = str.appending(self.myshop[indexPath.row].getShop_phone())
        cell.setTelLabel(tel: str)
        str = "營業時間:"
        str = str.appending(self.myshop[indexPath.row].getShop_onBus().appending("~"))
        str = str.appending(self.myshop[indexPath.row].getShop_offBus())
        cell.setOpenLabel(openhr: str)
        cell.setShowImage(ispark: self.myshop[indexPath.row].getShop_fpark()
            , isppark: self.myshop[indexPath.row].getShop_ppark()
            , isnhi: self.myshop[indexPath.row].getIsHiShop()
            , ismetro: self.myshop[indexPath.row].getIsMetro())
        
        //cell.nameLabel.text = restaurantNames[indexPath.row]
        //cell.thumbnailImageView.image = UIImage(named: restaurantImages[indexPath.row])
        //cell.locationLabel.text = restaurantLocations[indexPath.row]
        //cell.typeLabel.text = restaurantTypes[indexPath.row]
        
        //print("add cell: \(self.myshop[indexPath.row].getShop_name())")
        return cell
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let name = info[indexPath.section][indexPath.row]
        let name = self.myshop[indexPath.row].getShop_name()
        print("選擇的是 \(name)")
    }
    
    // 點選 Accessory 按鈕後執行的動作
    // 必須設置 cell 的 accessoryType
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let name = self.myshop[indexPath.row].getShop_name()
        print("按下的是 \(name) 的 detail")
    }
    
    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("NUMBER OF SECTION: \(self.myshop.count)")
        //return self.myshop.count
        return 1
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //let title = section == 0 ? "籃球" : "棒球"
        return title
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let diag = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{260E}\n 撥號") { action, index in
            //self.isEditing = false
            
            //set dial phone (使用實機測試)
            self.callNumber(phoneNumber: self.myshop[indexPath.row].getShop_phone())
        }
        //more.backgroundColor = UIColor(patternImage: UIImage(named: "nhi")!)
        diag.backgroundColor = UIColor(rgb: 0x3b8cf7)
        //more.image = UIImage(named: "nhi")
        
        let shop = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "\u{1F3EA}\n 分店位置") { action, index in
            //self.isEditing = false
            //set show map
        //self.openViewControllerBasedOnIdentifierWithParameter("ShopOneVC"
        //    ,self.myshop[indexPath.row])
            self.performSegue(withIdentifier: "ShopOneMapVC", sender: self.myshop[indexPath.row])
        }
        shop.backgroundColor = UIColor(rgb: 0x0a70f5)
        
        /*
        let share = TableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share") { action, index in
            //self.isEditing = false
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blue
        share.image = UIImage(named: "metro")
        */
        
        return [diag, shop]
        //return [share, favorite, more]
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func openViewControllerBasedOnIdentifierWithParameter
        (_ strIdentifier:String, _ sender:Any){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            NSLog("%s, line:%d - Same VC", #function, #line)
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShopOneMapVC" {
            
            if let shopOneMapVC = segue.destination as? ShopOneMapVC {
                shopOneMapVC.oneshop = sender as? ShopLoc
            }
        }
    }

}


class TableViewRowAction: UITableViewRowAction
{
    var image: UIImage?
    
    func _setButton(button: UIButton)
    {
        if let image = image, let titleLabel = button.titleLabel
        {
            let labelString = NSString(string: titleLabel.text!)
            let titleSize = labelString.size(attributes: [NSFontAttributeName: titleLabel.font])
            
            button.tintColor = UIColor.white
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageEdgeInsets.right = -titleSize.width
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}
