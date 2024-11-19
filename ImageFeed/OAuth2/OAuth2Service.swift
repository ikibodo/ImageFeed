//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 25.10.24..
//
import Foundation
import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.accessToken))
                self?.oauth2TokenStorage.token = data.accessToken
            case .failure(let error):
                print("NL: Ошибка декодирования в OAuth2Service")
                completion(.failure(error))
            }
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    //  прошлый вариант - удалить как заработает новый
    //        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
    //            DispatchQueue.main.async {
    //                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
    //                    completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
    //                    return
    //                }
    //
    //                if let error {
    //                    completion(.failure(NetworkError.urlRequestError(error)))
    //                    return
    //                }
    //
    //                if let data {
    //                    do {
    //                        let decoder = JSONDecoder()
    //                        let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
    //                        completion(.success(response.accessToken))
    //                        self?.oauth2TokenStorage.token = response.accessToken
    //
    //                    } catch {
    //                        completion(.failure(NetworkError.noJSONDecoding))
    //                    }
    //                    return
    //                }
    //                self?.task = nil
    //                self?.lastCode = nil
    //            }
    //        }
    //        self.task = task
    //        task.resume()
    //    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(
            string: "https://unsplash.com"
            + "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code"
        ) else {
            print("NL: OAuthTokenRequest failed")
            return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
