//
//  PlayVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/10.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit

class ShopVC: BaseViewController{
    
    @IBOutlet private weak var btn_shop: UIButton!
    @IBOutlet private weak var btn_shopmap: UIButton!
    
    var container: ContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        //addSlideMenuButton()
        // Do any additional setup after loading the view.
        
        self.initViewObj()
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
        //setButton()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shopmap(sender: AnyObject) {

        btn_shop.setImage(UIImage(named: "ic_shop_lists"), for: .normal)
        btn_shopmap.setImage(UIImage(named: "ic_all_shop_selected"), for: .normal)
        container!.segueIdentifierReceivedFromParent("second", nil)
    }
    
    @IBAction func shoplist(sender: AnyObject) {

        btn_shop.setImage(UIImage(named: "ic_shop_lists_selected"), for: .normal)
        btn_shopmap.setImage(UIImage(named: "ic_all_shop"), for: .normal)
        container!.segueIdentifierReceivedFromParent("first", nil)
    }
   
    func initViewObj()
    {
        let logo = UIImage(named: "ic_title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.title=""
        
        //btn_shop  = UIButton(type: .custom)
        //btn_shop.setImage(UIImage(named: "ic_shop_lists_selected"), for: .normal)
        //btn_shopmap = UIButton(type: .custom)
        //btn_shopmap.setImage(UIImage(named: "ic_all_shop"), for: .normal)
        
        /*
        self.btn_shop.addTarget(self, action: #selector(ShopVC.buttonClicked(_:)), for: .touchUpInside)
        self.btn_shopmap.addTarget(self, action: #selector(ShopVC.buttonClicked(_:)), for: .touchUpInside)
        */
    }
    
    func buttonClicked(_ sender: AnyObject?) {
        if sender === btn_shop {
            // do something
            self.openViewControllerBasedOnIdentifier("ShopVC")
        } else if sender === btn_shopmap {
            // do something
            self.openViewControllerBasedOnIdentifier("ShopMapVC")
        }
    }
    
    private func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            NSLog("%s, line:%d - Same VC", #function, #line)
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "container"{
            container = (segue.destination as! ContainerViewController)
        }
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


