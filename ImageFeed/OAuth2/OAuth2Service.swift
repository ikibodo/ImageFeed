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
    
    private var authToken: String? {
        get { return OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let request = makeOAuthTokenRequest(code: code) else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            } else {
                completion(.failure(NetworkError.urlSessionError))
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                completion(.success(response.accessToken))//  далее передаем аксесс токен, который сохраняем в Storage и отправляем по навигации пользователя в ленты с фотографиями:
                authToken.token = response.accessToken
            } catch {
                completion(.failure(NetworkError.noJSONDecoding))
            }
            task.resume()
        }
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
