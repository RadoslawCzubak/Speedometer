//
//  CircularGaugeStyle.swift
//  Speedometer
//
//  Created by Radosław Czubak on 29/07/2023.
//

import SwiftUI

struct CircularGaugeStyle: GaugeStyle {
    let width: Int
    let height: Int
    let fontSize: Int
    
    init(){
        self.fontSize = 80
        self.height = 300
        self.width = 300
    }
    
    init(width: Int, height: Int, fontSize: Int){
        self.fontSize = fontSize
        self.height = height
        self.width = width
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {

            Circle()
                .foregroundColor(Color(.systemGray6))
 
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(.blue, style: StrokeStyle(lineWidth: 20/300 * CGFloat(self.height), lineCap: .round))
                .rotationEffect(.degrees(135))
 
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: CGFloat(self.fontSize), weight: .bold, design: .rounded))
                    .foregroundColor(Colors.textColor)
                Text("KM/H")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(Colors.textColor)
            }
 
        }
        .frame(width: CGFloat(width), height: CGFloat(height))
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
