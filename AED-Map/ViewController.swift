//
//  ViewController.swift
//  AED-Map
//
//  Created by Kanta Demizu on 2019/06/21.
//  Copyright © 2019 Kanta Demizu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct AEDPlace:Codable {
    var LocationName:String,
    Perfecture:String,
    City:String,
    AddressArea:String,
    Latitude:Double,
    Longitude:Double
}



class ViewController: UIViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet var MapView:MKMapView!
    
    let locationManager = CLLocationManager()
    var aedPlace:[AEDPlace] = []
    var aedAnnotation = MKPointAnnotation()
    let API_URL = "https://aed.azure-mobile.net/api/AEDSearch"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        var region:MKCoordinateRegion = MapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        MapView.userTrackingMode = MKUserTrackingMode.follow
        MapView.setCenter(MapView.userLocation.coordinate, animated: true)
        MapView.setRegion(region,animated:true)
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
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            latitudeLabel.text = "latitude:\(latitude)"
            longitudeLabel.text = "longitude:\(longitude)"
            let text = "https://aed.azure-mobile.net/api/AEDSearch?lat=\(latitude)&lng=\(longitude)"
            let url:URL = URL(string: text)!
            
            let task:URLSessionTask = URLSession.shared.dataTask(with: url,completionHandler: {data,response,error in
                do{
                    self.aedPlace = try JSONDecoder().decode([AEDPlace].self, from: data!)
                }catch{
                    print(error)
                }
            })
            task.resume()
            for pin in aedPlace{
                aedAnnotation.coordinate = CLLocationCoordinate2DMake(pin.Latitude, pin.Longitude)
                aedAnnotation.title = pin.LocationName
                aedAnnotation.subtitle = pin.AddressArea
                self.MapView.addAnnotation(aedAnnotation)
            }
        }
    }
}


