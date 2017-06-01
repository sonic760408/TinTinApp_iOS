//
//  SalesVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/6/1.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class SalesVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var sales_collectview: UICollectionView!
    
    var mysalesitems: [SalesItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViewObj()
        loadinfo()
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
        
    }
    
    func loadinfo()
    {
        self.view.makeToastActivity(.center)
        let url = URL(string: "https://www.norbelbaby.com.tw/TinTinAppServlet/ecmitem/json/allitems")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "request": "searchSalesCatalog",
            "type": "0",
            "name": ""
        ]
        
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
                        self.view.makeToast("取得特價品資訊失敗: 錯誤代碼: \(status)",duration: 3.0, position: .bottom)
                        NSLog("%s, line:%d - error code %d", #function, #line, status)
                        //print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    let json_str = result as! NSDictionary
                    //print(json_str)
                    guard data is JSON
                        else{
                            NSLog("%s, line:%d - error: data is not JSON", #function, #line)
                            fatalError()
                    }
                    let salesitems = self.parseJSON(data: data as! JSON)
                    self.mysalesitems = salesitems
                    /*
                    for i in 0 ..< Int(salesitem.count){
                        print("SALES NAME[\(i)] : \(salesitem[i].getName())")
                    }
                    */
                    
                    //set views
                    self.regSalesCollection()
                    self.view.hideToastActivity()
                }
                else
                {
                    self.view.hideToastActivity()
                    self.view.makeToast("請啟用網路連線取得特價品資訊",duration: 3.0, position: .bottom)
                    NSLog("%s, line:%d - Error: No Response Data", #function, #line)
                }
                break
                
            case .failure(let error):
                self.view.hideToastActivity()
                self.view.makeToast("請啟用網路連線取得特價品資訊",duration: 3.0, position: .bottom)
                NSLog("%s, line:%d - Error: \(error)", #function, #line)
                break
            }
        }
    }
    
    func regSalesCollection()
    {
        // 註冊 cell 的樣式及名稱
        //self.shoptable.register(ShopTableViewCell.self, forCellReuseIdentifier: "shop_cell")
        
        // 設置委任對象
        self.sales_collectview.delegate = self
        self.sales_collectview.dataSource = self
        
        // 是否可以點選 cell
        self.sales_collectview.allowsSelection = true
        
        // 是否可以多選 cell
        self.sales_collectview.allowsMultipleSelection = false
        
        //reload tableview
        DispatchQueue.main.async(execute: { () -> Void in
            //reload your tableView
            self.sales_collectview.reloadData()
        })
    }
    
    // MARK: -
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mysalesitems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalesItemViewCell", for: indexPath) as! SalesItemViewCell
        
        cell.downloadImg(url: mysalesitems[indexPath.row].getBigiconUrl())
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GalleryItemCommentView", for: indexPath) as! GalleryItemCommentView
        
        commentView.commentLabel.text = "Supplementary view of kind \(kind)"
        
        return commentView
    }
    */
    
    // MARK: -
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func parseJSON(data: Any) -> [SalesItem]
    {
        //print(_dict)
        
        //parse the data
        //var array = [ShopLoc]() //alternatively (does the same): var array = Array<Country>()
        
        guard let value = data as? JSON,
            let arrayJSON = value["rows"] as? [JSON]
            else { fatalError() }
        let salesitems = [SalesItem].from(jsonArray: arrayJSON)//the JSON deserialization is done here, after this line you can do anything with your JSON
        //for i in 0 ..< Int((shoplocs?.count)!) {
        //    print("SHOP: \(i) : \(shoplocs?[i].shop_no ?? "")")
        
        //set to the object
        
        //}
        
        return salesitems!
        //array.append(ShopLoc())
    }

}
