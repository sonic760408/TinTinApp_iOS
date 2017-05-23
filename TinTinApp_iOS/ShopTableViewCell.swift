//
//  CollectionViewCell.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/15.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import UIKit

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
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
