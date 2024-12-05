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
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = profileRequest(token: token)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                let profile = Profile(profileResult: data)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("Ошибка декодирования в ProfileService\(error)")
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func profileRequest(token: String) -> URLRequest? {
        guard let url = URL(
            string: "https://api.unsplash.com"
            + "/me"
        )
        else {
            print("Ошибка: profileRequest failed")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
