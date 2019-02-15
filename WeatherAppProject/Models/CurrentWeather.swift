//
//  CurrentWeatherDataModel.swift
//  WeatherAppProject
//
//  Created by Avisa on 7/1/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation
import UIKit


// Create Data Model for current weather forecast.

struct CurrentWeather: Codable {
    var currently: CurrentlyWeather
}

struct CurrentlyWeather: Codable {
    var time: Int?
    var summary: String?
    var icon: String?
    var temperature: Double?
    var windSpeed: Double?
    var windBearing: Int?
    
}
