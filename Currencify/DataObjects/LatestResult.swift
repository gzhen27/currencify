//
//  LatestResult.swift
//  Currencify
//
//  Created by G Zhen on 9/24/22.
//
//{
//    "meta":{
//        "code":200,
//        "disclaimer":"Usage subject to terms: https:\/\/currencyscoop.com\/terms"
//    },
//
//    "response":{
//        "date":"2022-09-25T02:37:13Z",
//        "base":"USD",
//        "rates":
//            {
//                "CNY":7.10894185,
//                "JPY":143.37903518
//            }
//    }
//}

struct LatestResult: Decodable {
    let response: LatestResponse
    
    struct LatestResponse: Decodable {
        let date: String
        let base: String
        let rates: [String : Double]
    }
}
