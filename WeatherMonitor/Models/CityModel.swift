//
//  CityModel.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/29/24.
//

import Foundation

struct CityCodingResults: Codable {
    let results: [CityModel]
}

struct CityModel: Codable, Identifiable
{
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let elevation: Double?
    let feature_code: String?
    let country_code: String?
    let admin1: String?
    let admin2: String?
    let admin3: String?
    let admin4: String?
    let timezone: String?
    let population: Int?
    let postcodes: [String]?
}
