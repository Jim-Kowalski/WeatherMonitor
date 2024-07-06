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
        
        ZStack
        {
            
            BackgroundView()
            VStack
            {
                // Custom toolbar
                HStack {
                    Text("Hourly Forecast")
                        .font(.system(size: 28))
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .background(Color.clear)
                .padding(.top, 10) // Adjust this padding to move the toolbar down
                .padding(.horizontal)
                
                //Divider line
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white)
                
                List {
                    //Iterate through the time list in the HourlyWeatherModel to display the
                    //date/time associated with the selected time.
                    ForEach(hourly.time.indices, id: \.self)
                    { index in
                        //Since the hourly list contains all dates, the dates that
                        //are not relevant are filtered out.
                        if isSameDay(hourly.time[index], as: selectedDate)
                        {
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(formatDate(hourly.time[index]))
                                        .bold()
                                        .background(Color.clear)
                                    
                                    Text("Temperature: \(Int(hourly.temperature_2m[index]))°F")
                                        .background(Color.clear)
                                    Text("Precipitation Probability: \(hourly.precipitation_probability[index])%")
                                        .background(Color.clear)
                                }
                                Spacer()

                                
                                //If there is a 30 percent chance of rain, we'll show the rain symbol
                                VStack{
                                    if hourly.precipitation_probability[index] >= 30
                                    {
                                        CloudRainImageView(width: 32, height: 32)
                                    }else{
                                        SunMaxImageView(width: 32, height: 32)
                                    }
                                    
                                    
                                    //Display the rain percentage chance if the percentage of rain is over 30%
                                    Text(hourly.precipitation_probability[index] >= 30 ? "\(hourly.precipitation_probability[index])%": "" )
                                        .background(Color.clear)
                                }
                            }.listRowBackground(Color.clear)
                            
                        }
                    }
                    
                    
                }
                .listStyle(.plain) //Change ListStyle
                .background(Color.clear)
            }
            .background(Color.clear)
        }
    }
}
struct MockData {
    static let sampleHourlyWeather = HourlyWeatherModel(
        time: (0..<24).map { hour in "2024-06-29T\(String(format: "%02d", hour)):00:00Z" },
        temperature_2m: (0..<24).map { _ in Double.random(in: 15...30) },
        precipitation_probability: (0..<24).map { _ in Int.random(in: 0...100) }, weather_code: [0]
    )
    
    static let sampleDailyWeather = DailyWeatherModel(
        time: ["2024-06-29", "2024-06-30", "2024-07-01"],
        weather_code: [100, 200, 300],
        temperature_2m_max: [25.0, 26.5, 27.0],
        temperature_2m_min: [15.0, 16.5, 17.0],
        precipitation_probability_max: [20, 30, 40],
        sunrise: ["","",""],
        sunset: ["","",""]
        
    )
}
struct HourlyWeatherPreview: PreviewProvider {
    static var previews: some View {
        Group {
            HourlyWeatherView(
                hourly: MockData.sampleHourlyWeather,
                selectedDate: MockData.sampleDailyWeather.time[0]
            )
        }
    }
}
