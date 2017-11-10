//
//  ARViewController.swift
//  DiveMapExample
//
//  Created by ben on 03/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import ARCL

class ARViewController: UIViewController {
    var sceneLocationView = SceneLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        self.sceneLocationView.locationEstimateMethod = .mostRelevantEstimate
        view.addSubview(sceneLocationView)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.diveSearchByGeoObservers),
                                               name:  NSNotification.Name(rawValue: "GeoSearch"),
                                               object: nil)
        
        let pinCoordinate = CLLocationCoordinate2D(latitude: 52.3731129, longitude: 4.9172527)

        DiveMapService.diveSearchByGeo(lat: pinCoordinate.latitude,
                                       lng: pinCoordinate.longitude,
                                       dist: 25)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    

    
    @objc func diveSearchByGeoObservers(notification: NSNotification) {
        var diveDict = notification.userInfo as! Dictionary<String, [DiveSite]>
        let diveSites = diveDict["data"]!
        for site in diveSites {
            let coordinate = CLLocationCoordinate2D(latitude: Double(site.lat!)!,
                                                    longitude: Double(site.lng!)!)
            addPins(coordinate: coordinate)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPins(coordinate: CLLocationCoordinate2D) {
        
        let location = CLLocation(coordinate: coordinate, altitude: 0)
        let image = UIImage(named: "pin")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

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
