//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 16.12.24..
//
import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var dateFormatter: DateFormatter = DateFormatter()
    
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    var imagesListObserverCalled: Bool = false
    var updateTableViewCalled: Bool = false
    
    func imagesListObserver() {
        imagesListObserverCalled = true
    }
    
    func updateTableView() {
        updateTableViewCalled = true
    }
}
