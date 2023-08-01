//
//  SpeedometerApp.swift
//  Speedometer
//
//  Created by Radosław Czubak on 23/07/2023.
//

import SwiftUI

@main
struct SpeedometerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                SplashView()
            }
        }
    }
}
