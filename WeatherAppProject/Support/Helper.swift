//
//  Helper.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 10/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation

func getStringDate(timeStamp: TimeInterval) -> String? {
    let date = Date(timeIntervalSince1970: timeStamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter.string(from: date)
}
