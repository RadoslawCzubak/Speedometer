//
//  MapView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 03/08/2023.
//

import Foundation

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var polylineCoordinates: [CLLocationCoordinate2D] = []
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.showsUserLocation = true
        // Add code to show or hide polyline as needed
        // You'll need to provide an array of CLLocationCoordinate2D points for the polyline.
        let polyline = MKPolyline(coordinates: polylineCoordinates, count: polylineCoordinates.count)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(polyline)
        mapView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(self)
    }
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // Add any additional map delegate methods as needed.
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                if overlay is MKPolyline {
                    let renderer = MKPolylineRenderer(overlay: overlay)
                    renderer.strokeColor = UIColor.blue
                    renderer.lineWidth = 3
                    return renderer
                }
                return MKOverlayRenderer()
            }
    }
}
