//
//  URLRequest+Extensions.swift
//  iOS-rx-Weather
//
//  Created by Mavin on 1/21/21.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    static func load<T: Decodable>(reource: Resource<T>) -> Observable<T> {
        return Observable.from([reource.url])
            .flatMap { (url) -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }
            .map { (data) -> T in
               return try JSONDecoder().decode(T.self, from: data)
            }
            .asObservable()
    }
}
