//
//  MapViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/28.
//

import UIKit
import MapKit
import CoreLocation

// Pass data to character info page
protocol PassCharContentDelegate: AnyObject {
    
    func getCharContentOf(charName: String, charInfo: String)
}

class RPGMapViewController: UIViewController {
    
    @IBOutlet weak var rpgMap: MKMapView!
    @IBOutlet weak var characterInfoView: UIView!
    
    let locationManager = CLLocationManager()
    
    var currentLocations: [CLLocation] = []
    var currentLng: CLLocationDegrees?
    var currentLat: CLLocationDegrees?
    
    var characterLocations: [CLLocationCoordinate2D] = []
    
    var characterMarkers: [RPGMarker] = []
    
    weak var charContentDelegate: PassCharContentDelegate?
    
    let geofenceManager = GeofenceManager.shared

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        characterInfoView.layer.cornerRadius = 20
        
        characterInfoView.layer.masksToBounds = true
        
        getCharacterCoordinates()
        
        getCharacterMarkers()
        
        setupCoreLocation()
        
        setupMapView()
        
        renderGeotifications(for: geofenceManager.geotifications)
        
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
    
    func getCharacterCoordinates() {
        
        guard let charContents = demoRpgCase.charContent else { return }
        
        for charContent in charContents {

            characterLocations.append(charContent.position)
        }
    }
    
    func getCharacterMarkers() {
        
        guard let charContents = demoRpgCase.charContent else { return }
        
        for charContent in charContents {
            
            let rpgMarker = RPGMarker(characterName: charContent.name, characterImage: charContent.image, characterInfo: charContent.info, locationName: charContent.location, coordinate: charContent.position)
            
            characterMarkers.append(rpgMarker)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        rpgMap.addAnnotations(characterMarkers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Segue to Character Info Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCharacterInfoVc" {
            
            let nextVc = segue.destination as? CharacterInfoViewController
            
            nextVc?.delegate = self
            
            charContentDelegate = nextVc
        }
    }

    func showCharInfoPage() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.characterInfoView.frame = CGRect(x: (UIScreen.main.bounds.width  - self.characterInfoView.bounds.width) / 2, y: (UIScreen.main.bounds.height  - self.characterInfoView.bounds.height) / 2, width: self.characterInfoView.bounds.width, height: self.characterInfoView.bounds.height)
        }
    }
    
    func hideCharInfoPage() {
        
        UIView.animate(withDuration: 0.5) {
            self.characterInfoView.frame = CGRect(x: self.characterInfoView.frame.minX, y: UIScreen.main.bounds.height, width: self.characterInfoView.bounds.width, height: self.characterInfoView.bounds.height)
        }
    }
}

extension RPGMapViewController: CloseButtonDelegate {
    
    func closeBtnDidPress(_ didPress: Bool) {
        
        hideCharInfoPage()
    }
}

// MARK: - Core Location
extension RPGMapViewController: CLLocationManagerDelegate {
    
    func setupCoreLocation() {
        
        locationManager.delegate = self
        
        // Set up the accuracy of core locations
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let authStatus = manager.authorizationStatus
        
        let accuracyStatus = manager.accuracyAuthorization
        
        if authStatus == .authorizedAlways && accuracyStatus == .fullAccuracy {
            
            print("✅ Current location is authorized by the user")

            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        } else if authStatus == .denied || accuracyStatus == .reducedAccuracy {
            
            let alertController = UIAlertController(title: "定位失敗", message: "請至設定允許永遠取得定位", preferredStyle: .alert)
            
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
extension RPGMapViewController: MKMapViewDelegate {
    
    func setupMapView() {
        
        rpgMap.delegate = self
        rpgMap.showsUserLocation = true
        rpgMap.userTrackingMode = .followWithHeading
        
        // Register MarkerView as a reusable annotation view
        rpgMap.register(
            RPGMarkerView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        
        rpgMap.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    // Handle the callout to show character info
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let char = view.annotation as? RPGMarker {
            
            charContentDelegate?.getCharContentOf(charName: char.characterName!, charInfo: char.characterInfo!)
        }

        showCharInfoPage()
    }
    
    // MARK: - Geofence Overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .B
            circleRenderer.fillColor = UIColor.B!.withAlphaComponent(0.8)
            
            return circleRenderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }
    
    func renderGeotifications(for geotifications: [Geotification]) {
        
        for geotification in geotifications {
            
            rpgMap.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
        }
    }
}
    


