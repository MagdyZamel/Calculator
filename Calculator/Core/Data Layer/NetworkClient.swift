//
//  NetworkClient.swift
//  Calculator
//
//  Created by MSZ on 14/07/2021.
//

import Foundation
import Alamofire

protocol NetworkClient {
    ///  To hit the urlRequest over the internet and expected response will be string
    /// - important: The completion should be executed on the custom queue not the **Main**, so don't run UITask on it
    /// - parameter urlRequest: the URLRequest to be hitted
    /// - parameter completion: The completion  to call when when get the string or error.
    ///                          This completion **should be executed on the custom queue not the main**.
    /// - parameter result: Result of `Error` and `String` represents  the response

    func perform<T: Decodable>(_ outputType: T.Type, urlRequest: URLRequest,
                               completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkClientImp: NetworkClient {

    let internetManager: InternetManager

    init(internetManager: InternetManager) {
        self.internetManager = internetManager
    }

    func perform<T: Decodable>(_ outputType: T.Type, urlRequest: URLRequest,
                               completion: @escaping (Result<T, Error>) -> Void) {
        guard internetManager.isInternetConnectionAvailable() else {
            completion(.failure(NSError.Networking.noInternet))
            return
        }
        
        AF.request(urlRequest)
            .validate()
            .responseDecodable(of: T.self,
                               queue: DispatchQueue.global(qos: .utility),
                               completionHandler: { response in
                                switch response.result {
                                case .failure(let error):
                                    completion(.failure(error))
                                case .success(let data):
                                    completion(.success(data))
                                }
                               })
        
    }

}
