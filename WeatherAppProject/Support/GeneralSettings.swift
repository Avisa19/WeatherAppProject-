//
//  GeneralSettings.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 11/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation
import UIKit


// Create directory for saving favourite Action button.

class GeneralSettings {
    static var plistURL : URL {
        
        if let bundlePath = Bundle.main.path(forResource: "Settings", ofType: "plist"),
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .userDomainMask,
                                                               true).first {
            let fileName = "Settings.plist"
            let fullDestPath = URL(fileURLWithPath: destPath)
                .appendingPathComponent(fileName)
            let fullDestPathString = fullDestPath.path
            
            if FileManager.default.fileExists(atPath: fullDestPathString) == false {
                do {
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: fullDestPathString)
                } catch {
                    print(error)
                }
            }
        }
        
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent("Settings.plist")
    }
    
    static func savePropertyList(_ plist: Any) throws
    {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try plistData.write(to: plistURL)
    }
    
    
    static func loadPropertyList() throws -> [String : Any?]
    {
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String : Any] else {
            return [String : String]()
        }
        return plist
    }
}
