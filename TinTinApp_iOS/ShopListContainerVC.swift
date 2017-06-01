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
//import SwipeCellKit
import BGTableViewRowActionWithImage

class ShopListContainerVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource{
    
    final let CITYLIST = ["全部", "北部", "中部", "南部", "東部", "外島", "台北", "高雄", "新北", "桃園", "台中", "台南", "基隆", "新竹", "苗栗", "彰化", "南投", "雲林", "嘉義", "屏東", "宜蘭", "花蓮", "台東", "澎湖", "金門", "馬祖"]
    
    final let NORTH_SHOP_AREA:[String] = ["台北", "新北", "基隆", "桃園", "新竹", "苗栗"]
    final let CENTER_SHOP_AREA:[String] = ["台中", "彰化", "南投"]
    final let SOUTH_SHOP_AREA:[String] = ["雲林", "嘉義", "台南", "高雄", "屏東"]
    final let EAST_SHOP_AREA:[String] = ["宜蘭", "花蓮", "台東"]
    final let ISLAND_SHOP_AREA:[String] = ["澎湖", "金門", "馬祖"]
    
    @IBOutlet private weak var city_picker: UIPickerView!
    @IBOutlet private weak var shoptable: UITableView!
    
    var myshop: [ShopLoc] = []
    var filtershop: [ShopLoc] = []
    
    var isFilter : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //createPicker()
        initViewObj()
        loadInfo()
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
        self.view.makeToastActivity(.center)
        let url = URL(string: "https://www.norbelbaby.com.tw/tintinapp/w/store/json/grid")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["": ""]
        
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
        
        //reg picker
        self.city_picker.dataSource = self
        self.city_picker.delegate = self
        self.city_picker.isHidden = false
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // picker delegate method
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return CITYLIST.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return CITYLIST[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //print(" CITY: \(CITYLIST[row])")
        self.city_picker.isHidden = false
        
        //do filter
        //let filterArray = self.myshop.filter() {nil != $0.containsString("")}
        
        self.filtershop = filterShop(pattern: CITYLIST[row])
        
        /*
        for i in 0..<self.filtershop.count{
            print(" xxx \(self.filtershop[i].getShop_name()) xxx ")
        }
        */
        
        //reload table
        if(row == 0)
        {
            isFilter = false
            
        }
        else
        {
            isFilter = true
        }
        
        //reload table
        self.shoptable.reloadData()
        if(self.filtershop.count == 0 && isFilter == true)
        {
            self.view.makeToast("此地區無分店",duration: 2.0, position: .bottom)
        }
        
    }
    
    func filterShop(pattern: String) -> [ShopLoc]
    {
        var filter : [ShopLoc] = []
        
        //北部
        if(pattern == "北部")
        {
            for j in 0..<self.NORTH_SHOP_AREA.count{
                for i in 0..<myshop.count {
                    if(myshop[i].getShop_addr().contains(self.NORTH_SHOP_AREA[j]))
                    {
                        filter.append(myshop[i])
                    }
                }
            }
        }
        else if(pattern == "中部")
        {
            for j in 0..<self.CENTER_SHOP_AREA.count{
                for i in 0..<myshop.count {
                    if(myshop[i].getShop_addr().contains(self.CENTER_SHOP_AREA[j]))
                    {
                        filter.append(myshop[i])
                    }
                }
            }
        }
        else if(pattern == "南部")
        {
            for j in 0..<self.SOUTH_SHOP_AREA.count{
                for i in 0..<myshop.count {
                    if(myshop[i].getShop_addr().contains(self.SOUTH_SHOP_AREA[j]))
                    {
                        filter.append(myshop[i])
                    }
                }
            }
        }
        else if(pattern == "東部")
        {
            for j in 0..<self.EAST_SHOP_AREA.count{
                for i in 0..<myshop.count {
                    if(myshop[i].getShop_addr().contains(self.EAST_SHOP_AREA[j]))
                    {
                        filter.append(myshop[i])
                    }
                }
            }
        }
        else if(pattern == "外島")
        {
            for j in 0..<self.ISLAND_SHOP_AREA.count{
                for i in 0..<myshop.count {
                    if(myshop[i].getShop_addr().contains(self.ISLAND_SHOP_AREA[j]))
                    {
                        filter.append(myshop[i])
                    }
                }
            }
        }
        //其他地方
        else{
            for i in 0..<myshop.count {
                if(myshop[i].getShop_addr().contains(pattern))
                {
                    filter.append(myshop[i])
                }
            }
        }
        return filter
    }
    
