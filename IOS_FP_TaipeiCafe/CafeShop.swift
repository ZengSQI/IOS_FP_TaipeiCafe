//
//  CafeShop.swift
//  IOS_FP_TaipeiCafe
//
//  Created by Steven Zeng on 2017/5/1.
//  Copyright © 2017年 Tomato.inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps


enum limited_type {
    case yes, no, maybe
}

class CafeShop:NSObject{
    private var _id:String = ""
    private var _name:String = ""
    private var _city:String = ""
    private var _wifi:Float = 0.0
    private var _seat:Float = 0.0
    private var _quiet:Float = 0.0
    private var _tasty:Float = 0.0
    private var _cheap:Float = 0.0
    private var _music:Float = 0.0
    private var _url:String = ""
    private var _address:String = ""
    private var _latitude:String = ""
    private var _longitude:String = ""
    private var _limited_time:limited_type = .maybe
    private var _socket:limited_type = .maybe
    private var _standing_desk:limited_type = .maybe
    private var _mrt:String = ""
    private var _open_time:String = ""
    
    var id:String{
        return _id
    }
    
    var name:String{
        return _name
    }
    
    var wifi:Float{
        return _wifi
    }
    
    var seat:Float{
        return _seat
    }
    
    var quiet:Float{
        return _quiet
    }
    
    var tasty:Float{
        return _tasty
    }
    
    var cheap:Float{
        return _cheap
    }
    
    var music:Float{
        return _music
    }
    
    var open_time:String{
        return _open_time
    }
    
    var latitude:Double{
        return Double.init(_latitude)!
    }
    
    var longitude:Double{
        return Double.init(_longitude)!
    }
    
    var url:URL{
        return URL(string: self._url)!
    }
    
    var address:String{
        return _address
    }
    
    var mrt:String{
        return _mrt
    }
    
    var avag:Float = 0
    
    var location:CLLocation{
        return CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    var distance:Int = 9999
    
    init(_ json:JSON) {
        self._id = json["id"].stringValue
        self._name = json["name"].stringValue
        self._city = json["city"].stringValue
        self._wifi = json["wifi"].floatValue
        self._seat = json["seat"].floatValue
        self._quiet = json["quiet"].floatValue
        self._tasty = json["tasty"].floatValue
        self._cheap = json["cheap"].floatValue
        self._music = json["music"].floatValue
        self._url = json["url"].stringValue
        self._address = json["address"].stringValue
        if self._name == "The Lightened"{
            self._latitude = "121.5431656"
        }else{
            self._latitude = json["latitude"].stringValue
        }
        self._longitude = json["longitude"].stringValue
        switch json["limited_time"].stringValue {
        case "yes":
            self._limited_time = .yes
        case "no":
            self._limited_time = .no
        default:
            self._limited_time = .maybe
        }
        switch json["socket"].stringValue {
        case "yes":
            self._socket = .yes
        case "no":
            self._socket = .no
        default:
            self._socket = .maybe
        }
        switch json["standing_desk"].stringValue {
        case "yes":
            self._standing_desk = .yes
        case "no":
            self._standing_desk = .no
        default:
            self._standing_desk = .maybe
        }
        self._mrt = json["mrt"].stringValue
        self._open_time = json["open_time"].stringValue
        
        self.avag = (self._wifi + self._seat + self._quiet + self._tasty + self._cheap + self._music) / 6
    }
    
}
