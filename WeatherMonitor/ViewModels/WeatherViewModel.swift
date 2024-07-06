//
//  WeatherViewModel.swift
//  Assignment3
//
//  Created by James Kowalski on 6/7/24.
//
import SwiftUI
import Foundation
//This class represents the model view for the application, which
//uses the connects the models and views.
class WeatherViewModel: ObservableObject {
    
    //Specifies the data structure to contain exceptions
    enum WeatherModelError: Error {
        case decodeError
        case customError(error: Error)
    }
    @Published var error: Error? //Contains the error object that occurred
    @Published var hasError: Bool = false //Indicates an error has occurred
    @Published var weatherData: WeatherModel? //Specifies the raw response
    @Published var lastFetch: Date? //Specifies the last time weather data was fetched.
    //Specifies the url for the web API. Note: we're using fixed coordinates for Birmingham, AL
    
    @MainActor
    func fetchData(latitude: Double, longitude: Double) async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,rain,showers,snowfall,cloud_cover,wind_speed_10m&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=America%2FChicago"
        //var urlString = " https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m&hourly=temperature_2m,relative_humidity_2m,dew_point_2m,precipitation_probability,cloud_cover,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch"
        //convert the url string to a URL object
        if let url = URL(string: urlString) {
            do {
                
                //get the data from the open-mateo weather application asynchronously. This
                //thread of execution is suspended (not blocked) until the thread finished
                let (data, _) = try await URLSession.shared.data(from: url)
                
                //this guard statement attempts to decode the data. If there is an error, the
                //else block is executed
                guard let results = try? JSONDecoder().decode(WeatherModel.self, from: data) else
                {
                    self.hasError.toggle()
                    self.error = WeatherModelError.decodeError
                    return
                }
                
                lastFetch=Date() //Set the timestamp of the last fetched data to display in the UI
                
                //If no errors are encountered in the JSON code, the instance variable for the class
                //will be assigned the decoded JSON.
                self.weatherData = results
            } catch {
                //If an error has occured anywhere in the do block, with the exception of the guard
                //block, this catch block will handle the error.
                self.hasError.toggle()
                self.error = WeatherModelError.customError(error: error)
            }
        }
    }
    func getTimestamp() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: Date())
        return dateString
    }
    func getCurrentWeatherTempAndHumidityString()-> String?
    {
        let strTemp: String = "Temp: \( Int(weatherData?.current.temperature_2m ?? -1) >= 0 ? "\(Int((weatherData?.current.temperature_2m)!)) F" : "??" )"
        let strHumidityString: String = "Humidty: \(Int(weatherData?.current.relative_humidity_2m ?? -1) >= 0 ? "\(Int((weatherData?.current.relative_humidity_2m)!)) %" : "??" )"
        return "\(strTemp)   \(strHumidityString)"
    }
    func getCurrentCloudCoverString() -> String?
    {
        var currentCloudCoverString: String = "Sunny"
        let currentCloudCover = (Int(weatherData?.current.cloud_cover ?? -1))
        if currentCloudCover >= 0 && currentCloudCover < 20
        {
            currentCloudCoverString = "Sunny"
        } else if currentCloudCover >= 20 && currentCloudCover < 50
        {
            currentCloudCoverString = "Partly Cloudy"
        }else if currentCloudCover >= 50 && currentCloudCover < 80
        {
            currentCloudCoverString = "Mostly Cloudy"
        }else if currentCloudCover >= 80
        {
            currentCloudCoverString = "Overcast"
        }
        return "\(currentCloudCoverString)"
    }
    func getCurrentWindSpeedString() -> String?
    {
        let currentWindSpeed = (Int(weatherData?.current.wind_speed_10m ?? -1))
        let currentWindSpeedString = "Wind Speed: \(currentWindSpeed) mph"
        return currentWindSpeedString
    }
    func getCurrentWeatherImage() -> String
    {
        let currentCloudCover = (Int(weatherData?.current.cloud_cover ?? -1))
        let currentShowers = (Int(weatherData?.current.showers ?? -1))
        let currentRain = (Int(weatherData?.current.rain ?? -1))
        let currentSnowFall = (Int(weatherData?.current.snowfall ?? -1))
        var imageName: String = "questionmark"
        
        if currentCloudCover >= 0 && currentCloudCover < 20
        {
            imageName = "sun.max"
        }
        else if currentCloudCover >= 20 && currentCloudCover < 80
        {
            imageName = "cloud.sun"
        }
        else if currentCloudCover >= 80
        {
            imageName = "cloud"
        }
        if currentShowers > 0
        {
            imageName = "cloud.heavyrain"
            
        }
        else if currentRain > 0
        {
            imageName = "cloud.rain"
        }
        else if currentSnowFall > 0
        {
            imageName = "cloud.snow"
        }
        return imageName
        
    }
}



//This function converts the dateString into a day like Monday, Tuesday,
//Wednesday for display in the DayOfWeekView
func dayOfWeek(from dateString: String) -> String?
{
    
    //
    let dateFormatter = DateFormatter() //Initialize a DateFormatter object
    dateFormatter.dateFormat = "yyyy-MM-dd" //Specifies the date format
    
    //Here we convert the dateString to a Date type (yyyy-MM-dd), so that we
    //can convert back to a string with the a 'Monday', 'Tuesday'...format.
    if let date = dateFormatter.date(from: dateString)
    {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        return dayFormatter.string(from: date)
    }
    return nil
}

//This function returns a string with a 12:00 pm format for
//displaying the hourly format, instead of the fully formatted
//date and time.
func formatDate(_ dateString: String) -> String {
    let formatter = DateFormatter() //Initialize a DateFormatter object
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm" //Specifies the date format
    
    //Here we convert the dateString to a Date type, so that we can convert
    //back to a string with the hh:mm a formatting.
    if let dateTime = formatter.date(from: dateString) {
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: dateTime)
    }
    return dateString
}

//This function determines if the beginning of the selectedDate passed in
//matches the dateString. This function returns true if there is a match.
//The objective is to use it for a filter since HourlyWeatherModel's [time]
//field is an array.
func isSameDay(_ dateString: String, as selectedDate: String) -> Bool
{
    return dateString.starts(with: selectedDate)
}