    // table delegate methods
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowsInSection")
        
        if(isFilter == false)
        {
            return self.myshop.count
        }
        else
        {
            return self.filtershop.count
        }

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
        
        if(isFilter == false){
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
        }
        else
        {
            cell.setNameLabel(shopname: self.filtershop[indexPath.row].getShop_name())
            var str = "地址:"
            str = str.appending(self.filtershop[indexPath.row].getShop_addr())
            cell.setAddrLabel(addr: str)
            str = "電話:"
            str = str.appending(self.filtershop[indexPath.row].getShop_phone())
            cell.setTelLabel(tel: str)
            str = "營業時間:"
            str = str.appending(self.filtershop[indexPath.row].getShop_onBus().appending("~"))
            str = str.appending(self.filtershop[indexPath.row].getShop_offBus())
            cell.setOpenLabel(openhr: str)
            cell.setShowImage(ispark: self.filtershop[indexPath.row].getShop_fpark()
                , isppark: self.filtershop[indexPath.row].getShop_ppark()
                , isnhi: self.filtershop[indexPath.row].getIsHiShop()
                , ismetro: self.filtershop[indexPath.row].getIsMetro())
        }
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
        //let name = self.myshop[indexPath.row].getShop_name()
        //print("選擇的是 \(name)")
        
        //open map
        if(self.isFilter == false){
            self.performSegue(withIdentifier: "ShopOneMapVC", sender: self.myshop[(indexPath.row)])
        }
        else
        {
            self.performSegue(withIdentifier: "ShopOneMapVC", sender: self.filtershop[(indexPath.row)])
        }
        
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
    
    private func parseJSON(data: Any) -> [ShopLoc]
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
    
    //tableview rowaction delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var image = UIImage(named: "phone-call")
        var title: String? = "  撥號  "
        var cellHeight = UInt(tableView.rowHeight)
        
        let diag = BGTableViewRowActionWithImage.rowAction(with: UITableViewRowActionStyle.default, title: title,titleColor: UIColor.white, backgroundColor: UIColor(rgb: 0x3b8cf7), image: image, forCellHeight: UInt(cellHeight), andFittedWidth: false) { (action, indexPath) in
            
            self.shoptable.isEditing = false
            //self.isEditing = true
            //set dial phone (使用實機測試)
            if(self.isFilter == false){
                self.callNumber(phoneNumber: self.myshop[(indexPath?.row)!].getShop_phone(), shop_name: self.myshop[(indexPath?.row)!].getShop_name())
            }
            else
            {
                self.callNumber(phoneNumber: self.filtershop[(indexPath?.row)!].getShop_phone(), shop_name: self.myshop[(indexPath?.row)!].getShop_name())
            }
        }
        
        image = UIImage(named: "shop")
        title = "  分店位置  "
        cellHeight = UInt(tableView.rowHeight)
        
        let shop = BGTableViewRowActionWithImage.rowAction(with: UITableViewRowActionStyle.default, title: title,titleColor: UIColor.white, backgroundColor: UIColor(rgb: 0x0965dc), image: image, forCellHeight: UInt(cellHeight),andFittedWidth: false) { (action, indexPath) in
            
            self.shoptable.isEditing = false
            if(self.isFilter == false){
                self.performSegue(withIdentifier: "ShopOneMapVC", sender: self.myshop[(indexPath?.row)!])
            }
            else
            {
                self.performSegue(withIdentifier: "ShopOneMapVC", sender: self.filtershop[(indexPath?.row)!])
            }
            //print("Selected action on indexPath=\(indexPath?.section)/\(indexPath?.row)")
        }
        
        return [diag!, shop!]
    }
    
    private func callNumber(phoneNumber:String, shop_name: String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
            
            /*
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "", message: "確定是否要撥打到\(shop_name) \n 電話: \(phoneNumber)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "撥號", style: .default, handler: { (action) in
                    application.open(phoneCallURL)
                })
                let noPressed = UIAlertAction(title: "取消", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
            */
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

extension UIImage {
    func filledImage(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        fillColor.setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(CGBlendMode.colorBurn)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return coloredImg
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
