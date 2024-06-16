//
//  WeatherMonitorApp.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//

import SwiftUI
import FirebaseCore
@main
struct WeatherMonitorApp: App {
    init()
    {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            WeatherMonitorView()
        }
    }
}
