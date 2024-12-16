//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 14.12.24..
//
@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testCallsObserver() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.profileImageObserver()
        
        XCTAssertTrue(presenter.profileImageObserverCalled)
    }
    
    func testCallsProfileImageURL() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.profileImageURL()
        
        XCTAssertTrue(presenter.profileImageURLCalled)
    }
    
    func testCallsLogoutProfile() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.logoutProfile()
        
        XCTAssertTrue(presenter.logoutProfileCalled)
    }
    
}
