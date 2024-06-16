//
//  HoulyWeatherModel.swift
//  Assignment3
//
//  Created by James Kowalski on 6/7/24.
//

import Foundation
struct HourlyWeatherModel: Codable {
    let time: [String]
    let temperature_2m: [Double]
    let precipitation_probability: [Int]
    let weather_code: [Int]
}




