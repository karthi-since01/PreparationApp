//
//  GenericAPI.swift
//  preparationApp
//
//  Created by AIT MAC on 6/6/24.
//

import Foundation
import Alamofire

enum APIError: Error {
    case invalidResponse
    case requestFailed
}

class GenericAPI {
    
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    static func getRequest<T: Decodable>(url: URLConvertible, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping CompletionHandler<T>) {
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print(data)
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(APIError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func postRequest<T: Decodable>(url: URLConvertible, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping CompletionHandler<T>) {
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
