//
//  LocationManager.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/21/24.
//

import SwiftUI
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    var userLocation: CLLocation?
    var isAuthorized = false
    
    override init() {
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            print("access denied")
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}














//class LocationManager: NSObject, Observable, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    
//    var region: MKCoordinateRegion?
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            DispatchQueue.main.async {
//                self.region = MKCoordinateRegion(
//                    center: location.coordinate,
//                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                )
//            }
//        }
//    }
//}
//
//
//















// This class is used purley for checking the status of the user location settings and figuring out the users last location I think
//import CoreLocation
//import Foundation
//
//class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//    
//    @Published var lastKnownLocation: CLLocationCoordinate2D?
//    var manager = CLLocationManager()
//    
//    func checkLocationAuthorization() {
//        
//        manager.delegate = self
//        manager.startUpdatingLocation()
//        
//        switch manager.authorizationStatus {
//            
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//            
//        case .restricted:
//            print("Location restricted")
//            
//        case .denied:
//            print("Location denied")
//            
//        case .authorizedAlways:
//            print("Location authorizedAlways")
//            
//        case .authorizedWhenInUse:
//            print("Location authroized when in use")
//            lastKnownLocation = manager.location?.coordinate
//
//        @unknown default:
//            print("Location service disabled")
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastKnownLocation = locations.first?.coordinate
//    }
//}
//
//Give me a rundown based on MKLocalSearch, I want to be able to automatically display the nearest urgent cares and hospitals, but I don't want to have the user manually search up urgent care in order to do that, so should I use an api for the urgent cares or MKLocalSearch?
