//
//  EventViewCell.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/27.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class EventTableViewCell: UITableViewCell{
    
    @IBOutlet private weak var banner_img: UIImageView!
    @IBOutlet private weak var event_label: UILabel!
    
    @IBOutlet private weak var event_time_label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //print("Cell's initialised")// I see this
        //print(reuseIdentifier)// prints TimesheetCell
    }
    
    func downloadImg(url: String)
    {
        banner_img.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage(named: "no_image")!)
    }
    
    func setBannerImg(image: UIImage)
    {
        banner_img.image = image
    }
    
    func getBannerImg() -> UIImage
    {
        return banner_img.image!
    }
    
    func setEventLabel(event_name: String)
    {
        event_label.text = event_name
    }
    
    func setEventTimeLabel(event_time: String)
    {
        event_time_label.text = event_time
    }
}
