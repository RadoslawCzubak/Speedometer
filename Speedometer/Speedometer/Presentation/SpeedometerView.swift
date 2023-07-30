//
//  ContentView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 23/07/2023.
//

import SwiftUI

let SPEED_ACCURACY_LIMIT_IN_MPS = 0.5

struct SpeedometerView: View {
    @StateObject var viewModel = SpeedometerViewModel()
    var body: some View {
        VStack(alignment: HorizontalAlignment.center) {
            Spacer()
            
            CircularGaugeView(value: viewModel.speed)
            Spacer()
            LocationInfoView(lat: viewModel.locationCoords.coordinates.latitude, lng: viewModel.locationCoords.coordinates.longitude,
                             alt: viewModel.locationCoords.altitude).updateMapPosition(latitude: viewModel.locationCoords.coordinates.latitude, longitude: viewModel.locationCoords.coordinates.latitude)
            Spacer()
            LocationAccuracyBar(accuracy: viewModel.speedAccuracy)
        }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding()
        .background(Colors.background)
    }
}

struct CurrentLocationBar: View {
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        HStack{
            Spacer()
            Text(String(format: "%.5f", latitude))
                .foregroundColor(Color.white)
            Spacer()
            Text(String(format: "%.5f", longitude))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
}

struct LocationAccuracyBar: View{
    let accuracy: Accuracy
    
    var body: some View{
        switch accuracy {
        case .Invalid:
            HStack(alignment: .center){
                Label("Speedometer unavailable", systemImage: "exclamationmark.triangle")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(8.0)
            .background(.red)
            .cornerRadius(8.0)
            
        case .Valid(let speedAcc):
            if(speedAcc.speedInMps < SPEED_ACCURACY_LIMIT_IN_MPS){
                HStack(alignment: .center){
                    Text(String.init(format: "Speed Accuracy: +- %.3f", speedAcc.getInKph()))
                }   .frame(maxWidth: .infinity)
                    .padding(8.0)
                    .background(.green)
                    .cornerRadius(8.0)
            } else {
                HStack(alignment: .center){
                    Label(String.init(format: "Speed Accuracy: +- %.3f", speedAcc.getInKph()), systemImage: "exclamationmark.triangle")
                }   .frame(maxWidth: .infinity)
                    .padding(8.0)
                    .background(.orange)
                    .cornerRadius(8.0)
            }

        }
        
    }
}

#if DEBUG
struct SpeedometerView_Previews : PreviewProvider {
    static var previews: some View {
        SpeedometerView()
    }
}
#endif

