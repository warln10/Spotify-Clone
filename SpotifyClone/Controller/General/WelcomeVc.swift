//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import UIKit

class WelcomeVc: UIViewController {
    
    private let signInBtn: UIButton = {
        let Button = UIButton()
        Button.layer.cornerRadius = 5
        Button.clipsToBounds = true
        Button.setTitle("Sign in", for: .normal)
        Button.backgroundColor = .systemGreen
        Button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return Button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Spotify"
        signInBtn.addTarget(self, action: #selector(SignInButtonDidTap), for: .touchUpInside)
        view.addSubview(signInBtn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInBtn.frame = CGRect(x: 20, y: view.bottom-50-view.safeAreaInsets.bottom, width: view.width-40, height: 50)
    }
    
    @objc
    func SignInButtonDidTap(){
        let vc = AuthVC()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSign(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func handleSign(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something Went wrong while sign in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let vc = TabBarVc()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }


}

