//
//  GradientBorderView.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/6/1.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import UIKit

class GradientBorderView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let gralayer = CAGradientLayer()
        gralayer.colors = [UIColor.white, UIColor.gray, UIColor.white]
        
        gralayer.locations = [0, 0.25, 0.75]
        self.layer.addSublayer(gralayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        let gralayer = CAGradientLayer()
        gralayer.colors = [UIColor.white, UIColor.gray, UIColor.white]
        
        gralayer.locations = [0, 0.25, 0.75]
        self.layer.addSublayer(gralayer)
    }
    

}
