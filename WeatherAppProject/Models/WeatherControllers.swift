//
//  WeatherControllers.swift
//  WeatherAppProject
//
//  Created by Avisa on 23/11/18.
//  Copyright © 2018 Avisa. All rights reserved.
//

import Foundation
import UIKit

class WeatherControllers
{
    let baseURL =  URL(string: "https://api.darksky.net/de4899e4c91b98819673ef3f878f5c54")!
    static let shared = WeatherControllers()
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL = baseURL.appendingPathComponent("timezone")
        let task = URLSession.shared.dataTask(with: categoryURL) {
            (data, response, error) in
            if let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let categories = jsonDictionary?["timezone"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    
}















