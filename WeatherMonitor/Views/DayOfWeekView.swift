//
//  DayOfWeekView.swift
//  Assignment3
//
//  Created by James Kowalski on 6/7/24.
//

import SwiftUI

//This view displays the day's weather for the WeatherView.
//It includes the date, the high & low temp, and the rain
//potential.
struct DayOfWeekView: View {
    var daily: DailyWeatherModel
    var index: Int
    var body: some View {
        VStack
        {
            HStack
            {
                VStack{
                    //Get the name of the day ('Monday', 'Tuesday', etc.)
                    if let dayName = dayOfWeek(from: daily.time[index])
                    {
                        //Display the name of the day
                        Text(dayName)
                            .font(.system(size: 18))
                            .bold()
                    }
                    Text(daily.time[index])
                }
                .background(Color.clear)
                .foregroundColor(.black)
                Spacer()
                VStack
                {
                    if daily.precipitation_probability_max[index] > 30
                    {
                        CloudRainImageView(width: 32, height: 32)
                    }else{
                        SunMaxImageView(width: 32, height: 32)
                    }
                    //display the min and max temperature
                    HStack
                    {
                        Text("High: \(Int(daily.temperature_2m_max[index])) F")
                        Text("Low: \(Int(daily.temperature_2m_min[index])) F")
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .listRowBackground(Color.clear)
    }
}



