//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by N L on 30.11.24..
//
import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oauth2TokenStorage.token else {
            print("NL: no token in fetchProfileImageURL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard lastToken != token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        lastToken = token
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = photosRequest(token: token, page: nextPage)
        else {
            print("\(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
            switch result {
            case .success(let data):
                    self.photos.append(contentsOf: data.map(self.updatePhoto))
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                completion(.success(String(nextPage)))
            case .failure(let error):
                print("NL: Ошибка декодирования photo в ImagesListService")
                completion(.failure(error))
            }
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oauth2TokenStorage.token else {
            print("NL: no token in fetchProfileImageURL")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard lastToken != token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        lastToken = token
        task?.cancel()
        
        guard let request = likeRequest(token: token, photoId: photoId, httpMethod: isLike ? "POST" : "DELETE") else {
            print("\(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let data):
                guard let self else { return }
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                }
                completion(.success(()))
            case .failure(let error):
                print("NL: Ошибка декодирования likes в ImagesListService")
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func updatePhoto(_ updatePhoto: PhotoResult) -> Photo {
        return Photo.init(id: updatePhoto.id,
                          size: CGSize(width: updatePhoto.width, height: updatePhoto.height),
                          createdAt: ISO8601DateFormatter().date(from: updatePhoto.createdAt ?? ""),
                          welcomeDescription: updatePhoto.description,
                          thumbImageURL: updatePhoto.urls.thumb,
                          largeImageURL: updatePhoto.urls.full,
                          isLiked: updatePhoto.likedByUser)
    }
}

extension ImagesListService {
    private func photosRequest(token: String, page: Int) -> URLRequest? {
        guard let url = URL(
            string: "https://api.unsplash.com"
            + "/photos?page=\(page)"
        )
        else {
            print("NL: ImagesListService URL photo request failed")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func likeRequest(token: String, photoId: String, httpMethod: String) -> URLRequest? {
        guard let url = URL(
            string: "https://api.unsplash.com"
            + "/photos/\(photoId)/like"
        )
        else {
            print("NL: ImagesListService URL like request failed")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
