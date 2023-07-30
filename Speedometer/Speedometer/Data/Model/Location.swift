//
//  Location.swift
//  Speedometer
//
//  Created by Radosław Czubak on 26/07/2023.
//

import Foundation

struct Location {
    let altitude: Double
    let coordinates: Coordinates
}

struct Coordinates{
    let latitude: Double
    let longitude: Double
}

struct Speed{
    let speedInMps: Double
    
    func getInKph() -> Double{
        return speedInMps * 3.6
    }
    
    func getInMph() -> Double{
        return getInKph() * 0.621
    }
}


enum Accuracy {
    case Invalid
    case Valid(Speed)
}
