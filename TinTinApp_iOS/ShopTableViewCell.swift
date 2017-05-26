//
//  CollectionViewCell.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/15.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit

class ShopTableViewCell: UITableViewCell{
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var addrLabel: UILabel!
    @IBOutlet private var telLabel: UILabel!
    @IBOutlet private var openLabel: UILabel!
    
    @IBOutlet private var parkImg: UIImageView!
    @IBOutlet private var pparkImg: UIImageView!
    @IBOutlet private var nhiImg: UIImageView!
    @IBOutlet private var metroImg: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        parkImg.isHidden = true
        pparkImg.isHidden = true
        nhiImg.isHidden = true
        metroImg.isHidden = true
        //print("Cell's initialised")// I see this
        //print(reuseIdentifier)// prints TimesheetCell
    }

    func setNameLabel(shopname: String?)
    {
        if(nameLabel == nil)
        {
            print("NAMELABEL IS NIL")
        }
        self.nameLabel?.text = shopname
    }
    
    func setAddrLabel(addr: String)
    {
        if(addrLabel == nil)
        {
            print("ADDRLABEL IS NIL")
        }
        self.addrLabel?.text = addr
    }
    
    func setTelLabel(tel: String)
    {
        if(telLabel == nil)
        {
            print("TELLABEL IS NIL")
        }
        self.telLabel?.text = tel
    }
    
    func setOpenLabel(openhr: String)
    {
        if(openLabel == nil)
        {
            print("OPENLABEL IS NIL")
        }
        self.openLabel?.text = openhr
    }
    
    func setShowImage(ispark: Bool, isppark: Bool, isnhi: Bool,ismetro: Bool)
    {
        parkImg.isHidden = !ispark
        pparkImg.isHidden = !isppark
        nhiImg.isHidden = !isnhi
        metroImg.isHidden = !ismetro
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.addRightViewInCell()
        //self.addRightCell()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /*
    func addRightCell(){
        //Create a view that will display when user swipe the cell in right
        let viewCall = UIView()
        viewCall.backgroundColor = UIColor.blue
        viewCall.frame = CGRect(x: 0, y: 0,width: self.frame.height+20,height: self.frame.height)
        //Add a label to display the call text
        let lblCall = UILabel()
        lblCall.text  = "AA"
        lblCall.font = UIFont.systemFont(ofSize: 15.0)
        lblCall.textColor = UIColor.yellow
        lblCall.textAlignment = NSTextAlignment.center
        lblCall.frame = CGRect(x: 0,y: self.frame.height - 20,width: viewCall.frame.size.width,height: 20)
        //Add a button to perform the action when user will tap on call and add a image to display
        /*
        let btnCall = UIButton(type: UIButtonType.custom)
        btnCall.frame = CGRect(x: (viewCall.frame.size.width - 40)/2,y: 5,width: 40,height: 40)
        btnCall.setImage(UIImage(named: "nhi"), for: UIControlState())
        btnCall.addTarget(self, action: #selector(ShopTableViewCell.callButtonClicked), for: UIControlEvents.touchUpInside)
        */
        
        var imageView  = UIImageView(frame:CGRect(x: (viewCall.frame.size.width - 40)/2,y: 5,width: 40,height: 40))
        imageView.image = UIImage(named:"metro")
        
        viewCall.addSubview(imageView)
        viewCall.addSubview(lblCall)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))
        
        viewCall.addGestureRecognizer(tap)
        
        viewCall.isUserInteractionEnabled = true
        
        //Call the super addRightOptions to set the view that will display while swiping
        super.addRightOptionsView(viewCall)
    }
    
    func addRightViewInCell() {
        
        //Create a view that will display when user swipe the cell in right
        let viewCall = UIView()
        viewCall.backgroundColor = UIColor.lightGray
        viewCall.frame = CGRect(x: 0, y: 0,width: self.frame.height+20,height: self.frame.height)
        //Add a label to display the call text
        let lblCall = UILabel()
        lblCall.text  = "Call"
        lblCall.font = UIFont.systemFont(ofSize: 15.0)
        lblCall.textColor = UIColor.yellow
        lblCall.textAlignment = NSTextAlignment.center
        lblCall.frame = CGRect(x: 0,y: self.frame.height - 20,width: viewCall.frame.size.width,height: 20)
        //Add a button to perform the action when user will tap on call and add a image to display
        let btnCall = UIButton(type: UIButtonType.custom)
        btnCall.frame = CGRect(x: (viewCall.frame.size.width - 40)/2,y: 5,width: 40,height: 40)
        btnCall.setImage(UIImage(named: "nhi"), for: UIControlState())
        btnCall.addTarget(self, action: #selector(ShopTableViewCell.callButtonClicked), for: UIControlEvents.touchUpInside)
        
        
        var imageView  = UIImageView(frame:CGRect(x: (viewCall.frame.size.width - 40)/2,y: 5,width: 40,height: 40))
        imageView.image = UIImage(named:"nhi")
        
        viewCall.addSubview(imageView)
        viewCall.addSubview(lblCall)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        viewCall.addGestureRecognizer(tap)
        
        viewCall.isUserInteractionEnabled = true
        
        //Call the super addRightOptions to set the view that will display while swiping
        super.addRightOptionsView(viewCall)
    }

    func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        self.resetCellState()
    }
    
    func handleTap2(_ sender: UITapGestureRecognizer) {
        print("Call ")
        self.resetCellState()
    }
    
    func callButtonClicked(){
        //Reset the cell state and close the swipe action
        print("click")
        self.resetCellState()
    }
    */
}
