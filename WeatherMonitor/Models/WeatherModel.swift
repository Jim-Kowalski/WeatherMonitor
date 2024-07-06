//
//  WeatherModel.swift
//  Assignment3
//
//  Created by James Kowalski on 6/7/24.
//

import Foundation
struct WeatherModel: Codable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let current_units: CurrentWeatherUnits
    let current: CurrentWeatherModel
    let hourly_units: HourlyUnits
    let hourly: HourlyWeatherModel
    let daily_units: DailyUnits
    let daily: DailyWeatherModel
}
struct CurrentWeatherUnits: Codable
{
    let time: String
    let interval: String
    let temperature_2m: String
}

struct HourlyUnits: Codable {
    let time: String
    let temperature_2m: String
    let precipitation_probability: String
    let weather_code: String
}

struct DailyUnits: Codable {
    let time: String
    let weather_code: String
    let temperature_2m_max: String
    let temperature_2m_min: String
    let precipitation_probability_max: String
}
