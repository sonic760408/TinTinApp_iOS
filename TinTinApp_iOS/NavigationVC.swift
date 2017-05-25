//
//  NavigationVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/24.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    var navBar: UINavigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNavBarToTheView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavBarToTheView() {
        self.navBar.frame = CGRect(x: 0, y: 0, width: 320, height: 200)  // Here you can set you Width and Height for your navBar
        self.navBar.backgroundColor = (UIColor.black)
        self.view.addSubview(navBar)
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
