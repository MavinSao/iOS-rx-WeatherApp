//
//  ViewController.swift
//  iOS-rx-Weather
//
//  Created by Mavin on 1/21/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map{self.cityNameTextField.text}
            .subscribe(onNext: { [weak self] city in
                if let city = city {
                    if city.isEmpty {
                        self?.displayWeather(weather: nil)
                    }else{
                        self?.fetchWeather(by: city)
                    }
                    
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func fetchWeather(by cityName: String) {
        
        //addingPercentEncoding : add percentage for spacing
        
        guard let cityEncoded = cityName.addingPercentEncoding(withAllowedCharacters:   .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else {return}
            
        //Create Resource
        let resource = Resource<WeatherResult>(url: url)
        
        let search = URLRequest.load(reource: resource)
            .catchAndReturn(WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℉" }
            .bind(to: self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💦" }
            .bind(to: self.humidityLabel.rx.text)
            .disposed(by: disposeBag)

        
    }
    
    func displayWeather(weather: Weather?){
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        }else{
            self.temperatureLabel.text = "😒"
            self.humidityLabel.text = "🙅"
        }
        
        
    }
    
    
    


}

