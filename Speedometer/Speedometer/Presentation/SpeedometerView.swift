//
//  ContentView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 23/07/2023.
//

import SwiftUI
import MapKit
import UniformTypeIdentifiers

let SPEED_ACCURACY_LIMIT_IN_MPS = 0.5

struct SpeedometerView: View {
    @StateObject var viewModel = SpeedometerViewModel()
    @State private var importing = false
    let gpxType = UTType(exportedAs: "com.topografix.gpx", conformingTo: .xml)

    var body: some View {
        if(viewModel.isLargeMapMode){
            SpeedometerLargeMapView(lat: viewModel.locationCoords.coordinates.latitude,
                                    lng: viewModel.locationCoords.coordinates.longitude,
                                    alt: viewModel.locationCoords.altitude, speed: viewModel.speed, speedAccuracy: viewModel.speedAccuracy,
                                    route: viewModel.route,
                                    onSpeedoTap: {
                viewModel.setViewMode(mode: .LargeSpeedo)
            },onLocationTap: {
                importing = true
            }
            )
            .updateMapPosition(latitude: viewModel.locationCoords.coordinates.latitude, longitude: viewModel.locationCoords.coordinates.longitude)
            .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
            .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .fileImporter(isPresented: $importing, allowedContentTypes: [.xml], onCompletion: { result in
                print(result)
                do {
                    let selectedFile: URL = try result.get()
                    guard selectedFile.startAccessingSecurityScopedResource() else {
                        // Handle the failure here.
                        return
                    }
                    switch result {
                        
                    case .success(let file):
                        viewModel.setRouteFile(file: file)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    selectedFile.stopAccessingSecurityScopedResource()
                } catch{
                    print(error)
                }
            })
        } else{
            LargeSpeedometerView(
                speed: viewModel.speed,
                speedAccuracy: viewModel.speedAccuracy,
                latitude: viewModel.locationCoords.coordinates.latitude,
                longitude: viewModel.locationCoords.coordinates.longitude,
                altitude: viewModel.locationCoords.altitude,
                onMapTap: {
                    viewModel.setViewMode(mode: .LargeMap)
                })
            .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
            .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

struct LargeSpeedometerView: View {
    
    let speed: Double
    let speedAccuracy: Accuracy
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let onMapTap: () -> Void
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center) {
            Spacer()
            CircularGaugeView(value: speed)
                .onTapGesture {
                    onMapTap()
                }
            Spacer()
            LocationInfoView(
                lat: latitude,
                lng: longitude,
                alt: altitude
            ).updateMapPosition(
                latitude: latitude,
                longitude: longitude
            )
            
            Spacer()
            LocationAccuracyBar(accuracy: speedAccuracy)
        }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding()
        .background(Colors.background)
    }
}

struct SpeedometerLargeMapView: View {
    @State var tracking:MapUserTrackingMode = .follow
    @State var region: MKCoordinateRegion
    let lat: Double
    let lng: Double
    let alt: Double
    let speed: Double
    let speedAccuracy: Accuracy
    let route: [CLLocationCoordinate2D]
    let onSpeedoTap: () -> Void
    let onLocationTap: () -> Void

    
    init(lat: Double, lng: Double, alt: Double, speed: Double, speedAccuracy: Accuracy, route: [CLLocationCoordinate2D], onSpeedoTap: @escaping () -> Void, onLocationTap: @escaping () -> Void) {
        self.lat = lat
        self.lng = lng
        self.alt = alt
        self.speed = speed
        self.speedAccuracy = speedAccuracy
        self.route = route
        self.onSpeedoTap = onSpeedoTap
        self.onLocationTap = onLocationTap
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    }
    
    var body: some View {
        ZStack{
            MapView(polylineCoordinates: route, region: $region)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom, content: {
                VStack{
                    HStack{
                        CircularGaugeView(value: speed, fontSize: 25, size: 100)
                            .onTapGesture {
                                onSpeedoTap()
                            }
                        Spacer(minLength: 40)
                        LocationInfoStack(latitude: lat, longitude: lng, altitude: alt)
                            .frame(height: 100)
                            .onTapGesture {
                                onLocationTap()
                            }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .cornerRadius(16)
                .padding(16)
            })
    }
    
    func updateMapPosition(latitude: Double, longitude: Double) -> some View {
        let newCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        region = MKCoordinateRegion(center: newCenter, span: region.span)
        return body
    }
}

#if DEBUG
struct SpeedometerView_Previews : PreviewProvider {
    static var previews: some View {
        SpeedometerView()
    }
}

struct LargeMapSpeedometerView_Previews : PreviewProvider {
    static var previews: some View {
        SpeedometerLargeMapView(lat: 51, lng: 10, alt: 123.000, speed: 12, speedAccuracy: .Invalid, route: [],onSpeedoTap: {}, onLocationTap: {})
    }
}


#endif

