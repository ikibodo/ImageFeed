//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 1.10.24..
//


import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func prepareForReuse() {
            super.prepareForReuse()
            // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
        cellImage.image = UIImage(named: "photo_placeholder")
        }
}
