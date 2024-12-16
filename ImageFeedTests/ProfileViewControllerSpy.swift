//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by N L on 14.12.24..
//
import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfileViewPresenterProtocol)?
    
    func updateAvatar() {
    }
}
