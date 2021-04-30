//
//  ViewController.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 23.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let logoImage = UIImageView(image: UIImage(named: "StartScreen"))

    let enterButton = UIButton(backgroundColor: .geekRed(),
                               title: NSLocalizedString("enterButton", comment: ""),
                               font: .boldSystemFont(ofSize: 18),
                               shadow: true, titleColor: .white)
    
    let loadingImage = UIImageView(image: UIImage(named: "activityIndicator"))
    let loadingView = UIImageView(image: UIImage(named: "white"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initialize()
        setupButton()
    }
    
    private func setupButton() {
        enterButton.addTarget(self, action: #selector(goChat), for: .touchUpInside)
    }
    
    @objc func goChat(){
        let chatVC = TabBarController()
        let navigation = UINavigationController(rootViewController: chatVC)
        navigation.modalPresentationStyle = .fullScreen
        navigation.setNavigationBarHidden(true, animated: false)
        loadingView.isHidden = false
        loadingImage.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.present(navigation, animated: true) }
        
    }
    
    private func initialize(){
        view.addSubview(logoImage)
        logoImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        logoImage.layer.shadowRadius = CGFloat(4)
        logoImage.layer.shadowOpacity = Float(0.5)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.contentMode = .scaleAspectFit
        logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 132).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
        enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        view.addSubview(loadingView)
        loadingView.alpha = 0.4
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        loadingView.contentMode = .scaleToFill
        loadingView.frame.size = CGSize(width: 1000, height: 1000)
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.isHidden = true
        
        
        view.addSubview(loadingImage)
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        loadingImage.contentMode = .scaleAspectFit
        loadingImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingImage.rotate()
        loadingImage.isHidden = true
    }
}

