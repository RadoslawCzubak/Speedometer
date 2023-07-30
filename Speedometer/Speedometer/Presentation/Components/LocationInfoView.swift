//
//  LocationInfoView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 28/07/2023.
//

import SwiftUI
import MapKit

struct LocationInfoView: View {
    let lat: Double
    let lng: Double
    let alt: Double
    @State var tracking:MapUserTrackingMode = .follow
    @State var region: MKCoordinateRegion

    init(lat: Double, lng: Double, alt: Double) {
        self.lat = lat
        self.lng = lng
        self.alt = alt
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))
    }
    
    var body: some View {
        HStack{
            Map(coordinateRegion: $region ,
                interactionModes: MapInteractionModes.zoom,
                showsUserLocation: true)
            .frame(height: 200)
            .cornerRadius(16)
            LocationInfoStack(latitude: lat, longitude: lng, altitude: alt)
                .padding(.vertical, 8)
                .frame(maxWidth: 150)
                .frame(height: 200)
        }
    }
    
    func updateMapPosition(latitude: Double, longitude: Double) -> some View {
        let newCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        region = MKCoordinateRegion(center: newCenter, span: region.span)
        return body
    }
}

struct LocationInfoStack: View{
    
    let latitude: Double
    let longitude: Double
    let altitude: Double
    
    var body: some View {
        VStack{
            LocationInfoItem(value: latitude, image: "latitude")
            Spacer()
            LocationInfoItem(value: longitude, image: "longitude")
            Spacer()
            LocationInfoItem(value: altitude, image: "altitude")
        }
    }
}

struct LocationInfoItem: View {
    let value: Double
    let image: String
    
    var body: some View {
        HStack{
            Image(image)
                .renderingMode(.template)
                .foregroundColor(Colors.textColor)
            Spacer()
            Text(String(format: "%.6f", value))
                .foregroundColor(Colors.textColor)
            Spacer()
        }
    }
}



struct LocationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInfoView(lat: 51.107883, lng: 17.038538, alt: 123)
    }
}
