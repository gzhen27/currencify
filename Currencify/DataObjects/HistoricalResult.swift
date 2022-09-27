//
//  HistoricalResult.swift
//  Currencify
//
//  Created by G Zhen on 9/27/22.
//
//{
//    "meta": {
//        "code":200,
//        "disclaimer":"Usage subject to terms:https:\/\/currencyscoop.com\/terms"
//    },
//    "response": {
//        "date":"2020-01-05",
//        "base":"USD",
//        "rates": {
//            "USD":1,
//            "EUR":0.89589911,
//            "GBP":0.76490082,
//            "INR":71.7839945,
//        }
//    }
//}

struct HistoricalResult: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let date: String
        let base: String
        let rates: [String : Double]
    }
}
