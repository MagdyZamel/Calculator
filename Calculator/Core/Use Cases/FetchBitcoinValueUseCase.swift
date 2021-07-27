//
//  FetchBitcoinValueUseCase.swift
//  Calculator
//
//  Created by MSZ on 18/07/2021.
//

import Foundation
protocol FetchBitcoinValueUseCase {
    /// Fetch the  text content find every 10th character (i.e. 10th, 20th, 30th, etc.)
    /// - important: The completion should be executed on the custom queue not the **Main**, so don't run UITask on it
    /// - parameter completion: The completion  to call when when get the data or error.
    ///                          This completion **should be executed on the custom queue not the main**.
    ///  - parameter result: Result of  `Error` and `BitcoinResponse`  struct  represents  the data
    func fetchBitcoinValu(completion: @escaping (_ result: Result<BitcoinResponse, Error>) -> Void)

}

class FetchBitcoinValueUseCaseImp: FetchBitcoinValueUseCase {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchBitcoinValu(completion: @escaping (Result<BitcoinResponse, Error>) -> Void) {
        fetchBitcoinPrice { result in
            switch result {
            case .success(let reponse):
                completion(.success(reponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchBitcoinPrice(completion: @escaping (Result<BitcoinResponse, Error>) -> Void) {
        networkClient.perform(BitcoinResponse.self, urlRequest: .bitcoinPriceIndexRequest) { result in
            // this line to make sure that  the completion not run on ui tread ever,
            // i know the networkClient not run it on the main queue, but i added this line to avoid any further faults,
            // **More Declaration** i discovered this when i mocked the networkClient. i run the completion of MocknetworkClient on main thread
            DispatchQueue.global(qos: .utility).async { completion(result) }
        }
    }
}
