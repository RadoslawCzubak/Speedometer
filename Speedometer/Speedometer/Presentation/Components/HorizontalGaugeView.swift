//
//  HorizontalGaugeView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 28/07/2023.
//

import SwiftUI

struct HorizontalGaugeView: View {
    let value: Double
    let upLimit: Double = 50.0
    let lowLimit: Double = 0.0
    var body: some View {
        VStack{
            Gauge(value: value, in: lowLimit...upLimit) {
                Label("Speed", systemImage: "bicycle")
                    .foregroundColor(Colors.textColor)
            } currentValueLabel: {} minimumValueLabel: {
                Image(systemName: "tortoise")
                    .foregroundColor(Colors.textColor)
            } maximumValueLabel: {
                Image(systemName: "hare")
                    .foregroundColor(Colors.textColor)
            }
            Text(String(format: "%.2f", value))
                .foregroundColor(Colors.textColor)
                .font(.system(size: 80))
        }
    }
}

struct HorizontalGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalGaugeView(
            value: 34.6)
    }
}
