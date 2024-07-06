//
//  SunMaxImageView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 7/6/24.
//

import SwiftUI

struct SunMaxImageView: View {
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        
        ZStack
        {
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow)
                .frame(width: 32, height: 32)
                .mask(
                    Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                )
            Image(systemName: "sun.max")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    SunMaxImageView(width: 32, height: 32)
}
