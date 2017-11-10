//
//  DiveSite.swift
//  DiveMapExample
//
//  Created by ben on 01/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import RealmSwift

class DiveSite: Object {
    @objc dynamic var name: String?
    @objc dynamic var lat: String?
    @objc dynamic var lng: String?
    @objc dynamic var id: String?
    @objc dynamic var url: String = ""

    convenience required init(id: String, lat: String, lng: String ,name: String) {
        self.init()
        self.id = id
        self.lat = lat
        self.lng = lng
        self.name = name
    }
    
    
    func saveData() {
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(self)
        }
    }
    
    func retrieveData() -> DiveSite?{
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for parking data object
        let diveSiteData = realm.objects(DiveSite.self).filter("id = %@",self.id!)
        return diveSiteData.first!
    }
}
