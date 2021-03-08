//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Giovanni Gaffé on 2021/2/27.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Actions
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
