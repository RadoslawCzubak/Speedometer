//
//  SpeedometerViewModel.swift
//  Speedometer
//
//  Created by Radosław Czubak on 23/07/2023.
//

import Foundation
import CoreLocation
import Combine
import CoreGPX

extension SpeedometerView {
    class SpeedometerViewModel: NSObject,  ObservableObject {
        @Published var isLargeMapMode: Bool = false
        @Published var speed: Double = 0.0
        @Published var locationPermission: CLAuthorizationStatus
        @Published var locationCoords: Location = Location(altitude: 0, coordinates: Coordinates.init(latitude: 0, longitude: 0))
        @Published var speedAccuracy: Accuracy = Accuracy.Invalid
        @Published var route: [CLLocationCoordinate2D] = []
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
        
        func setViewMode(mode: ViewMode){
            switch mode{
            case .LargeMap:
                isLargeMapMode = true
            case .LargeSpeedo:
                isLargeMapMode = false
            }
        }
        
        func setRouteFile(file: URL){
            var newRoute: [CLLocationCoordinate2D] = []
            guard let gpx = GPXParser(withURL: file)?.parsedData() else { return }
            for track in gpx.tracks{
                for segment in track.segments{
                    for point in segment.points{
                        newRoute.append(CLLocationCoordinate2D(latitude: point.latitude ?? 0, longitude: point.longitude ?? 0))
                    }
                }
            }
            print(newRoute)
            self.route = newRoute
        }
    }
}

enum ViewMode{
    case LargeMap, LargeSpeedo
}

