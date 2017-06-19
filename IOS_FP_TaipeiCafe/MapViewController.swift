//
//  ViewController.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/4/24.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, GMSMapViewDelegate, Subscriber{
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.0
    
    var shops = [CafeShop]()
    
    var shopsSource = [CafeShop]()
    
    var markers = [GMSMarker]()
    
    var markersSource = [GMSMarker]()
    
    var listView:ListViewController?
    
    var nearestId = 0
    
    var ud = UserDefaults.standard
    
    var onFav = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor =  hexStringToUIColor("F0B31D")
        
        self.navigationController?.navigationBar.tintColor = hexStringToUIColor("7D5A1A")
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        placesClient = GMSPlacesClient.shared()
        
        print("aa")
        
    }
    

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.view = mapView

    }
    
    func loadData(_ shops:[CafeShop]){
        self.shops = shops
        self.shopsSource = shops
        var favList = ud.dictionary(forKey: "favList") as! [String:Int]
        for shop in shops{
            let position = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
            let marker = GMSMarker(position: position)
            marker.title = shop.name
            marker.snippet = "綜合評分：\(String.init(format: "%.1f", shop.avag))  距離：\(shop.distance)M"
            marker.map = mapView
            marker.userData = shop
            self.markers.append(marker)
            self.markersSource.append(marker)
            if let _ = favList[shop.id]{}
            else{
                favList.updateValue(0, forKey: shop.id)
                print("update")
            }
        }
        ud.set(favList, forKey: "favList")
        if let cl = currentLocation{
            getDistance(location: cl)
        }
    }
    
    func filterData(_ shops:[CafeShop]){
        self.shops = shops
        for shop in shops{
            let position = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
            let marker = GMSMarker(position: position)
            marker.title = shop.name
            marker.snippet = "綜合評分：\(String.init(format: "%.1f", shop.avag))  距離：\(shop.distance)M"
            marker.map = mapView
            marker.userData = shop
            self.markers.append(marker)
            self.markersSource.append(marker)
        }
        if let cl = currentLocation{
            getDistance(location: cl)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "showDetail", sender: marker.userData)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func optionMenu(_ sender: UIBarButtonItem) {
        let menu = UIAlertController(title: "", message: "動作選擇", preferredStyle: .actionSheet)
        let nearest = UIAlertAction(title: "找最近", style: .default, handler: { _ in
            self.mapView.selectedMarker = self.markers[self.nearestId]
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: self.markers[self.nearestId].position, zoom: self.zoomLevel))
        })
        var fav = UIAlertAction()
        if onFav == 1{
            fav = UIAlertAction(title: "顯示全部", style: .default, handler: { _ in
                self.mapView.clear()
                self.markers.removeAll()
                self.filterData(self.shopsSource)
                self.onFav = 0
            })
        }else{
            fav = UIAlertAction(title: "顯示最愛", style: .default, handler: { _ in
                self.mapView.clear()
                self.markers.removeAll()
                let ud = UserDefaults.standard
                let favList = ud.dictionary(forKey: "favList") as! [String:Int]
                let filtershops = self.shops.filter({ (shop) -> Bool in
                    return favList[shop.id] == 1
                })
                self.filterData(filtershops)
                self.onFav = 1
            })
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        menu.addAction(nearest)
        menu.addAction(fav)
        menu.addAction(cancel)
        self.present(menu, animated: true, completion: nil)
    }
    
    func getDistance(location: CLLocation){
        var min = 99999
        var i = 0
        for shop in shops{
            shop.distance = Int(location.distance(from: shop.location))
            //print("kk")
            self.markers[i].snippet = "綜合評分：\(String.init(format: "%.1f", shop.avag))  距離：\(shop.distance)M"
            if shop.distance <= min && shop.distance != 0 {
                min = shop.distance
                nearestId = i
                print(min)
            }
            i = i+1
        }
        print(nearestId)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailViewController
            vc.cafeShop = sender as! CafeShop
        }
    }


}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        currentLocation = location
        getDistance(location: location)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


