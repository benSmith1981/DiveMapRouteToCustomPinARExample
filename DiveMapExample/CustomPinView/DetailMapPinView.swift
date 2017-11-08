//
//  DetailMapPinView.swift
//  DiveMapExample
//
//  Created by ben on 08/11/2017.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import UIKit
protocol DiveDetailMapViewDelegate: class { // 1
    func detailsRequested(for diveSite: DiveSite)
}
class DetailMapPinView: UIView {
    // outlets
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var diveImageView: UIImageView!
    @IBOutlet weak var diveSiteName: UILabel!
    @IBOutlet weak var seeDetailsButton: UIButton!
    
    // data
    var diveSite: DiveSite!
    weak var delegate: DiveDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // appearance
        backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down) // 3
    }
    
    @IBAction func seeDetails(_ sender: Any) { // 4
        delegate?.detailsRequested(for: diveSite)
    }
    
    func configure(with diveSite: DiveSite) { // 5
        self.diveSite = diveSite
        
        diveImageView.image = #imageLiteral(resourceName: "divesiteIcon")
        diveSiteName.text = diveSite.name
    }
    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = seeDetailsButton.hitTest(convert(point, to: seeDetailsButton), with: event) {
            return result
        }
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
}
