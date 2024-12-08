//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by N L on 12.11.24..
//
import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oauth2TokenStorage.token else {
            print("Ошибка: no token in fetchProfileImageURL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard lastToken != token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = profileImageRequest(token: token)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                guard let avatarURL = data.profileImage?.small else { return }
                self?.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL]
                )
            case .failure(let error):
                print("Ошибка декодирования в ProfileImageService\(error)")
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func profileImageRequest(token: String) -> URLRequest? {
        
        guard let userName = profileService.profile?.username else {
            print("Ошибка: profileImageRequest failed")
            return nil
        }
        
        guard let url = URL(
            string: "\(Constants.baseURL)"
            + "/users/\(userName)"
        )
        else {
            print("Ошибка: profileImageRequest URL failed")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension ProfileImageService {
    func cleanSession() {
        avatarURL = nil
        task = nil
    }
}
