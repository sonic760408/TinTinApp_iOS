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
import AlamofireImage

class DMVC: BaseViewController {

    @IBOutlet weak var dm_img: UIImageView!
    
    
    let DM_URL:String = "https://www.norbelbaby.com.tw/TinTinAppServlet/dm/json/todayDM";

    let DM_UNSCRIBE_URL:String = "https://www.norbelbaby.com.tw/TinTinAppServlet/dm/json/cancelDM";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        // Do any additional setup after loading the view.
        self.initViewObj()
        self.downloadImg()
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
    
    
    func downloadImg()
    {
        Alamofire.request("https://www.norbelbaby.com.tw/Template/menu/dm/201705/05-001.jpg").responseImage { response in
            //debugPrint(response)
            
            //print(response.request)
            //print(response.response)
            //debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.dm_img.image = image
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
