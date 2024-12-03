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
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = photosRequest(page: nextPage, perPage: 10)
        else {
            print("\(NetworkError.invalidRequest)")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                switch result {
                case .success(let data):
                    guard let self else { return }
                    let photo = data.map(self.updatePhoto)
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: photo)
                    }
//                    for data in data { // еще одно решение и тоже не работает
//                        self.photos.append(self.updatePhoto(data))
//                    }
//                    let photo = data.map {photoResult in // еще одно решение через инит и тоже не работает у меня
//                        Photo(photoResult: photoResult)}
//                    self.photos.append(contentsOf: photo)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
                    completion(.success(String(nextPage)))
                case .failure(let error):
                    print("NL: Ошибка декодирования в ImagesListService")
                    completion(.failure(error))
                }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }

    private func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let url = URL(
            string: "https://api.unsplash.com"
            + "/photos?page=\(page)"
            + "&per_page=\(perPage)"
        )
        else {
            print("NL: ImagesListService URL failed")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
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
