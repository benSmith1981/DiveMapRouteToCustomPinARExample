//
//  ViewController.swift
//  DiveMapExample
//
//  Created by ben on 01/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ARCL
//import SVProgress
protocol MapSearch {
    func showDiveSiteSelected(diveSite: DiveSite)
}

class ViewController: UIViewController, MKMapViewDelegate, MapSearch, DiveDetailMapViewDelegate {
    
    func showDiveSiteSelected(diveSite: DiveSite) {
        //this si the point at which you can call your load region...cause you have the coord of the site selected..
        var coord = CLLocationCoordinate2D.init(latitude: Double(diveSite.lat!)!,
                                                longitude: Double(diveSite.lng!)!)
        self.setZoomAndInitialLocation(location: coord)
        
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var diveSites: [DiveSite] = []
    var diveDetailSite: DiveSite?

    var currentLocation: CLLocationCoordinate2D!
    
    var locationManager = CLLocationManager()

    var searchController:UISearchController!

    let droppedPin = MKPointAnnotation()
    @IBOutlet weak var searchBarLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var searchBarLeadingConstraint: NSLayoutConstraint!
    var destinationCoordinate = CLLocationCoordinate2D()
    var sourceCoordinate = CLLocationCoordinate2D()
    let request = MKDirectionsRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarLeadingConstraint.constant = view.frame.width

        self.view.layoutIfNeeded()
        setupSearchController()
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.diveSearchByGeoObservers),
                                               name:  NSNotification.Name(rawValue: "GeoSearch"),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailViewViewController
        dest.DiveSite = self.diveDetailSite
    }
    @IBAction func animateSearchBar(_ sender: Any) {
        self.searchBarLeadingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
            self.searchBar.alpha = 1
            self.view.layoutIfNeeded()
        }) { (success) in
            
        }
        
    }
    
    func setupSearchController() {
        //setup dive search results table to get results from search controller
        let diveSearchTable = storyboard!.instantiateViewController(withIdentifier: "DiveSearchResultsTable") as! SearchTableViewController
        diveSearchTable.delegate = self
        
        searchController = UISearchController(searchResultsController: diveSearchTable)
        searchController.searchBar.delegate = diveSearchTable
        searchController.hidesNavigationBarDuringPresentation = false;
        //this is true means see the search bar too!
        definesPresentationContext = true
        
//        self.searchBar = searchController.searchBar
        navigationItem.titleView = searchController?.searchBar

    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
            
        let touchPoint = sender.location(in: self.mapView)
        let touchedCoord = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
//        self.mapView.removeAnnotation(self.droppedPin)
        //Create an annotation point
        droppedPin.title = "Dropped Pin" //set its name
        droppedPin.coordinate = touchedCoord //set its coordinate
        
        //create a pin view so we can change the colour
        let droppedPinView = MKPinAnnotationView.init(annotation: droppedPin, reuseIdentifier: "droppedPin")
        droppedPinView.tintColor = UIColor.cyan //change the colour\
        
        //add the annoation that belongs to the pin view to the map
        self.mapView.addAnnotation(droppedPinView.annotation!)
        DiveMapService.diveSearchByGeo(lat: touchedCoord.latitude,
                                       lng: touchedCoord.longitude,
                                       dist: 25)
        setZoomAndInitialLocation(location: touchedCoord)

    }
    
    
    func setZoomAndInitialLocation(location: CLLocationCoordinate2D) {
        
        let regionRadius: CLLocationDistance = 12500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memoery warning")
        // Dispose of any resources that can be recreated.
    }
    @objc func diveDetailResponse(notification: NSNotification) {
        var diveDict = notification.userInfo as! Dictionary<String, DiveSite>
        self.diveDetailSite = diveDict["data"]!

    }
    @objc func diveSearchByGeoObservers(notification: NSNotification) {
        var diveDict = notification.userInfo as! Dictionary<String, [DiveSite]>
        diveSites = diveDict["data"]!

        //Create an array of annotations
        var annotations: [DiveMapAnnotation] = []
        
        //looop the dive sites
        for site in diveSites {
            //create a coordinate for the dive site
            let coordinate = CLLocationCoordinate2D.init(latitude: Double(site.lat!)!,
                                                         longitude: Double(site.lng!)!)
            
            //create the custom Annotation Pin, with extra info, such as the dive data returned that has the ID of the dive site, so we can get the detailed information about the site..
            let annotation = DiveMapAnnotation.init(diveSite: site,
                                                    coordinate: coordinate)
        
            //Append my array of annotations
            annotations.append(annotation)
        }
        
        //Showing all the annotations in my array of annotations...
        self.mapView.showAnnotations(annotations, animated: true)


    }
    
    func detailsRequested(for diveSite: DiveSite) {
        self.destinationCoordinate.latitude = Double(diveSite.lat!)!
        self.destinationCoordinate.longitude = Double(diveSite.lng!)!
        
//        self.sourceCoordinate.latitude = self.mapView.userLocation.coordinate.latitude
//        self.sourceCoordinate.longitude = self.mapView.userLocation.coordinate.longitude

        coordinatesToMapViewRepresentation()
    }

}
