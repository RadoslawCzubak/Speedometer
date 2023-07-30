//
//  SpeedometerViewModel.swift
//  Speedometer
//
//  Created by Radosław Czubak on 23/07/2023.
//

import Foundation
import CoreLocation
import Combine

extension SpeedometerView {
    class SpeedometerViewModel: NSObject,  ObservableObject {
        @Published var speed: Double = 0.0
        @Published var locationPermission: CLAuthorizationStatus
        @Published var locationCoords: Location = Location(altitude: 0, coordinates: Coordinates.init(latitude: 0, longitude: 0))
        @Published var speedAccuracy: Accuracy = Accuracy.Invalid
        let locationManager: LocationManager
        
        var speedSubscriber: AnyCancellable? = nil
        var speedAccuracySubscriber: AnyCancellable? = nil
        var locationSubscriber: AnyCancellable? = nil
        
        override init(){
            locationManager = LocationManager()
            locationPermission = .notDetermined
            
            super.init()
            
            speedSubscriber = locationManager.speed.sink(receiveValue: { speed in
                let speed = speed.getInKph()
                if(speed<0.0){
                    self.speed = 0.0
                } else {
                    self.speed = speed
                }
            })
            locationSubscriber = locationManager.currentLocation.sink(receiveValue: { location in
                guard location != nil else {
                    return
                }
                self.locationCoords = location!
            })
            speedAccuracySubscriber = locationManager.speedAccuracy.sink(receiveValue: { accuracy in
                self.speedAccuracy = accuracy
            })
            
            locationManager.getLocationAuthorizationStatus()
        }
    }
}

