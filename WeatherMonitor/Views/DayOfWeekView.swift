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
                Spacer()
                VStack
                {
                    //display the rain or sun picture
                    Image(systemName: daily.precipitation_probability_max[index] > 30 ? "cloud.rain.fill" : "sun.max.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(daily.precipitation_probability_max[index] > 30 ? .blue : .yellow)
                    
                    //display the min and max temperature
                    HStack
                    {
                        Text("High: \(Int(daily.temperature_2m_max[index])) F")
                        Text("Low: \(Int(daily.temperature_2m_min[index])) F")
                    }
                    
                }
            }
        }
    }
}



