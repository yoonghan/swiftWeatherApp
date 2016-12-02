//
//  WeatherTableViewController.swift
//  MyWeatherApp
//
//  Created by mmpkl05 on 12/1/16.
//  Copyright © 2016 iOS. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var count:Int?
    var arrData = [[String:Any]]()
    var locationManager:CLLocationManager?
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let appId = "" //Add the correct appId
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveLocation()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let longitude = "\(locationManager!.location!.coordinate.longitude)"
        let latitude = "\(locationManager!.location!.coordinate.latitude)"
        loadWeatherData(longitude, latitude)
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func loadWeatherData(_ longitude:String, _ latitude:String) {
        let endpoint = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(appId)&units=metric")
        do {
            let data = try Data(contentsOf: endpoint!)
            if let json:NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                print(json)
                if let listOfData = json["list"] as? [[String: Any]] {
                    self.count = listOfData.count
                    arrData = listOfData
                }
                if let city = json["city"] as? [String:Any] {
                    locationLabel.text = city["name"] as? String
                }
            }
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CustomTableViewCell
        
        let weatherData = arrData[indexPath.row]
        do {
            if let weather = weatherData["weather"] as? [[String: Any]]{
                let firstWeatherRecord = weather[0]
                let icon = firstWeatherRecord["icon"] as? String
                let url = URL(string: "http://openweathermap.org/img/w/\(icon!).png")
                let data = try Data(contentsOf: url!)
                cell.weatherImage.image = UIImage(data: data)
                cell.weatherLabel.text = firstWeatherRecord["description"] as? String
            }
            
            let myFormatter = DateFormatter()
            myFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dateTime = "\(weatherData["dt_txt"] as! String) +0800"
            // Here's a date in the format specified by the string
            // assigned to dateFormat:
            let newDateFormat = DateFormatter()
            newDateFormat.dateStyle = .long
            newDateFormat.timeStyle = .long
            let toDate = myFormatter.date(from: dateTime)
            if let dateFormatted = toDate {
                cell.dateLabel.text = newDateFormat.string(from: dateFormatted)
            }
            let mainData = weatherData["main"] as! [String: Any]
            let formattedCel = String.init(format: "%.1f", mainData["temp"] as! Double)
            cell.tempLabel.text = formattedCel + " C"
            
            
        }catch {
            print(error)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailSegue" {
            let detailPage = segue.destination as! DetailViewController
            
            detailPage.data = arrData[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
 

}
