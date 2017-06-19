//
//  MainTabBarController.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/5/10.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol Subscriber {
    var shops:[CafeShop] {get set}
    func loadData(_ shops:[CafeShop])
}

class MainTabBarController: UITabBarController {
    
    var subscribers = [Subscriber]()
    
    var shops = [CafeShop]()

    var ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = hexStringToUIColor("F0B31D")
        self.tabBar.tintColor = UIColor.white//hexStringToUIColor("7D5A1A")
        //self.tabBar.unselectedItemTintColor = UIColor.white

        // Do any additional setup after loading the view.
        for vc in self.viewControllers!{
            let vcc = (vc as! UINavigationController).viewControllers.first!
            _ = vcc.view
            subscribers.append(vcc as! Subscriber)
        }
        
        if let _ = self.ud.dictionary(forKey: "favList"){
        }else{
            ud.set([String:Int](), forKey: "favList")
        }
        loadData()
    }
    
    func loadData(){
        Alamofire.request("https://cafenomad.tw/api/v1.2/cafes/taipei").validate().responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    let jsons = JSON(data)
                    for json in jsons.arrayValue{
                        self.shops.append(CafeShop(json))
                    }
                    for sub in self.subscribers{
                        sub.loadData(self.shops)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
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
