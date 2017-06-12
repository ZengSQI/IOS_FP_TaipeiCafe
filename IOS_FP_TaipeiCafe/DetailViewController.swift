//
//  DetailViewController.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/4/24.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GooglePlaces

class DetailViewController: UIViewController {
    
    var cafeShop:CafeShop?
    
    var delegate:ListViewController?
    
    @IBOutlet weak var navbar: UINavigationItem!
    
    @IBOutlet weak var shopPhoto: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var mrt: UILabel!
    
    @IBOutlet weak var link: UIButton!
    
    @IBOutlet weak var wifi: UILabel!
    
    @IBOutlet weak var seat: UILabel!
    
    @IBOutlet weak var quiet: UILabel!
    
    @IBOutlet weak var tasty: UILabel!
    
    @IBOutlet weak var cheap: UILabel!
    
    @IBOutlet weak var music: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.link.layer.cornerRadius = 21
        self.link.layer.borderWidth = 1
        self.link.layer.borderColor = hexStringToUIColor("7D5A1A").cgColor
        self.navbar.title = self.cafeShop?.name
        
        self.time.text = (cafeShop?.open_time == "" ? "無提供" : cafeShop?.open_time)
        self.address.text = (cafeShop?.address == "" ? "無提供" : cafeShop?.address)
        self.mrt.text = (cafeShop?.mrt == "" ? "無" : cafeShop?.mrt)
        
        self.wifi.text = "\((cafeShop?.wifi)!)"
        self.seat.text = "\((cafeShop?.seat)!)"
        self.quiet.text = "\((cafeShop?.quiet)!)"
        self.tasty.text = "\((cafeShop?.tasty)!)"
        self.cheap.text = "\((cafeShop?.cheap)!)"
        self.music.text = "\((cafeShop?.music)!)"

        
        // Do any additional setup after loading the view.
        getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.setTabBarVisible(visible: false, duration: 0.2, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.setTabBarVisible(visible: true, duration: 0.7, animated: true)
    }
    
    func getImage(){
        let lat = (cafeShop?.latitude)!
        let long = (cafeShop?.longitude)!
        let name = (cafeShop?.name)!
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let parameters:Parameters = [
            "location":"\(lat),\(long)",
            "radius":"100",
            "keyword":name,
            "language":"zh-TW",
            "key":"AIzaSyAo9VkxNyXg2KKOp9iof3tRhi55sXnbmqY"
        ]
        Alamofire.request(url ,method:.get, parameters: parameters) .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["status"].stringValue == "OK"{
                    let result = json["results"].arrayValue[0]
                    let id = result["place_id"].stringValue
                    print(id)
                    self.loadFirstPhotoForPlace(placeID: id)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("get")
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }else {
                    print("No photo.")
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("done")
                self.shopPhoto.image = photo;
            }
        })
    }
    

    @IBAction func backToList(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func toWebsite(_ sender: UIButton) {
        UIApplication.shared.open((cafeShop?.url)!)
    }

    @IBAction func openMap(_ sender: UIBarButtonItem) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?daddr=\((cafeShop?.latitude)!),\((cafeShop?.longitude)!)&directionsmode=walking")!)
        } else {
            let alert = UIAlertController.init(title: "無法開啟GoogleMaps", message: "請至AppStore下載", preferredStyle: .alert)
            self.show(alert, sender: nil)
            print("Can't use comgooglemaps://");
        }

    }
    
}
