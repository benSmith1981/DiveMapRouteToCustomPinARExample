//
//  DiveMapAnnotation.swift
//  DiveMapExample
//
//  Created by ben on 01/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import MapKit

class DiveMapAnnotation: NSObject, MKAnnotation {
    var diveSite: DiveSite
    var coordinate: CLLocationCoordinate2D
    
    init(diveSite: DiveSite,coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.diveSite = diveSite
    }
    
    //GEts the dive site name based on the value of the property in divesite
    var title: String? {
        return diveSite.name
    }
}

