//
//  BitcoinResponse.swift
//  Calculator
//
//  Created by MSZ on 18/07/2021.
//

import Foundation

struct BitcoinResponse: Decodable {
    var price: PriceResponse
    
    enum CodingKeys: String, CodingKey {
        case price = "bpi"
    }
}

struct PriceResponse: Decodable {
    var currency: Currency
    
    enum CodingKeys: String, CodingKey {
        case currency = "USD"
    }
}

struct Currency: Decodable {
    var code: String
    var rate: String
}
