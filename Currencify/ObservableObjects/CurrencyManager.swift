//
//  CurrencyManager.swift
//  Currencify
//
//  Created by G Zhen on 9/24/22.
//

import Combine

class CurrencyManager: ObservableObject {
    @Published var latestResponse: LatestResult.Response?
    @Published var currenciesReponse: [String : CurrenciesResult.Response.CurrencyDetail]?
    @Published var convertResponse: ConvertResult.Response?
    @Published var historicalResponse: HistoricalResult.Response?
    @Published var isPresentError: Bool = false
    var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    /**
     usage: currencyManager.getLatest(for: "USD")
     */
    func getLatest(for currencyCode: String) {
        CurrencyAPI.shared.getLatest(for: currencyCode)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    print("Get latest for \(currencyCode): \(completionStatus)")
                case .failure(let err):
                    self.setErrorStatus(with: err)
                }
            } receiveValue: { [unowned self] res in
                self.latestResponse = res
            }
            .store(in: &cancellables)
    }
    
    /**
     usage: currencyManager.getCurrencies(for: "fiat")
     */
//    func getCurrencies(for type: String = "fiat") {
//        CurrencyAPI.shared.getCurrencies(for: type)
//            .sink { completionStatus in
//                switch completionStatus {
//                case .finished:
//                    print("Get currencies: \(completionStatus)")
//                case .failure(let err):
//                    self.setErrorStatus(with: err)
//                }
//            } receiveValue: { [unowned self] res in
//                self.currenciesReponse = res
//            }
//            .store(in: &cancellables)
//    }
    
    /**
     usage: currencyManager.convert(to: "CNY", from: "USD", amount: "100")
     */
    func convert(to: String, from: String, amount: String) {
        CurrencyAPI.shared.convert(to: to, from: from, amount: amount)
            .sink { [unowned self] completionStatus in
                switch completionStatus {
                case .finished:
                    print("Converting currency: \(completionStatus)")
                case .failure(let err):
                    self.setErrorStatus(with: err)
                }
            } receiveValue: { [unowned self] res in
                self.convertResponse = res
            }
            .store(in: &cancellables)
    }
    
    /**
     currencyManager.getHistorical(for: "USD", at: "2022-08-16")
     */
    func getHistorical(for currencyCode: String, at date: String) {
        CurrencyAPI.shared.getHistorical(for: currencyCode, at: date)
            .sink { [unowned self] completionStatus in
                switch completionStatus {
                case .finished:
                    print("Get historical: \(completionStatus)")
                case .failure(let err):
                    self.setErrorStatus(with: err)
                }
            } receiveValue: { [unowned self] res in
                self.historicalResponse = res
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helper functions
    func clearErrorStatus() {
        isPresentError = false
        errorMessage = nil
    }

    private func setErrorStatus(with err: Error) {
        if let err = err as? APIError {
            switch err {
            case .noApiKey:
                //TODO - updates error message later
                self.errorMessage = err.localizedDescription
            case .invalidUrl:
                self.errorMessage = err.localizedDescription
            case .serverError:
                self.errorMessage = err.localizedDescription
            }
        } else {
            //TODO - need to handle the error to display a proper message
            self.errorMessage = err.localizedDescription
        }
        isPresentError = true
    }
    
    init() {
        print("Init message: loaded Currency Manager")
    }
    
    deinit {
        print("Deinit message: unloaded Currency Manager")
    }
}
