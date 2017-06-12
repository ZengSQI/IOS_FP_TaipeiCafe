//
//  ListViewController.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/5/10.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, Subscriber{
    
    var shops = [CafeShop]()
    
    var table:ListTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor("F0B31D")
        
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor("7D5A1A")
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        print("bb")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(_ shops:[CafeShop]){
        self.shops = shops
        self.table?.loadData(shops)
        print("ok")
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed"{
            let vc = segue.destination as! ListTableViewController
            vc.delegate = self
            self.table = vc
        }else if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailViewController
            vc.cafeShop = sender as! CafeShop
            vc.delegate = self
        }
    }

}
