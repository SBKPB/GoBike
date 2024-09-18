//
//  CLLocationManager.swift
//  GoBike
//
//  Created by Ben Stark on 2024/9/18.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case authorizationDenied
    case locationUnavailable
    case multipleRequestsNotSupported
    case timeout
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
    }
    
    var currentLocation: CLLocation {
        get async throws {
            if continuation != nil {
                throw LocationError.multipleRequestsNotSupported
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                locationManager.startUpdatingLocation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                    if let continuation = self?.continuation {
                        continuation.resume(throwing: LocationError.timeout)
                        self?.continuation = nil
                        self?.locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            continuation?.resume(throwing: LocationError.authorizationDenied)
            continuation = nil
        default:
            return
        }
    }
    
    
    //當獲取到新的位置時被呼叫
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            continuation?.resume(returning: lastLocation)
            continuation = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    //當獲取位置失敗時被呼叫
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
        locationManager.stopUpdatingLocation()
    }
}
