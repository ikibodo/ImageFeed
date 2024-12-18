//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by N L on 14.12.24..
//
import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var profileImageObserverCalled: Bool = false
    var logoutProfileCalled: Bool = false
    var profileImageURLCalled: Bool = false
    
    func profileImageObserver() {
        profileImageObserverCalled = true
        return
    }
    
    func logoutProfile() {
        logoutProfileCalled = true
    }
    
    func profileImageURL() -> URL? {
        profileImageURLCalled = true
        return nil
    }
}
