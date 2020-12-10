//
//  StageMapViewController.swift
//  Cracker
//
//  Created by Sydney on 2020/12/9.
//

import UIKit
import MapKit
import CoreLocation

class StageMapViewController: UIViewController {
    
    @IBOutlet weak var stageMap: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var currentLocations: [CLLocation] = []
    
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupCoreLocation()
        
        setupMapView()
    }
    
    func setupCoreLocation() {
        
        locationManager.delegate = self
        
        // Set up the accuracy of core locations
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setupMapView() {
        
        stageMap.delegate = self
        stageMap.showsUserLocation = true
        stageMap.userTrackingMode = .followWithHeading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
}

extension StageMapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {

        case .authorizedAlways, .authorizedWhenInUse:

            print("✅ Current location is authorized by the user")

            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()

        default:

            showAlert(withTitle: "請至設定開啟定位", withActionTitle: "OK", message: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocations.append(locations[0])
        
        longitude = locations[0].coordinate.longitude
        latitude = locations[0].coordinate.latitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }
}

extension StageMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        stageMap.setUserTrackingMode(.followWithHeading, animated: true)
    }
}
