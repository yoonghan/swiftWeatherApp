//
//  DetailViewController.swift
//  MyWeatherApp
//
//  Created by mmpkl05 on 12/1/16.
//  Copyright © 2016 iOS. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    var data:[String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherData = data!
        do {
            if let weather = weatherData["weather"] as? [[String: Any]]{
                let firstWeatherRecord = weather[0]
                let icon = firstWeatherRecord["icon"] as? String
                let url = URL(string: "http://openweathermap.org/img/w/\(icon!).png")
                let data = try Data(contentsOf: url!)
                weatherImage.image = UIImage(data: data)
                stateLabel.text = firstWeatherRecord["description"] as? String
                
            }
            
            
            let mainData = weatherData["main"] as! [String: Any]
            let formattedCel = String.init(format: "%.1f", mainData["temp"] as! Double)
            tempLabel.text = formattedCel + " celcius"
            humidityLabel.text = String(mainData["humidity"] as! Int)
            pressureLabel.text = String(mainData["pressure"] as! Double)
            
        }catch {
            print(error)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
