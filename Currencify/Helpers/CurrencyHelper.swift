//
//  CurrencyHelper.swift
//  Currencify
//
//  Created by G Zhen on 4/4/23.
//

import Foundation

enum CurrencyHelper {
    static func getCurrencyName(code: String) -> String {
        guard let currencyDetail = currencyDictionary[code] else { return "unknown" }
        return currencyDetail.currency_name
    }
    
    static func formatRate(code: String, rate: Double?) -> String {
        guard let rate = rate else { return "0.0" }
        guard let currencyDetail = currencyDictionary[code] else { return String(format: "%.2f", rate) }
        let decimalUnits = currencyDetail.decimal_units
    
        let decimalCount = "%.\(decimalUnits)f"
        return String(format: decimalCount, rate)
    }
}
