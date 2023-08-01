//
//  CircularGaugeStyle.swift
//  Speedometer
//
//  Created by Radosław Czubak on 29/07/2023.
//

import SwiftUI

struct CircularGaugeStyle: GaugeStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {

            Circle()
                .foregroundColor(Color(.systemGray6))
 
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(135))
 
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(Colors.textColor)
                Text("KM/H")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(Colors.textColor)
            }
 
        }
        .frame(width: 300, height: 300)
 
    }
 
}

struct CircularGaugeStyle_Previews: PreviewProvider {
    static var previews: some View {
        Gauge(value: 23, in: 0...50){
            Image(systemName: "gauge.medium")
                .font(.system(size: 50.0))
        } currentValueLabel: {
            Text("\(23.formatted(.number))")

        } .gaugeStyle(CircularGaugeStyle())
    }
}
