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
    private let apiKey: String? = Bundle.main.infoDictionary?["CURRENCY_API_KEY"] as? String
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let decoder = JSONDecoder()
    
    func getLatest(for currencyCode: String) -> AnyPublisher<LatestResult.Response, Error> {
        guard let apiKey = apiKey else {
            return Fail(error: APIError.noApiKey).eraseToAnyPublisher()
        }
        
        if let url = getLatestEndpoint(for: currencyCode, apiKey: apiKey) {
            return session.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                        //TODO - handle api error later
                        throw APIError.serverError
                    }
                    return data
                }
                .decode(type: LatestResult.self, decoder: decoder)
                .map(\.response)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
    }
    
    func getCurrencies(for type: String) -> AnyPublisher<[String: CurrenciesResult.Response.CurrencyDetail], Error> {
        guard let apiKey = apiKey else {
            return Fail(error: APIError.noApiKey).eraseToAnyPublisher()
        }
        
        if let url = getCurrenciesEndpoints(for: type, apiKey: apiKey) {
            return session.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                        //TODO - handle api error later
                        throw APIError.serverError
                    }
                    return data
                }
                .decode(type: CurrenciesResult.self, decoder: decoder)
                .map(\.response.fiats)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
    }
    
    func convert(to: String, from: String, amount: String) -> AnyPublisher<ConvertResult.Response, Error> {
        guard let apiKey = apiKey else {
            return Fail(error: APIError.noApiKey).eraseToAnyPublisher()
        }
        
        if let url = getConvertEndpoint(to: to, from: from, amount: amount, apikey: apiKey) {
            return session.dataTaskPublisher(for: url)
                .tryMap { (data: Data, response: URLResponse) in
                    if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                        //TODO - handle api error later
                        throw APIError.serverError
                    }
                    return data
                }
                .decode(type: ConvertResult.self, decoder: decoder)
                .map(\.response)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
           return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
    }
    
    // MARK: Helper functions
    private func getLatestEndpoint(for currencyCode: String, apiKey: String) -> URL? {
        let path = "/latest"
        var lastestUrlComponents = URLComponents(string: "\(baseUrl)\(path)")
        let queryItemBase = URLQueryItem(name: "base", value: currencyCode)
        let queryItemAPIKey = URLQueryItem(name: "api_key", value: apiKey)
        lastestUrlComponents?.queryItems = [queryItemBase, queryItemAPIKey]
        
        return lastestUrlComponents?.url
    }
    
    private func getCurrenciesEndpoints(for type: String, apiKey: String) -> URL? {
        let path = "/currencies"
        var currenciesUrlComponents = URLComponents(string: "\(baseUrl)\(path)")
        let queryItemCurrencyType = URLQueryItem(name: "type", value: type)
        let queryitemAPIKey = URLQueryItem(name: "api_key", value: apiKey)
        currenciesUrlComponents?.queryItems = [queryItemCurrencyType, queryitemAPIKey]
        
        return currenciesUrlComponents?.url
    }
    
    private func getConvertEndpoint(to: String, from: String, amount: String, apikey: String) -> URL? {
        let path = "/convert"
        var convertUrlComponents = URLComponents(string: "\(baseUrl)\(path)")
        let queryItemTo = URLQueryItem(name: "to", value: to)
        let queryItemFrom = URLQueryItem(name: "from", value: from)
        let queryItemAmount = URLQueryItem(name: "amount", value: amount)
        let queryItemAPIKey = URLQueryItem(name: "api_key", value: apiKey)
        convertUrlComponents?.queryItems = [queryItemTo, queryItemFrom, queryItemAmount, queryItemAPIKey]
        
        return convertUrlComponents?.url
    }
}
