//
//  LocationManager.swift
//  NearMe
//
//  Created by Jibryll Brinkley on 7/17/24.
//

import Foundation
import MapKit
import Observation

enum LocationError: LocalizedError {
    case authorizationDenied,
         authorizationRestricted,
         unknownLocation,
         accessDenied,
         network,
         operationFailed
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return NSLocalizedString("Location access denied.", comment: "")
        case .authorizationRestricted:
            return NSLocalizedString("Location access restricted.", comment: "")
        case .unknownLocation:
            return NSLocalizedString("Unknown location.", comment: "")
        case .accessDenied:
            return NSLocalizedString("Access denied.", comment: "")
        case .network:
            return NSLocalizedString("Network failed.", comment: "")
        case .operationFailed:
            return NSLocalizedString("Operations failed.", comment: "")
            
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    static let shared = LocationManager()
    var error: LocationError? = nil
    
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
}

extension LocationManager {
    
    //didUpdateLocations, didChangeAuthorization, and didFailWithError functions must be taken into account with the CLLocationManagerDelegate.
    
    
    // didUpdateLocation- fired whenever the location of the user is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025))
        }
    }
    
    
    // DidChangeAuthorization - fired whenvever the authorization status changes
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
            case .denied:
            error = .authorizationDenied
            case .restricted:
            error = .authorizationRestricted
            @unknown default:
            break
        }
    }
    
    
    // didFailWithError is fired when you fail to get the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                self.error = .unknownLocation
            case .denied:
                self.error = .accessDenied
            case .network:
                self.error = .network
            default:
                self.error = .operationFailed
            }
        }
    }
}
