//
//  SalesItemViewCell.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/6/1.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SalesItemViewCell: UICollectionViewCell{
    
    @IBOutlet weak var sales_img: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func downloadImg(url: String)
    {
        sales_img.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage(named: "no_image")!)
    }
}
