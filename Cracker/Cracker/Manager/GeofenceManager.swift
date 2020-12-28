//
//  GeofenceManager.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/15.
//

import Foundation
import CoreLocation

class GeofenceManager: NSObject, CLLocationManagerDelegate {

    static let shared = GeofenceManager()
    
    private override init() {}
    
    let locationManager = CLLocationManager()
    
    var didEnter: Bool?
    
    var alreadyInside: Bool?
    
    var identifiers: [String] = []
    
    var geotifications: [Geotification] = []
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if region is CLCircularRegion {
            
            didEnter = false
            
            alreadyInside = false
            
            if identifiers.contains(region.identifier) {
                
                for (index, id) in identifiers.enumerated() where id == region.identifier {
        
                    identifiers.remove(at: index)
                }
            }
            
            print("Exit Geofence: \(region)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if region is CLCircularRegion {
            
            didEnter = true
            
            alreadyInside = false
            
            identifiers.append(region.identifier)
            
            print("Enter Geofence: \(region)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if region is CLCircularRegion {
            
            if state == .inside {
                
                didEnter = false
                
                alreadyInside = true
                
                if !identifiers.contains(region.identifier) {
                    
                    identifiers.append(region.identifier)
                }
                
                print("Already inside Geofence: \(region)")
            }
        }
    }
    
    func region(with geotification: Geotification) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        
        region.notifyOnEntry = true
        
        return region
    }
    
    func getGeotifications() {
        
        guard let charContents = demoRpgCase.charContent else { return }
        
        for charContent in charContents {
            
            let geotification = Geotification(coordinate: charContent.position, radius: 100, identifier: charContent.id)
            
            geotifications.append(geotification)
        }
    }
    
    func startMonitoring() {
        
        locationManager.delegate = self
        
        // Check if the device has the required hardware to support geofence monitoring
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            return
        }
        
        getGeotifications()
        
        // Create CLCircularRegion instances
        for geotification in geotifications {
            
            let fenceRegion = region(with: geotification)
            
            locationManager.startMonitoring(for: fenceRegion)
        }
    }
    
    // Facilitate error handling for Geofence events
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
}
