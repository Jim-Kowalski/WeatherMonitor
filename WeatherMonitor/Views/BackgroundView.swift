//
//  BackgroundView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/29/24.
//

import SwiftUI


struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue,  Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    BackgroundView()
}
