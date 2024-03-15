//
//  ViewController.swift
//  AzMapLocation
//
//  Created by Sefa Aycicek on 15.03.2024.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var locationManager : CLLocationManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCoreLocation()
        
        self.requestLocation()
    }
    
    func prepareCoreLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        //locationManager?.requestLocation() // tek seferlik
        locationManager?.startUpdatingLocation() //durduruncaya kadar konum değişimlerini sürekli almanızı sağlar.
     }
    
    func prepareMap(coordinate : CLLocationCoordinate2D) {
        let regionRadius : CLLocationDistance = 2000
        let currentRegion = MKCoordinateRegion(center: coordinate, 
                                               latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        //mapView.setCenter(coordinate, animated: true)
        mapView.setRegion(currentRegion, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func addAnotation(coordinate : CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        let myPoint = MyPoint(title: "Evim", coordinate: coordinate, info: "100 TL")
        mapView.addAnnotation(myPoint)
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            print("lat: \(location.coordinate.latitude), lon: \(location.coordinate.longitude)")
            
            addAnotation(coordinate: location.coordinate)
        }
        
        if let firstLocation = locations.first {
            prepareMap(coordinate: firstLocation.coordinate)
        }
        
       // locationManager?.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("notDetermined")
        case .denied:
            print("notDetermined")
        case .authorizedAlways:
            print("notDetermined")
        case .authorizedWhenInUse:
            print("notDetermined")
            locationManager?.requestAlwaysAuthorization()
            self.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
}

extension ViewController:  MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let reuseId = "location_pin"
        
        if annotation is MyPoint {
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                anView?.canShowCallout = true // pin'e tıklanınca açılan dialog
                anView?.image = UIImage(named: "pin")
            } else {
                anView?.annotation = annotation
            }
            
            return anView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        if let myAnnotation = annotation as? MyPoint {
            print(myAnnotation.title)
            //myAnnotation.info
        }
    }
}

class MyPoint : NSObject, MKAnnotation {
    var title : String?
    var coordinate: CLLocationCoordinate2D
    var info : String
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
