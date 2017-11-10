//
//  DiveMapServiceClass.swift
//  DiveMapExample
//
//  Created by ben on 01/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class DiveMapService {
    static func diveSearchString(searchString: String){
        let url = "http://api.divesites.com/?mode=search&str=\(searchString)"
        Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                print(error)
            }
            var sites: [DiveSite] = []
            if let jsonDict = response.value as? NSDictionary,
                let diveSites = jsonDict["matches"] as? NSArray {
                for site in diveSites {
                    if let site = site as? NSDictionary {
                        if let name = site["name"] as? String,
                            let lng  = site["lng"] as? String,
                            let lat = site["lat"] as? String,
                            let id = site["id"] as?  String {
                            let diveSite = DiveSite.init(id: id,
                                                         lat: lat,
                                                         lng: lng,
                                                         name: name)
                            sites.append(diveSite)
                        }
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "searchResults"),
                                                object: self,
                                                userInfo: ["data":sites])
            }
            
        }
    }
    
    static func diveSearchDetail(id: String){
        //http://api.divesites.com/?mode=detail&siteid=17559
        let url = "http://api.divesites.com/?mode=detail&siteid=\(id)"
        Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                print(error)
            }
            var sites: [DiveSite] = []
            if let jsonDict = response.value as? NSDictionary,
                let site = jsonDict["site"] as? NSDictionary,
                let urls = jsonDict["urls"] as? NSArray,
                let urlDict = urls[0] as? NSDictionary{
                    if let name = site["name"] as? String,
                        let lng  = site["lng"] as? String,
                        let lat = site["lat"] as? String,
                        let id = site["id"] as?  String,
                        let url = urlDict["url"] as? String{
                        let diveSite = DiveSite.init(id: id,
                                                     lat: lat,
                                                     lng: lng,
                                                     name: name)
                        diveSite.url = url
                        sites.append(diveSite)
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "detailResults"),
                                                object: self,
                                                userInfo: ["data":sites])
        }
            
    }
    
    static func diveSearchByGeo(lat: Double, lng: Double, dist: Int)  {
        
        let url = "\(baseURL)?mode=sites&lat=\(lat)&lng=\(lng)&dist=\(dist)"
        Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                print(error)
            }
            var sites: [DiveSite] = []
            if let jsonDict = response.value as? NSDictionary,
                let diveSites = jsonDict["sites"] as? NSArray {
                for site in diveSites {
                    if let site = site as? NSDictionary {
                        if let name = site["name"] as? String,
                            let lng  = site["lng"] as? String,
                            let lat = site["lat"] as? String,
                            let id = site["id"] as?  String {
                            let diveSite = DiveSite.init(id: id,
                                                         lat: lat,
                                                         lng: lng,
                                                         name: name)
                            
                            diveSite.saveData()

                        }
                    }
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "GeoSearch"),
                                                object: self,
                                                userInfo: ["data":sites])
            }
            
        }
    }
}
