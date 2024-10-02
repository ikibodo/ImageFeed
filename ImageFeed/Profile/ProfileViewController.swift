//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by N L on 2.10.24..
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
}
