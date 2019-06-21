//
//  ViewController.swift
//  AED-Map
//
//  Created by Kanta Demizu on 2019/06/21.
//  Copyright © 2019 Kanta Demizu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var MapView:MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        MapView.userTrackingMode = MKUserTrackingMode.follow
        MapView.setCenter(MapView.userLocation.coordinate, animated: true)
    }
}


extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 現在位置がlocationsに格納
        if let coordinate = locations.last?.coordinate{
            //現在位置の拡大表示
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            MapView.region = region
        }
    }
}
