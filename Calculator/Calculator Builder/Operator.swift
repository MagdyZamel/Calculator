//
//  Operator.swift
//  Calculator
//
//  Created by MSZ on 16/07/2021.
//

import Foundation

public enum Operator: String {
    
    case add = "+"
    case subtract = "−"
    case divide = "÷"
    case multiply = "×"
    case sin = "sin"
    case cos = "cos"
    case bitcoin = "₿"
    case equal = "="
    
    public var precedence: Int {
        switch self {
        case .add, .subtract:
            return 0
        case .divide, .multiply:
            return 5
        case .sin, .cos, .bitcoin:
            return 10
        case .equal:
            return 15
        }
    }
}
