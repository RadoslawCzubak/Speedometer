//
//  LocationManager.swift
//  Speedometer
//
//  Created by Radosław Czubak on 23/07/2023.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let clLocationManager: CLLocationManager
    private let authorizationStatus = CurrentValueSubject<CLAuthorizationStatus, Never>(CLAuthorizationStatus.notDetermined)
    private let currentLocationSubject = CurrentValueSubject<Location?, Never>(nil)
    let currentLocation: AnyPublisher<Location?, Never>
    
    private let speedSubject = CurrentValueSubject<Speed, Never>(Speed(speedInMps: 0.0))
    let speed: AnyPublisher<Speed, Never>
    
    private let speedAccuracySubject = CurrentValueSubject<Accuracy, Never>(Accuracy.Invalid)
    let speedAccuracy: AnyPublisher<Accuracy, Never>
    
    override init() {
        clLocationManager = CLLocationManager()
        speed = speedSubject.eraseToAnyPublisher()
        speedAccuracy = speedAccuracySubject.eraseToAnyPublisher()
        currentLocation = currentLocationSubject.eraseToAnyPublisher()
        
        super.init()
        
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        clLocationManager.startUpdatingLocation()
    }
    
    func getLocationAuthorizationStatus(){
        clLocationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        self.authorizationStatus.send(authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        guard newLocation != nil else {return}
        currentLocationSubject.send(Location(altitude: newLocation!.altitude, coordinates: Coordinates(latitude: newLocation!.coordinate.latitude, longitude: newLocation!.coordinate.longitude)))
        updateSpeed(newLocation: newLocation!)
    }
    
    func updateSpeed(newLocation: CLLocation){
        speedSubject.send(Speed(speedInMps: newLocation.speed))
        speedAccuracySubject.send(wrapSpeedAccuracy(speedAccuracy: newLocation.speedAccuracy))
    }
    
    func wrapSpeedAccuracy(speedAccuracy: CLLocationSpeedAccuracy) -> Accuracy{
        let mappedSpeed: Accuracy
        if speedAccuracy < 0{
            mappedSpeed = .Invalid
        } else {
            mappedSpeed = .Valid(Speed(speedInMps: speedAccuracy))
        }
        return mappedSpeed
    }
    
    func startLocationUpdate(){
        clLocationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate(){
        clLocationManager.stopUpdatingLocation()
    }
}
