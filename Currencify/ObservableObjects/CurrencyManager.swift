//
//  CurrencyManager.swift
//  Currencify
//
//  Created by G Zhen on 9/24/22.
//

import Combine

class CurrencyManager: ObservableObject {
    @Published var latestResult: LatestResult?
    @Published var convertResult: ConvertResult?
    @Published var isPresentError: Bool = false
    var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getLatest(for currencyCode: String) {
        CurrencyAPI.shared.getLatest(for: currencyCode)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    print("Get latest for \(currencyCode): \(completionStatus)")
                case .failure(let err):
                    self.setErrorStatus(with: err)
                }
            } receiveValue: { [unowned self] result in
                self.latestResult = result
                print(latestResult?.response.rates ?? [:])
            }
            .store(in: &cancellables)
    }
    
    func convert(to: String, from: String, amount: String) {
        CurrencyAPI.shared.convert(to: to, from: from, amount: amount)
            .sink { [unowned self] completionStatus in
                switch completionStatus {
                case .finished:
                    print("Converting currency: \(completionStatus)")
                case .failure(let err):
                    self.setErrorStatus(with: err)
                }
            } receiveValue: { [unowned self] result in
                self.convertResult = result
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
}
