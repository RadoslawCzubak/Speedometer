//
//  SplashView.swift
//  Speedometer
//
//  Created by Radosław Czubak on 30/07/2023.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingSpeedo = false
    @State private var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
            NavigationLink(destination: SpeedometerView(), isActive: $isShowingSpeedo) { EmptyView() }

            Circle()
                .frame(width: 200)
                .foregroundColor(colorScheme == .dark ? .white : Colors.gold)
                .blur(radius: 50)
                .offset(x:150,y:-300)
            VStack(alignment: .leading){
                Spacer()
                Text("Hey, ready to ride? Where are we cycling to today? 🚴‍♂️")
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Spacer()
                BikeImage(colorScheme: colorScheme)
                Text("Romet Aspre A1 (2023)")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 22, weight: .bold, design: .none))
                    .foregroundColor(Colors.textColor)
            }.frame(maxWidth: .infinity)
                .padding(16)
        }.onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else{
                isShowingSpeedo = true
            }
        }
    }
}

struct BikeImage: View {
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack{
            Ellipse()
                .frame(width: 500, height: 400)
                .foregroundColor(colorScheme == .dark ? .white : Colors.gold)
                .offset(x: -200, y:200)
                .blur(radius: 100)
            Image("rometaspre")
                .offset(x: -100)
        }.frame(maxWidth: 300)
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
