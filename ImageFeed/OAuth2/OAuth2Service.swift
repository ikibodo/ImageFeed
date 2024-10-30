//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 25.10.24..
//
import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    init() {}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let request = makeOAuthTokenRequest(code: code) else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            
            if let error {
                completion(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))//  далее передаем аксесс токен, который сохраняем в Storage и отправляем по навигации пользователя в ленты с фотографиями:
                    OAuth2TokenStorage().token = response.accessToken
                } catch {
                    completion(.failure(NetworkError.noJSONDecoding))
                }
                return }
        }
        task.resume()
    }
    
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
            print("OAuthTokenRequest failed")
            return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
