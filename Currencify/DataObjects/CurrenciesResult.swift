//
//  CurrenciesResult.swift
//  Currencify
//
//  Created by G Zhen on 9/26/22.
//
//{
//    "meta":{
//        "code":200,
//        "disclaimer":"Usage subject to terms: https:\/\/currencyscoop.com\/terms"
//    },
//    "response":{
//        "fiats":{
//            "USD":{
//                "currency_name":"United States dollar",
//                "currency_code":"USD",
//                "decimal_units":"2",
//                "countries":[
//                    "United States","American Samoa (AS)","Barbados (BB) (as well as Barbados Dollar)","Bermuda (BM) (as well as Bermudian Dollar)","British Indian Ocean Territory (IO) (also uses GBP)","British Virgin Islands (VG)","Caribbean Netherlands (BQ \u2013 Bonaire","Sint Eustatius and Saba)","Ecuador (EC)","El Salvador (SV)","Guam (GU)","Haiti (HT)","Marshall Islands (MH)","Federated States of Micronesia (FM)","Northern Mariana Islands (MP)","Palau (PW)","Panama (PA) (as well as Panamanian Balboa)","Puerto Rico (PR)","Timor-Leste (TL)","Turks and Caicos Islands (TC)","U.S. Virgin Islands (VI)","United States Minor Outlying Islands (UM)  Cambodia also uses the USD officially."
//                ]
//            }
//        }
//    }
//}
//
struct CurrenciesResult: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let fiats: [String : CurrencyDetail]
        
        struct CurrencyDetail: Decodable {
            let currency_name: String
            let currency_code: String
            let decimal_units: String
            let countries: [String]
        }
    }
}
