//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 16.12.24..
//
@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    func testCallsObserver() {
        let viewController =  ImagesListViewController()
        let presenter =  ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.imagesListObserver()
        
        XCTAssertTrue(presenter.imagesListObserverCalled)
    }
    
    func testCallsUpdateTableView() {
        let viewController =  ImagesListViewController()
        let presenter =  ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.updateTableView()
        
        XCTAssertTrue(presenter.updateTableViewCalled)
    }
}
