//
//  CloudRainImageView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 7/6/24.
//

import SwiftUI

struct CloudRainImageView: View {
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        ZStack
        {
            Image(systemName: "cloud.rain.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .mask(
                    Image(systemName: "cloud.rain.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                )
            Image(systemName: "cloud.rain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: width, height: height)
        }

    }
}

#Preview {
    CloudRainImageView(width: 32, height: 32)
}
