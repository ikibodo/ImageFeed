//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 28.10.24..
//
import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private var splashImageView: UIImageView = {
        let splashImageView = UIImageView()
        splashImageView.image = UIImage(named: "splash_screen_logo")
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        return splashImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1A1B22")
        addSubViews()
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        OAuth2TokenStorage().clean() // для теста - удалить
        if let token = oauth2TokenStorage.token {
            //  switchToTabBarController()
            self.fetchProfile(token: token)
        } else {
           // performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
            guard let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    private func addSubViews() {
        view.addSubview(splashImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

//extension SplashViewController { // удалить после удаления сплэша из сториборда
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
//            guard
//                let navigationController = segue.destination as? UINavigationController,
//                let viewController = navigationController.viewControllers[0] as? AuthViewController
//            else {
//                assertionFailure("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
//                return
//            }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.fetchOAuthToken(code)
            }
            guard let token = self.oauth2TokenStorage.token else { return }
            self.fetchProfile(token: token)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success:
                self.switchToTabBarController()
            case.failure:
                print("NL: Ошибка в SplashViewController.fetchOAuthToken")
            }
        })
    }
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) {_ in }
                self.switchToTabBarController()
            case .failure:
                print("NL: Ошибка в SplashViewController.fetchProfile")
                break
            }
        }
    }
}
