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
    
    // Data holder from ModeVc
    var gameId = ""
    
    // Core Location
    let locationManager = CLLocationManager()
    var currentLocations: [CLLocation] = []
    var currentLng: CLLocationDegrees?
    var currentLat: CLLocationDegrees?
    
    // Stage Progress
    var stageLongitude: Double = 0
    var stageLatitude: Double = 0
    var stageLocations: [CLLocationCoordinate2D] = []
    var routeLocations: [CLLocationCoordinate2D] = []
    var currentStageIndex: Int!
    var stageMarkers: [StageMarker] = []
    
    // Firestore
    let firestoreManager = FirestoreManager.shared
    var crackerCase = CrackerCase()
    var stages = [CrackerStage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getStageData()
        
        setupCoreLocation()
        
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
    
    func getStageData() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId)").collection("CrackerCase")
        
        firestoreManager.read(collection: document, dataType: CrackerCase.self) { (result) in
            
            switch result {
            
            case .success(let crackerCase):
                
                self.crackerCase = crackerCase[0]
                self.stages = crackerCase[0].stages!
                
                self.getStageCoordinates()
                self.getStageMarkers()
                self.setupMapView()
                
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    func getStageCoordinates() {
        
        for stage in stages {
            
            stageLatitude = stage.latitude
            stageLongitude = stage.longitude
            
            stageLocations.append(CLLocationCoordinate2D(latitude: stageLatitude, longitude: stageLongitude))
        }
    }
    
    func getStageMarkers() {
        
        for stage in stages {
            
            stageLatitude = stage.latitude
            stageLongitude = stage.longitude
            
            let stageMarker = StageMarker(locationName: stage.locationName, coordinate: CLLocationCoordinate2D(latitude: stageLatitude, longitude: stageLongitude))
            
            stageMarkers.append(stageMarker)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for index in 0 ..< stageMarkers.count where index == currentStageIndex - 1 {
            
            stageMap.addAnnotation(stageMarkers[index])
        }
        
        for _ in stageLocations where currentStageIndex > 1 {

            routeLocations = [stageLocations[currentStageIndex - 2], stageLocations[currentStageIndex - 1]]
            
            showRoute(from: routeLocations[0], to: routeLocations[1])
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
        plotFirstMarker()
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        stageMap.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    func plotFirstMarker() {
        
        stageMap.addAnnotation(stageMarkers[0])
    }
    
    func showRoute(from currentStage: CLLocationCoordinate2D, to nextStage: CLLocationCoordinate2D) {
        
        let currentPlace = MKPlacemark(coordinate: currentStage)
        let currentMapItem = MKMapItem(placemark: currentPlace)
        
        let nextPlace = MKPlacemark(coordinate: nextStage)
        let nextMapItem = MKMapItem(placemark: nextPlace)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = currentMapItem
        directionRequest.destination = nextMapItem
        directionRequest.transportType = .walking
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) -> Void in
            
            guard let response = response else {
                
                if let error = error {
                    
                    print("Route Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.stageMap.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    // Customize polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.B
        renderer.lineWidth = 5
        
        return renderer
    }
}

extension StageMapViewController: PassStageIndexDelegate {
    
    func getStageIndex(with index: Int) {
        
        print("🥳, \(index)")
        currentStageIndex = index
    }
}
