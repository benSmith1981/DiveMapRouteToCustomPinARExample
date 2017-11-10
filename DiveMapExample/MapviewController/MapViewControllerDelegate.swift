//
//  MapViewControllerDelegate.swift
//  DiveMapExample
//
//  Created by ben on 08/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import MapKit
import UIKit
private let kDiveMapAnnotationName = "kDiveMapAnnotationName"

extension ViewController {
    
    // MARK: - MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //load from realm the deatil info
        let annotation = view.annotation as! DiveMapAnnotation
        //suppose we want to retrieve the data from REALM when the pin is pressed...if the data exists...
        if let loadedGarageObjectFromRealm = annotation.diveSite.retrieveData() {
            self.diveDetailSite = loadedGarageObjectFromRealm
            performSegue(withIdentifier: "DetailView", sender: self)
        } else {//if it doesn't exist then load from feed?
            DiveMapService.diveSearchDetail(id: annotation.diveSite.id!)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //        SVProgressHUD.dismiss()
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(red: 10.0/255.0, green: 161.0/255.0, blue: 11.0/255.0, alpha: 1.0)
        renderer.lineWidth = 5
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //returning nil here if annotaiton is mkuserlocation shows the glowing blue dot
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kDiveMapAnnotationName)
        if annotationView == nil {
            annotationView = MapAnnotationView(annotation: annotation, reuseIdentifier: kDiveMapAnnotationName)
            (annotationView as! MapAnnotationView).mapAnnotationViewDelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    private func getDirections() -> MKDirections {
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil))
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        return MKDirections(request: request)
    }
    
    
    func coordinatesToMapViewRepresentation() {
        
        let directions = getDirections()
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                
                var regionRect = route.polyline.boundingMapRect
                
                let wPadding = regionRect.size.width * 0.25
                let hPadding = regionRect.size.height * 0.25
                
                //Add padding to the region
                regionRect.size.width += wPadding
                regionRect.size.height += hPadding
                
                //Center the region on the line
                regionRect.origin.x -= wPadding / 2
                regionRect.origin.y -= hPadding / 2
                
                self.mapView.setRegion(MKCoordinateRegionForMapRect(regionRect), animated: false)
                
            }
        }
    }
}
