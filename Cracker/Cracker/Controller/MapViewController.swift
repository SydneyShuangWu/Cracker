//
//  MapViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/28.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    // MARK: - Mock Data
    private var mockCharacters: [MockMarker] = [
        
        MockMarker(
            name: "Sponge Bob",
            brief: "A citizen in Bikini Bottom",
            category: "Character",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.040079, longitude: 121.560352)
        ),
        MockMarker(
            name: "Krusty Krab",
            brief: "Famous for its signature burger, the Krabby Patty, the formula to which is a closely guarded trade secret",
            category: "Location",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.038284, longitude: 121.560330)
        )
    ]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setup core location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        setupMap()
    }
    
    // MARK: - Configure Map
    func setupMap() {
        
        // Set initial location for the game
        let initialLocation = CLLocation(latitude: 25.042409, longitude: 121.564887)
        
        // Set initial location to be the center of the map on startup
        mapView.centerToLocation(initialLocation)
        
        // Constrain the user to pan and zoom the map over a specified area
        constrainMapView()
        
        // Register CharacterMarkerView as a reusable annotation view
        mapView.register(
            MarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Plot the character on the map
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
        
        mapView.addAnnotations(mockCharacters)
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

// MARK: - Location Manager Delegate: Current Location
extension MapViewController: CLLocationManagerDelegate {
    
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
}

// MARK: - Geofence

// Turn Geotification into CLCircularRegion in order to implement Geofence
func region(with geotification: MockGeotification) -> CLCircularRegion {
    
    let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
    
    region.notifyOnEntry = true
    
    return region
}
