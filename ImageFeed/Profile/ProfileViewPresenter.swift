//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 14.12.24..
//
import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func profileImageObserver()
    func profileImageURL() -> URL?
//    func profileDetails() -> Profile?
    func logoutProfile()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    let token = OAuth2TokenStorage().token
    
    func profileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateAvatar()
//                view?.updateProfileDetails()
            }
    }
    
    func profileImageURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
//    func profileDetails() -> Profile? {
//        guard let profile = profileService.profile else { return nil }
//        return profile
//    }
    
    func logoutProfile() {
        self.profileLogoutService.logout()
    }
}
