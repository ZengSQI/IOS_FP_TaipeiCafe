//
//  CafeShopCell.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/5/11.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import UIKit

class CafeShopCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var wifi: UILabel!
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var quiet: UILabel!
    @IBOutlet weak var tasty: UILabel!
    @IBOutlet weak var cheap: UILabel!
    
    var shopData:CafeShop!{
        didSet{
            self.name.text = shopData.name
            self.time.text = (shopData.open_time == "") ? "無提供" : shopData.open_time
            self.wifi.text = "\(shopData.wifi)"
            self.seat.text = "\(shopData.seat)"
            self.quiet.text = "\(shopData.quiet)"
            self.tasty.text = "\(shopData.tasty)"
            self.cheap.text = "\(shopData.cheap)"
        }
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
