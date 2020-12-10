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
    var currentLng: CLLocationDegrees?
    var currentLat: CLLocationDegrees?
    
    var stageLocations: [CLLocationCoordinate2D] = []
    
    var currentStageIndex: Int!
    
    var stageMarkers: [StageMarker] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getStageCoordinates()
        
        getStageMarkers()
        
        setupCoreLocation()
        
        setupMapView()
    }
    
    func getStageCoordinates() {
        
        guard let stageContents = testLinearCase.stageContent else { return }
        
        for stageContent in stageContents {

            stageLocations.append(stageContent.position)
        }
    }
    
    func getStageMarkers() {
        
        guard let stageContents = testLinearCase.stageContent else { return }
        
        for stageContent in stageContents {
            
            let stageMarker = StageMarker(locationName: stageContent.locationName, coordinate: stageContent.position)
            
            stageMarkers.append(stageMarker)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for index in 0 ..< stageMarkers.count where index == currentStageIndex - 1 {
            
            stageMap.addAnnotation(stageMarkers[index])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
}

extension StageMapViewController: CLLocationManagerDelegate {
    
    func setupCoreLocation() {
        
        locationManager.delegate = self
        
        // Set up the accuracy of core locations
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
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
        
        currentLng = locations[0].coordinate.longitude
        currentLat = locations[0].coordinate.latitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }
}

extension StageMapViewController: MKMapViewDelegate {
    
    func setupMapView() {
        
        stageMap.delegate = self
        stageMap.showsUserLocation = true
        stageMap.userTrackingMode = .followWithHeading
        
        // Register MarkerView as a reusable annotation view
        stageMap.register(
            StageMarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Plot markers on the map
        plotFirstMarkers()
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        stageMap.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    func plotFirstMarkers() {
        
        stageMap.addAnnotation(stageMarkers[0])
    }
}

extension StageMapViewController: PassStageIndexDelegate {
    
    func getStageIndex(with index: Int) {
        
        print("🥳, \(index)")
        currentStageIndex = index
    }
}
