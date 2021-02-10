//
//  ViewController.swift
//  MyLocations
//
//  Created by Giovanni Gaffé on 2021/2/6.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {

    var locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        // Do any additional setup after loading the view.
    }

    // MARK: - Outlets

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var tagButton: UIButton!
    @IBOutlet var getButton: UIButton!

    
    // MARK: - Actions
    @IBAction func getLocation() {
        let authStatus = locationManager.authorizationStatus
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation { stopLocationManager() }
        else {
            location = nil
            lastLocationError = nil
            startLocationManager()
            placemark = nil
            lastGeocodingError = nil
        }
        updateLabels()
    }

    // MARK: - Helper Methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in app settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }

    // Called after 1 minutes no matter what
    @objc func didTimeOut() {
        print("Time Out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
    }
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
            
            if let placemark = placemark {
                adressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                adressLabel.text = "Searching for Adress ..."
            } else if lastGeocodingError != nil {
                adressLabel.text = "Error Finding Adress"
            } else {
                adressLabel.text = "No Adress Found"
            }
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            adressLabel.text = ""
            tagButton.isHidden = true
            
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Service Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
        configureGetButton()
    }
    
    func configureGetButton() {
        if updatingLocation { getButton.setTitle("Stop", for: .normal) }
        else { getButton.setTitle("Get My Location", for: .normal) }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let tmp = placemark.subThoroughfare {
            line1 += tmp + " "
        }
        
        if let tmp = placemark.thoroughfare {
            line1 += tmp + " "
        }
        
        var line2 = ""
        if let tmp = placemark.locality {
            line2 += tmp + " "
        }
        
        if let tmp = placemark.administrativeArea {
            line2 += tmp + " "
        }
        
        if let tmp = placemark.postalCode {
            line2 += tmp + " "
        }
        
        return line1 + "\n" + line2
    }
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
        
        // loc.Manager cannot find location. So it keep trying to get a loc.
        if (error as NSError).code == CLError.locationUnknown.rawValue { return }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations: \(newLocation)")
        
        // If time where object wass determined is too longhere 5 seconds
        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        
        // check where new location is more accurate
        if newLocation.horizontalAccuracy < 0 { return }
        
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        // check where location is more precise
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("We're done!")
                stopLocationManager()
            }
            updateLabels()
            
            if !performingReverseGeocoding {
                print("*** Let's geocode")
                
                performingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let places = placemarks, !places.isEmpty {
                        self.placemark = places.last
                        print("Places = \(places)")
                    } else {
                        self.placemark = nil
                    }
                    
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                }
            } else if distance < 1 {
                let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
                if timeInterval > 10 {
                    print("Force Done!")
                    stopLocationManager()
                    updateLabels()
                }
            }
            
        }
    }
}

