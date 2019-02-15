//
//  DayWeather.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 10/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation
import UIKit


// Create Data Model for 7-Days Forecast

struct DayWeather: Codable {
    var daily: Daily
}

struct Daily: Codable {
    var icon: String
    var summary: String
    var data: [DailyWeather]
}

struct DailyWeather: Codable {
    var time: Int?
    var summary: String?
    var icon: String?
    var temperatureHigh: Double?
    var temperatureLow: Double?
    var windSpeed: Double?
    var windBearing: Int?
}
