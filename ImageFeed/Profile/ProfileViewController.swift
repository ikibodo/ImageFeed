//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by N L on 2.10.24..
//
import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView = UIImage()
    private var imageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1A1B22")
        drawProfile()
    }
    
    private func drawProfile() {
        let avatarImageView = UIImage(systemName: "person.crop.circle.fill")
        let imageView = UIImageView(image: avatarImageView)
        imageView.image = UIImage(named: "avatar")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = UIColor(hex: "#FFFFFF")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.textColor = UIColor(hex: "#AEAFB4")
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = UIColor(hex: "#FFFFFF")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        let logoutButton = UIButton.systemButton(with: UIImage(named: "exit")!,
                                                 target: self,
                                                 action: #selector(didTapLogoutButton))
        logoutButton.tintColor = UIColor(hex: "#F56B6C")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        // TODO: - Добавить логику при нажатии на кнопку exit
    }
}
