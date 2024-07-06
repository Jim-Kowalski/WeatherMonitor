//
//  CitySearchViewModel.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/29/24.
//
import SwiftUI
import Foundation
import Combine
class CitySearchViewModel: ObservableObject {
    //Specifies the data structure to contain exceptions
    enum CityModelError: Error {
        case decodeError
        case customError(error: Error)
    }
    @Published var city: String = ""
    @Published var state: String = ""
    
    @Published var cities: [CityModel] = [] //Specifies the list of cities from the search
    @Published var error: Error? //Contains the error object that occurred
    @Published var hasError: Bool = false //Indicates an error has occurred
    
    
    
    @MainActor
    func fetchCities() async {
        //Initialize the class level variables since we're performing a new search
        self.hasError = false
        self.error = nil
        self.cities = []
        
        //Assemble the string to the geocoding api to fetch any cities that match the search city and state.
        let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(city)&state=\(state)&count=10"
        
        if let url = URL(string: urlString)
        {
            do {
                
                //get the data from the open-mateo weather application asynchronously. This
                //thread of execution is suspended (not blocked) until the thread finished
                let (data, _) = try await URLSession.shared.data(from: url)
                
                //this guard statement attempts to decode the data. If there is an error, the
                //else block is executed
                guard let results = try? JSONDecoder().decode(CityCodingResults.self, from: data) else
                {
                    self.hasError=true
                    self.error = CityModelError.decodeError
                    return
                }
                //Since the API call doesn't allow filtering, the filtering must be performed locally.
                //So, we're filtering based on the zipcode and/or state
                self.cities = results.results.filter{city in
                    (self.state.isEmpty || city.admin1 == self.state)
                }
                
                if self.cities.isEmpty {
                    self.hasError = true
                    self.error = CityModelError.decodeError
                }
            } catch{
                
                //If an error has occured anywhere in the do block, with the exception of the guard
                //block, this catch block will handle the error.
                self.hasError.toggle()
                self.error = CityModelError.customError(error: error)
            }
        }
        
    }
}
