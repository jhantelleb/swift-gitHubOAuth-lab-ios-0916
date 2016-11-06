//
//  LoginViewController.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Locksmith
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    var safariViewController = UIViewController()
    
    let numberOfOctocatImages = 10
    var octocatImages: [UIImage] = []
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpImageViewAnimation()
    
        NotificationCenter.default.addObserver( self, selector: #selector(safariLogin), name: .closeSafariVC, object: nil )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginImageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginImageView.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureButton()

    }
    
    // MARK: Set Up View
    
    private func configureButton() {
        
        imageBackgroundView.layer.cornerRadius = 0.5 * self.imageBackgroundView.bounds.size.width
        imageBackgroundView.clipsToBounds = true
    }
    
    private func setUpImageViewAnimation() {
        
        for index in 1...numberOfOctocatImages {
            if let image = UIImage(named: "octocat-\(index)") {
                octocatImages.append(image)
            }
        }
        
        loginImageView.animationImages = octocatImages
        loginImageView.animationDuration = 2.0
        
    }
    
    // MARK: Action
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // Safari View Controller
        safariViewController = SFSafariViewController(url: GitHubRequestType.oauth.url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func safariLogin(_ notification: Notification) {
        let url = notification.object as! URL
        
        GitHubAPIClient.request(.token(url: url)) { (json, _, error) in
            if error == nil {
                NotificationCenter.default.post(name: .closeLoginVC, object: nil)
            }
        }
        
        print(url)
        safariViewController.dismiss(animated: true, completion: nil)
    }

}







