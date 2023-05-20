//
//  HttpClient.swift
//  CatsAPITest
//
//  Created by Higashikata Maverick on 17/5/23.
//

import Foundation
import UIKit

enum HttpResult<T, S> {
    case success(T)
    case failure(S)
}

class HttpClient<T: Codable> {
    
    func getData(from url: String, completionHandler: @escaping (HttpResult<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { data, response, errorMessages in
            if case .some(let someError) = errorMessages { completionHandler(.failure(someError)) }
            
            guard let responseData = data else { return completionHandler(.failure(NSError(domain: "something went wrong on starwars API", code: 404))) }
            
            let decoder = JSONDecoder()
            
            do {
                let responseModel = try decoder.decode(T.self, from: responseData)
                completionHandler(.success(responseModel))
            } catch {
                print(error.localizedDescription)
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
    
}

class HttpImageDataClient {
    
    @MainActor
    func getData(from url: String, completionHandler: @escaping (HttpResult<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            if case .some(let someError) = error {
                completionHandler(.failure(someError))
            }
            
            guard let imageData = data else { return completionHandler(.failure(NSError(domain: "Something went wrong with the image fetch", code: 404))) }
            
            if let image = UIImage(data: imageData) {
                completionHandler(.success(image))
            } else {
                completionHandler(.failure(NSError(domain: "Something went wrong", code: 404)))
            }
            
        }
        
        task.resume()
    }
    
}
