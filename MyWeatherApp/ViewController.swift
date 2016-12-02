//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by mmpkl05 on 12/1/16.
//  Copyright © 2016 iOS. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var longitude:String?
    var latitude:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveLocation()
        loadWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveLocation() {
        let locationManager:CLLocationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        longitude = "\(locationManager.location?.coordinate.longitude)"
        latitude = "\(locationManager.location?.coordinate.latitude)"
        locationManager.stopUpdatingLocation()
    }

    func loadWeatherData() {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=8131be7e3e6b2014b3af931e011bd730")
        print(">>> \(url)")
        do {
            let data = try Data(contentsOf: url!)
            if let json:NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                print(json)
            }
        }
        catch {
            print(error)
        }
        
    }

}

