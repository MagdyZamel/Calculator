//
//  Errors.swift
//  Calculator
//
//  Created by MSZ on 14/07/2021.
//

import Foundation
extension Error {
    static var userMessageKey: String {"userMessage"}
    /// A user friendly message  form error on current app local.
    var message: String {
        let error = self as NSError
        return (error.userInfo[Self.userMessageKey]  as? String) ?? error.localizedDescription
    }
}

extension NSError {
    convenience init(domain: String,
                     code: Int = 1000,
                     message: String ) {
        self.init(domain: domain,
                  code: code,
                  userInfo: [NSError.userMessageKey: message])
    }

    struct Networking {
        static let noInternet = NSError(domain: "Networking",
                                        message: "Your mobile seems to be offline...")
    }
}
