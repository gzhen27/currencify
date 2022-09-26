//
//  ConvertResult.swift
//  Currencify
//
//  Created by G Zhen on 9/23/22.
//
//  Convert Result JSON example:
//  {
//     "meta":
//         {
//             "code":200,
//             "disclaimer":"Usage subject to terms: https:\/\/currencyscoop.com\/terms"
//         },
//     "response":
//         {
//             "timestamp":1663976907,
//             "date":"2022-09-23",
//             "from":"USD",
//             "to":"JPY",
//             "amount":100,
//             "value":14337.729321
//         }
//  }
//

struct ConvertResult: Decodable {
    let response: ConvertResponse

    struct ConvertResponse: Decodable {
        let from: String
        let to: String
        let amount: Int
        let value: Double
        let date: String
        let timestamp: Int
    }
}
