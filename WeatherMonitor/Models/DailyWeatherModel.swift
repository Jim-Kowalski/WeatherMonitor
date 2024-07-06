//
//  DailyWeatherModel.swift
//  Assignment3
//
//  Created by James Kowalski on 6/7/24.
//

import Foundation
struct DailyWeatherModel: Codable {
    let time: [String]
    let weather_code: [Int]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let precipitation_probability_max: [Int]
    let sunrise: [String]
    let sunset: [String]
}
