//
//  URL + Extensions.swift
//  iOS-rx-Weather
//
//  Created by Mavin on 1/21/21.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city),uk&appid=429b5536fe47d611b66365c34dc4bf3c")
    }
}
