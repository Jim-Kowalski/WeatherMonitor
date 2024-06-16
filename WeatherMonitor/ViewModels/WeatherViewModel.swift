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
    
    //Specifies the url for the web API. Note: we're using fixed coordinates for Birmingham, AL
    private let url = "https://api.open-meteo.com/v1/forecast?latitude=33.1857&longitude=-87.2647&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=America%2FChicago"
    
    @MainActor
    func fetchData() async {
        
        //convert the url string to a URL object
        if let url = URL(string: self.url) {
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
