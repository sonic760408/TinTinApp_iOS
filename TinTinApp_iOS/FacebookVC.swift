//
//  TestVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/10.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit
import WebKit

class FacebookVC: BaseViewController{
    
    @IBOutlet weak var webView: UIWebView!
    
    let FACEBOOK_URL: String = "https://www.facebook.com/norbelbaby.tintin"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newBackButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(FacebookVC.back(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
        //self.navigationItem.hidesBackButton = false
        //addSlideMenuButton()'
        
        initViewObj()
        initweb(_url: FACEBOOK_URL)
        // Do any additional setup after loading the view.
    }
    
    /*
    override func willMove(toParentViewController parent: UIViewController?)
    {
        if parent == nil
        {
            print("BACK PRESSED")
            if(webView.canGoBack)
            {
                print("WEBVIEW BACK")
                //self.navigationItem.hidesBackButton = true
                webView.goBack()
            }
            else
            {
                print("WEBVIEW NOBACK")
                //self.navigationItem.hidesBackButton = false
                // Perform your custom actions
                // ...
                // Go back to the previous ViewController
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    */

    func back(sender: UIBarButtonItem) {
        
        if(webView.canGoBack)
        {
            //self.navigationItem.hidesBackButton = true
            webView.goBack()
        }
        else
        {
            //self.navigationItem.hidesBackButton = false
            // Perform your custom actions
            // ...
            // Go back to the previous ViewController
            _ = navigationController?.popViewController(animated: true)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initweb(_url :String){
        let requestURL = URL(string: _url)
        let request = URLRequest(url: requestURL!)
        webView.loadRequest(request)
    }
    
    func initViewObj()
    {
        let logo = UIImage(named: "ic_title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.title=""
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
