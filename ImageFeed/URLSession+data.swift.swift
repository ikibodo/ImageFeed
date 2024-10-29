//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 27.10.24..
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case noJSONDecoding
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = try JSONDecoder().decode(Data.self, from: data)
                fulfillCompletionOnTheMainThread(.success(decoder))
            } catch {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.noJSONDecoding))
            }
        })
        task.resume()
        return task
    }
}
