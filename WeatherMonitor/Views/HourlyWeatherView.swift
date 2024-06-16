//
//  HourlyWeatherView.swift
//  Assignment3
//
//  Created by James Kowalski on 6/7/24.
//
import SwiftUI
struct HourlyWeatherView: View {
    let hourly: HourlyWeatherModel //Specifies the data structure containing the hourly weather forecast
    let selectedDate: String //Specifies the date to use as a filter. The data structure contains all hours for all days.
    var body: some View {
        List {
            //Iterate through the time list in the HourlyWeatherModel to display the
            //date/time associated with the selected time.
            ForEach(hourly.time.indices, id: \.self) { index in
                //Since the hourly list contains all dates, the dates that
                //are not relevant are filtered out.
                if isSameDay(hourly.time[index], as: selectedDate)
                {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(formatDate(hourly.time[index]))
                                .bold()
                            
                            Text("Temperature: \(Int(hourly.temperature_2m[index]))°F")
                            Text("Precipitation Probability: \(hourly.precipitation_probability[index])%")
                        }
                        Spacer()
                        //If there is a 30 percent chance of rain, we'll show the rain symbol
                        VStack{
                            Image(systemName: hourly.precipitation_probability[index] >= 30 ? "cloud.rain.fill" : "sun.max.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(hourly.precipitation_probability[index] >= 30 ? .blue : .yellow)

                            //Display the rain percentage chance if the percentage of rain is over 30%
                            Text(hourly.precipitation_probability[index] >= 30 ? "\(hourly.precipitation_probability[index])%": "" )
                        }
                    }
                }
            }
        }
        .toolbar
        {
            
            ToolbarItem(placement: .principal)
            {
                //Set the title of the view.
                VStack
                {
                    Text("Hourly Weather")
                        .font(.system(size: 32))
                        .bold()
                }
            }
        }
    }
}


