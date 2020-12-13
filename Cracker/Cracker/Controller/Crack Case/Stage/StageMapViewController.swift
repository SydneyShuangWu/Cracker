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
        
        // Notify when user has opened Cracker from Settings
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        
        registerForLocationUpdates()
    }
    
    func registerForLocationUpdates() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            
            setupCoreLocation()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
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

// MARK: - Core Location
extension StageMapViewController: CLLocationManagerDelegate {
    
    func setupCoreLocation() {
        
        locationManager.delegate = self
        
        // Set up the accuracy of core locations
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let authStatus = manager.authorizationStatus
        
        let accuracyStatus = manager.accuracyAuthorization
        
        if (authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse)
            && accuracyStatus == .fullAccuracy {
            
            print("✅ Current location is authorized by the user")

            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        } else if authStatus == .denied || accuracyStatus == .reducedAccuracy {
            
            let alertController = UIAlertController(title: "定位失敗", message: "無法取得使用者所在精確位置", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "前往設定", style: .default) { _ -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    
                    UIApplication.shared.open(settingsUrl, completionHandler: { success in
                        
                        print("Settings opened: \(success)")
                    })
                }
            }
            
            alertController.addAction(settingsAction)
            present(alertController, animated: true, completion: nil)
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

// MARK: - Map View
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
