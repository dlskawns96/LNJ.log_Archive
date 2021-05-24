//
//  ViewController.swift
//  SampleWeatherApp
//
//  Created by Lee Nam Jun on 2021/05/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    
    var weather: Weather?
    var main: Main?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherService().getWeather { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weather = weatherResponse.weather.first
                    self.main = weatherResponse.main
                    self.name = weatherResponse.name
                    self.setWeatherUI()
                }
            case .failure(_ ):
                print("error")
            }
        }
    }
    
    private func setWeatherUI() {
        let url = URL(string: "https://openweathermap.org/img/wn/\(self.weather?.icon ?? "00")@2x.png")
        let data = try? Data(contentsOf: url!)
        if let data = data {
            iconImageView.image = UIImage(data: data)
        }
        tempLabel.text = "\(main!.temp)"
        maxTempLabel.text = "\(main!.temp_max)"
        minTempLabel.text = "\(main!.temp_min)"
    }
}

