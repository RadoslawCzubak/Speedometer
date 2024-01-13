//
//  SwiftUIView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 03/08/2023.
//

import SwiftUI

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

struct LocationAccuracyBar_Previews: PreviewProvider {
    static var previews: some View {
        LocationAccuracyBar(
            accuracy: .Invalid
        )
    }
}
