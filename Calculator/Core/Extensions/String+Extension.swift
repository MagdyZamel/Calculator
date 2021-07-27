//
//  String+Extension.swift
//  Calculator
//
//  Created by MSZ on 13/07/2021.
//

import Foundation
extension String {
    /// A localized value form Localizable base on current app local.
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
