//
//  File.swift
//  Calculator
//
//  Created by MSZ on 15/07/2021.
//

import Foundation

extension URLRequest {
    static var bitcoinPriceIndexRequest: URLRequest {
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice/CNY.json")!
        return URLRequest(url: url)
    }
}
