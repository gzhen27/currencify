//
//  CurrencyAPI.swift
//  Currencify
//
//  Created by G Zhen on 9/23/22.
//

import Foundation
import Combine

class CurrencyAPI {
    static var shared = CurrencyAPI()
    
    private let baseUrl = "https://api.currencyscoop.com/v1"
    private let convertPath = "/convert"
    private let latestPath = "/latest"
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let decoder = JSONDecoder()
    
//    var cancellable: AnyCancellable? = nil
    
    func getLatest(for currencyCode: String) -> AnyPublisher<LatestResult, Error> {
        guard let apiKey = Bundle.main.infoDictionary?["CURRENCY_API_KEY"] as? String else {
            return Fail(error: APIError.noApiKey).eraseToAnyPublisher()
        }
        
        var lastestUrlComponents = URLComponents(string: "\(baseUrl)\(latestPath)")
        let queryItemBase = URLQueryItem(name: "base", value: currencyCode)
        let queryItemAPIKey = URLQueryItem(name: "api_key", value: apiKey)
        lastestUrlComponents?.queryItems = [queryItemBase, queryItemAPIKey]
        
        if let url = lastestUrlComponents?.url {
            return session.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                        //TODO - handle api error later
                        throw APIError.serverError
                    }
                    return data
                }
                .decode(type: LatestResult.self, decoder: decoder)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        
    }
    
    func convert(to: String, from: String, amount: String) -> AnyPublisher<ConvertResult, Error> {
        guard let apiKey = Bundle.main.infoDictionary?["CURRENCY_API_KEY"] as? String else {
            return Fail(error: APIError.noApiKey).eraseToAnyPublisher()
        }

        var convertUrlComponents = URLComponents(string: "\(baseUrl)\(convertPath)")
        let queryItemTo = URLQueryItem(name: "to", value: to)
        let queryItemFrom = URLQueryItem(name: "from", value: from)
        let queryItemAmount = URLQueryItem(name: "amount", value: amount)
        let queryItemAPIKey = URLQueryItem(name: "api_key", value: apiKey)
        convertUrlComponents?.queryItems = [queryItemTo, queryItemFrom, queryItemAmount, queryItemAPIKey]
        
        if let url = convertUrlComponents?.url {
            return session.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                        //TODO - handle api error later
                        throw APIError.serverError
                    }
                    return data
                }
                .decode(type: ConvertResult.self, decoder: decoder)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
           return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
    }
}
