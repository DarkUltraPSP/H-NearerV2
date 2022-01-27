//
//  ViewController.swift
//  H-NearerV2
//
//  Created by Clement Rays on 13/12/2021.
//  Copyright © 2021 Clement Rays. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class AccueilViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var startLocation: UIButton!
    @IBOutlet weak var displayDistance: UILabel!
    @IBOutlet weak var displayPointName: UILabel!
    
    //    Initialisation de variables
    var isLocationEnabled = false
    var isSoundEnabled = false
    var distance = Double()
    static var pointArray: [Point] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            PointManager.fetchPoint() {
                results in AccueilViewController.self.pointArray = results
            }
        }
    }
    
    @IBAction func startLocation(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if (isLocationEnabled) {
            isLocationEnabled = false
            startLocation.setTitle("Démarrer la localisation", for: .normal)
            locationManager.stopUpdatingLocation()
            self.view.layer.removeAllAnimations()
            UIView.animate(withDuration: 0, animations: { self.view.backgroundColor = UIColor.systemBackground })
        } else {
            isLocationEnabled = true;
            startLocation.setTitle("Stop", for: .normal)
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            var nearest = Point(name: "", coord: CLLocation(latitude: 0, longitude: 0))
            for pts in AccueilViewController.pointArray {
                if (location.distance(from: pts.coord) < location.distance(from: nearest.coord)) {
                    nearest = pts
                }
            }
            distance = location.distance(from: nearest.coord)
            blinkV2(distance: distance)
            displayPointName.text = "\(nearest.name)"
            displayDistance.text = "\(Int(distance))m"
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
    func blinkV2(distance:Double) {
        switch distance {
//            Orange background
            case 100..<500:
                UIView.animate(withDuration: 2, delay: 0, options:[.allowUserInteraction, .repeat, .autoreverse], animations:{
                    self.view.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 1)
                    self.view.backgroundColor = UIColor(red: 1, green: 0.416, blue: 0, alpha: 1)
                }, completion: nil)
                break
//            Red background
            case 0..<100:
                UIView.animate(withDuration: 0.5, delay: 0, options:[.allowUserInteraction, .repeat, .autoreverse], animations:{
                    self.view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                    self.view.backgroundColor = UIColor(red: 1, green: 0.333, blue: 0, alpha: 1)
                }, completion: nil)
                break
//            Green Background
            default:
                UIView.animate(withDuration: 6, delay: 0, options:[.allowUserInteraction, .repeat, .autoreverse], animations:{
                    self.view.backgroundColor = UIColor(red: 0.169, green: 1, blue: 0, alpha: 1)
                    self.view.backgroundColor = UIColor(red: 0, green: 1, blue: 0.50, alpha: 1)
                }, completion: nil)
                break
        }
    }
}
