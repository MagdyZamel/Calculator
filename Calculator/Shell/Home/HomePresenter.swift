//
//  HomePresenter.swift
//  Calculator
//
//  Created by MSZ on 15/07/2021.
//

import Foundation

protocol HomePresenter {
    func attach(view: HomeView)
    func operatorTapped(withValue value: String)
    func equalTapped()
    func numberTapped(withValue value: Int)
    func clearTapped()
}

class HomePresenterImp: HomePresenter {
    
    // MARK: - Variables
    private weak var view: HomeView!
    private var calculator: Calculator!
    private var cachedNumber: String = ""
    private var latestResult: Double? = 0
    private var operators: [(value: String, isEnabled: Bool)] = [
        (Operator.sin.rawValue, true),
        (Operator.cos.rawValue, true),
        (Operator.multiply.rawValue, true),
        (Operator.divide.rawValue, true),
        (Operator.subtract.rawValue, true),
        (Operator.add.rawValue, true),
        (Operator.bitcoin.rawValue, true)
    ]
    
    // MARK: - Lifecycle
    init(calculator: Calculator) {
        self.calculator = calculator
    }

    // MARK: - HomePresenter methods
    func attach(view: HomeView) {
        self.view = view
        self.viewDidAttach()
    }
    
    // MARK: - Private methods
    private func viewDidAttach() {
        self.view.configureUI(operators: operators)
        self.view.display(result: "0")
    }
    
    /// try to add new number to the calculator builder
    private func addOnDisplayNumber() {
        // Check if there are a cached number to add to the calculator builder
        if let number = Double(cachedNumber) {
            self.calculator.new(number: number)
        }
        // If there are no number already cached send the latest result on the screen
        else if let number = latestResult {
            self.calculator.new(number: number)
        }
        // If there are no numbers cached anywhere
        // thats mean the user try to click on the operators more than on time sequentially
        // so i will not add any number to the builder
    }
}

// MARK: - View To Presenter
extension HomePresenterImp {
    func operatorTapped(withValue value: String) {
        guard let operaTor = Operator(rawValue: value) else {
            // It will never happen because we use the same operators of the enum to build the UI
            fatalError("You are using non existing operator")
        }
        
        self.addOnDisplayNumber()
        self.view.showLoader()
        calculator.new(operaTor: operaTor) { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .success(let result):
                let strResult = result.map { String(format: "%.0f", $0) }
                self.view.display(result: strResult)
                self.latestResult = result
                self.cachedNumber = ""
                self.view.hideLoader()
            case .failure(let error):
                self.latestResult = nil
                self.cachedNumber = ""
                self.view.showErrorAlert(withMessage: error.message)
                self.view.display(result: "0")
                self.view.hideLoader()
            }
        }
    }
    func equalTapped() {
        self.addOnDisplayNumber()
        let result = self.calculator.fetchResult()
        let strResult = result.map { String(format: "%.0f", $0) }
        self.view.display(result: strResult)
        self.latestResult = result
        self.cachedNumber = ""
    }
    func numberTapped(withValue value: Int) {
        self.latestResult = nil
        self.cachedNumber.append("\(value)")
        self.view.display(result: cachedNumber)
    }
    func clearTapped() {
        self.cachedNumber = ""
        self.latestResult = 0
        self.view.display(result: "0")
        self.calculator.clear()
    }
}
