//
//  ViewControllerLocationManager.swift
//  DiveMapExample
//
//  Created by ben on 01/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DiveMapService.diveSearchByGeo(lat: location.coordinate.latitude,
                                           lng: location.coordinate.longitude,
                                           dist: 25)
            
            self.sourceCoordinate.latitude = location.coordinate.latitude
            self.sourceCoordinate.longitude = location.coordinate.longitude

            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")

    }
}
