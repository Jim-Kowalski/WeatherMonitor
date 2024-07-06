//
//  CurrentWeatherModel.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 7/6/24.
//

import Foundation
struct CurrentWeatherModel: Codable {
    let time: String
    let cloud_cover: Int
    let interval: Int
    let rain: Int
    let snowfall: Int
    let showers: Int
    let relative_humidity_2m: Int
    let temperature_2m: Double
    let wind_speed_10m: Double
}
