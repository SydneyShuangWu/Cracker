//
//  MapViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/28.
//

import UIKit
import MapKit

class RPGMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupCoreLocation()

        setupMap()

        configGeotification(for: geotification)
    }
    
    // MARK: - Core Location
    func setupCoreLocation() {
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    // MARK: - Configure Map
    func setupMap() {
        
        mapView.delegate = self
        
        // Set initial location for the game
        let initialLocation = CLLocation(latitude: 25.042409, longitude: 121.564887)
        
        // Set initial location to be the center of the map on startup
        mapView.centerToLocation(initialLocation)
        
        // Constrain the user to pan and zoom the map over a specified area
        constrainMapView()
        
        // Register MarkerView as a reusable annotation view
        mapView.register(
            StageMarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Plot markers on the map
        renderAnnotation()
    }
    
    func constrainMapView() {
        
        let gameAreaCenter = CLLocation(latitude: 25.041253, longitude: 121.566174)

        let region = MKCoordinateRegion(
            center: gameAreaCenter.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000)
        
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        // Determine how far the view zooms out (how tiny the area becomes)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 5000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    func renderAnnotation() {
        
//        mapView.addAnnotations(mockMarkers)
    }
}

private extension MKMapView {
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}

extension RPGMapViewController: CLLocationManagerDelegate {
    // MARK: - Current Location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            
            switch manager.authorizationStatus {
            
            case .authorizedAlways, .authorizedWhenInUse:
                
                mapView.showsUserLocation = true
                
            case .notDetermined, .denied, .restricted:
                break
                
            default:
                break
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations[0].coordinate.latitude)
    }
    
    // MARK: - Geofence
    // Turn Geotification into CLCircularRegion in order to implement Geofence
    func region(with geotification: MockGeotification) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        
        region.notifyOnEntry = true
        
        return region
    }

    func startMonitoring(geotification: MockGeotification) {
        
        // Check if the device has the required hardware to support geofence monitoring
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            showAlert(withTitle: "Error", withActionTitle: nil, message: "Geofencing is not supported on this device!")
            
            return
        }
        
//        if locationManager.authorizationStatus != .authorizedAlways || locationManager.authorizationStatus != .authorizedWhenInUse {
//            
//            let message = """
//                Geofence will only be activated once you grant Cracker permission to access the device location
//            """
//            
//            showAlert(withTitle: "Warning", message: message)
//        }
        
        // Create a CLCircularRegion instance
        let fenceRegion = region(with: geotification)
        
        locationManager.startMonitoring(for: fenceRegion)
    }
    
    // Facilitate error handling for Geofence events
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
}

// MARK: - Geofence Overlay
extension RPGMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
          let circleRenderer = MKCircleRenderer(overlay: overlay)
          circleRenderer.lineWidth = 1.0
          circleRenderer.strokeColor = .purple
          circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
          return circleRenderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }
    
    func configGeotification(for geotification: MockGeotification) {
        
        startMonitoring(geotification: geotification)
        
        mapView?.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
}

