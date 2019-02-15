//
//  SelectALocationListTableViewController.swift
//  WeatherAppProject
//
//  Created by Avisa on 23/11/18.
//  Copyright © 2018 Avisa. All rights reserved.
//

import UIKit

class LocationListTableViewController: UITableViewController {
    
    
    //MARK:- Properties
    var cityBank = CityBank()
    
    //MARK:- View Contoller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- TableView DataSource and Deleagate Methods
extension LocationListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityBank.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationsCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let location = cityBank.lists[indexPath.row]
        cell.textLabel?.text = location.cityName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "SelectedCityIndex")
    }
}


extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}
