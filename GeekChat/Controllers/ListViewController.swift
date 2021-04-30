//
//  ListViewController.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 24.04.2021.
//

import UIKit

class ListViewController: UIViewController {
    let logoutButton = UIButton(backgroundColor: .geekRed(),
                               title: NSLocalizedString("logout", comment: ""),
                               font: .boldSystemFont(ofSize: 18),
                               shadow: true, titleColor: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("settings", comment: "")
        initialize()
    }
    
    private func initialize(){
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.heightAnchor.constraint(equalToConstant: 53).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        logoutButton.addTarget(self, action: #selector(goLogout), for: .touchUpInside)
        
    }
    
    @objc func goLogout(){
        let chatVC = ViewController()
        let navigation = UINavigationController(rootViewController: chatVC)
        navigation.modalPresentationStyle = .fullScreen
        navigation.setNavigationBarHidden(true, animated: false)
        present(navigation, animated: true)
        
    }
    
}
