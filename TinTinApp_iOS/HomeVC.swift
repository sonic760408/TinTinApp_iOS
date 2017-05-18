//
//  HomeVC.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/10.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController, UIScrollViewDelegate {
    @IBOutlet weak var galleryScrollView: UIScrollView!
    @IBOutlet weak var galleryPageControl: UIPageControl!
    
    @IBOutlet weak var btn_shop: UIButton!
    @IBOutlet weak var btn_fb: UIButton!
    @IBOutlet weak var btn_event: UIButton!
    
    @IBOutlet weak var btn_dm: UIButton!
    @IBOutlet weak var btn_sales: UIButton!
    @IBOutlet weak var btn_ticket: UIButton!
    
    
    var timer:Timer!
    
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
        
        let scrollViewWidth:CGFloat = scrollViewSize.width
        let scrollViewHeight:CGFloat = scrollViewSize.height
        
        //2
        //print("WIDTH: \(scrollViewWidth) ,HEIGHT: \(scrollViewHeight)")
        //3
        let imgOne = UIImageView(frame: CGRect(x:0, y:-64,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "ic_test_0.png")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:-64,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "ic_test_1.png")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:-64,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "ic_test_2.png")

        
        self.galleryScrollView.addSubview(imgOne)
        self.galleryScrollView.addSubview(imgTwo)
        self.galleryScrollView.addSubview(imgThree)

        //4
        self.galleryScrollView.contentSize =
            CGSize(width:self.galleryScrollView.frame.width * 3, height:self.galleryScrollView.frame.height)
        self.galleryScrollView.delegate = self
        self.galleryPageControl.currentPage = 0
        
        //self.galleryScrollView.isScrollEnabled = false
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
    }
    
    func moveToNextPage (){
        
        let pageWidth:CGFloat = self.galleryScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 3
        let contentOffset:CGFloat = self.galleryScrollView.contentOffset.x
        let height:CGFloat = self.galleryScrollView.frame.height - 64
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        self.galleryScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:height), animated: true)
    }
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.galleryPageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
        }else if Int(currentPage) == 1{
            //textView.text = "I write mobile tutorials mainly targeting iOS"
        }else if Int(currentPage) == 2{
            //textView.text = "And sometimes I write games tutorials about Unity"
        }else{
            //textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            //UIView.animate(withDuration: 1.0, animations: { () -> Void in
            //    self.startButton.alpha = 1.0
            //})
        }
    }
    
    func buttonClicked(_ sender: AnyObject?) {
        if sender === btn_shop {
            // do something
            print("SHOP\n")
            
            self.openViewControllerBasedOnIdentifier("ShopVC")
            
        } else if sender === btn_fb {
            // do something
            print("FB\n")
            self.openViewControllerBasedOnIdentifier("FacebookVC")
        } else if sender === btn_event {
            // do something
            print("EVENT\n")
        }else if sender === btn_dm{
            print("DM\n")
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

        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
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
