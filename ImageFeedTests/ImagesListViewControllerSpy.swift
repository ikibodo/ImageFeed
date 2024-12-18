//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by N L on 16.12.24..
//
import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListViewPresenterProtocol)?
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
    }
}
