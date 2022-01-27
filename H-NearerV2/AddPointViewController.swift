//
//  AddPointViewController.swift
//  H-NearerV2
//
//  Created by Clement Rays on 01/01/2022.
//  Copyright © 2022 Clement Rays. All rights reserved.
//

import UIKit
import CoreLocation

class AddPointViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfLong: UITextField!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    let locationManager = CLLocationManager()
    var points: [Point] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    @IBAction func sendButton(_ sender: Any) {
        if (tfName.text!.isEmpty || tfLat.text!.isEmpty || tfLong.text!.isEmpty) {
            let alert = UIAlertController(title: "Champs vides", message: "Certains de vos champs sont vides, veuillez les completer", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
        } else {
            PointManager.addNewPoint(name: tfName.text!, lat: tfLat.text!, long: tfLong.text!)
            let alert = UIAlertController(title: "Point ajouté", message: "Veuillez rafraichir la liste", preferredStyle:UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            tfLat.text = "\(latitude)"
            tfLong.text = "\(longitude)"
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
    @IBAction func autoComplete(_ sender: Any) {
        self.locationManager.delegate = self
        self.locationManager.requestLocation();
    }
}
