//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 10.11.24..
//
import Foundation
import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = profilRequest(token: token)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
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
                        let response = try decoder.decode(ProfileResult.self, from: data)
                        let profile = Profile(profileResult: response)
                        self?.profile = profile
                        completion(.success(profile))
                    } catch {
                        completion(.failure(NetworkError.noJSONDecoding))
                    }
                    return
                }
                self?.task = nil
                self?.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func profilRequest(token: String) -> URLRequest? {
        guard let url = URL(
            string: "https://api.unsplash.com"
            + "/me"
        )
        else {
            print("NL: profilRequest failed")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
