//
//  CalculatorBuilder.swift
//  Calculator
//
//  Created by MSZ on 15/07/2021.
//

import Foundation

public class Calculator {
    
    private var numberStack: [Double] = []
    private var latestOperator: Operator?
    private let bitcoinUseCase: FetchBitcoinValueUseCase
    
    init(usecase: FetchBitcoinValueUseCase) {
        self.bitcoinUseCase = usecase
    }
    
    public func new(operaTor: Operator, completion: @escaping (Result<Double?,Error>) -> Void) {
        switch operaTor {
        case .cos:
            let degree = numberStack.popLast() ?? 0
            completion(.success(__cospi(degree/180.0)))
        case .sin:
            let degree = numberStack.popLast() ?? 0
            completion(.success(__sinpi(degree/180.0)))
        case .bitcoin:
            bitcoinUseCase.fetchBitcoinValu { [weak self] result in
                switch result {
                case .success(let response):
                    let number = self?.numberStack.popLast() ?? 0
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let rate = formatter.number(from: response.price.currency.rate)?.doubleValue ?? 0
                    let result = rate*number
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        default:
            guard numberStack.count >= 2, let latest = latestOperator else {
                self.latestOperator = operaTor
                completion(.success(nil))
                return
            }
            let right = numberStack.popLast() ?? 0
            let left = numberStack.popLast() ?? 0
            let result = self.calculate(left: left, right: right, operaTor: latest)
            self.numberStack.append(result)
            self.latestOperator = operaTor
            completion(.success(result))
        }
    }
    
    public func new(number: Double) {
        numberStack.append(number)
    }
    
    public func clear() {
        self.numberStack = []
        self.latestOperator = nil
    }
    
    public func fetchResult() -> Double? {
        guard numberStack.count >= 2, let latest = latestOperator else {
            return nil
        }
        
        let right = numberStack.popLast() ?? 0
        let left = numberStack.popLast() ?? 0
        let result = self.calculate(left: left, right: right, operaTor: latest)
        self.latestOperator = nil
        return result
    }
        
    private func calculate(left: Double, right: Double, operaTor: Operator) -> Double {
        switch operaTor {
        case .multiply:
            return left*right
        case .add:
            return left+right
        case .subtract:
            return left-right
        case .divide:
            return left/right
        default:
            return 0
        }
    }
    
}
