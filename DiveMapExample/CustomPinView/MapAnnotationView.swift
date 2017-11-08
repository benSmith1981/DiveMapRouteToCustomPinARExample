//
//  MapAnnotationView.swift
//  DiveMapExample
//
//  Created by ben on 08/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit
import MapKit
class MapAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let kPersonMapAnimationTime = 0.5
    // data
    weak var mapAnnotationViewDelegate: DiveDetailMapViewDelegate?
    weak var customCalloutView: DetailMapPinView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // 1
        self.image = #imageLiteral(resourceName: "divesiteIcon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
        self.image = #imageLiteral(resourceName: "divesiteIcon")
    }
    
    // MARK: - callout showing and hiding
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { // 2
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadDiveDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else { // 3
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadDiveDetailMapView() -> DetailMapPinView? { // 4

        if let views = Bundle.main.loadNibNamed("DetailMapPinView", owner: self, options: nil) as? [DetailMapPinView], views.count > 0 {
            let diveDetailMapView = views.first!
            diveDetailMapView.delegate = self.mapAnnotationViewDelegate
            if let diveAnnotation = annotation as? DiveMapAnnotation {
                let diveSite = diveAnnotation.diveSite
                diveDetailMapView.configure(with: diveSite)
            }
            return diveDetailMapView
        }
        return nil
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
    
    override func prepareForReuse() { // 5
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
