//
//  CurrentViewController.swift
//  WeatherAppProject
//
//  Created by Avisa on 7/1/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    //MARK:- Interface Builder
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var windDirectLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK:- Properties
    var fetchedweather = CurrentlyWeather()
    var selectedCityId: Int?
    var cityBank = CityBank()
    var isFavourite = false
    var isOpenFromFavourite: Bool?
    var settingsDic: [String: Any]?
    
    //MARK:- View Contoller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteButton.isHidden = true
        self.selectedCityId = UserDefaults.standard.integer(forKey: "SelectedCityIndex")
        
        do {
            let settings = try GeneralSettings.loadPropertyList()
            if settings["isFavouritedAny"] != nil {
                let forecastId = settings["ForecastId"] as! Int
                let cityId = settings["CityId"] as! Int
                if isOpenFromFavourite == true {
                    let cityId = settings["CityId"] as! Int
                    self.selectedCityId = cityId
                    self.styleFavouriteButton()
                } else {
                    if cityId == self.selectedCityId! && forecastId == 0 {
                        self.selectedCityId = cityId
                        self.styleFavouriteButton()
                    } else  {
                        self.styleUnFavouriteButton()
                    }
                }
                
                
            } else {
                self.styleUnFavouriteButton()
            }
        } catch {
            print(error)
        }
        
       fetchCurrentWeatherFromServer()
    }
    
    //fetch the weather from the server
    func fetchCurrentWeatherFromServer() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkServices.fetchCurrentWeather(latitude: self.cityBank.lists[selectedCityId!].latitude, longitude:  self.cityBank.lists[selectedCityId!].longitude, completion: { (result) in
            switch result {
            case .success(let weather):
                self.favouriteButton.isHidden = false
                self.fetchedweather = weather.currently
                self.cityNameLabel.text = self.cityBank.lists[self.selectedCityId!].cityName
                if let temp = self.fetchedweather.temperature {
                    self.temperatureLabel.text = "\(Int(temp))ºC"
                }
                
                guard let type = self.fetchedweather.summary else { fatalError() }
                    self.weatherTypeLabel.text = "\(type)"
                
                
                if let time = self.fetchedweather.time {
                    self.timeLabel.text = getStringDate(timeStamp: TimeInterval(time))
                }
                
                if let direction = self.fetchedweather.windBearing {
                    self.windDirectLabel.text = "Wind Direction: \(Int(direction))°"
                }
                
                if let speed = self.fetchedweather.windSpeed {
                    self.windSpeedLabel.text = "Wind Speed: \(Int(speed))km/hr"
                }
                
                if let icon = self.fetchedweather.icon {
                    self.weatherTypeImageView.image = UIImage(named: icon)
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(_):
                print("Something went wrong!")
            }
        })
    }
    //MARK: ******************Style favourite Button *************

    func styleFavouriteButton() {
        UIView.animate(withDuration: 1.5)
        {
        self.favouriteButton.backgroundColor = UIColor.blue
        self.favouriteButton.setTitleColor(.white, for: .normal)
        self.favouriteButton.setTitle("Unfavourite", for: .normal)
        self.isFavourite = true
        }
    }
    
    func styleUnFavouriteButton() {
        UIView.animate(withDuration: 1.5)
        {
        self.favouriteButton.backgroundColor = UIColor.white
        self.favouriteButton.setTitleColor(.blue, for: .normal)
        self.favouriteButton.setTitle("Favourite", for: .normal)
        self.isFavourite = false
        }
    }
    
}
/*****************************************************************/
//MARK:- Button Actions
extension CurrentWeatherViewController {
    @IBAction func favouriteButtonPressed() {
        if self.isFavourite == false {
            self.styleFavouriteButton()
            do {
                var dictionary = try GeneralSettings.loadPropertyList()
                dictionary.updateValue(true, forKey: "isFavouritedAny")
                dictionary.updateValue(0, forKey: "ForecastId")
                dictionary.updateValue(self.selectedCityId, forKey: "CityId")
                
                try GeneralSettings.savePropertyList(dictionary)
            } catch {
                print(error)
            }
        } else if self.isFavourite == true {
            do {
                var dictionary = try GeneralSettings.loadPropertyList()
                dictionary.updateValue(false, forKey: "isFavouritedAny")
                dictionary.updateValue(-1, forKey: "ForecastId")
                dictionary.updateValue(-1, forKey: "CityId")
                try GeneralSettings.savePropertyList(dictionary)
            } catch {
                print(error)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
