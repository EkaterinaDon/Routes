//
//  RecoveryViewController.swift
//  Routes
//
//  Created by Ekaterina on 3.06.21.
//

import UIKit

class RecoveryViewController: UIViewController {

    private var recoveryView: RecoveryView {
        return self.view as! RecoveryView
    }
    
    private let userManager = UserManagerFactory().makeUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recoveryView.getPasswordButton.addTarget(self, action: #selector(getPasswordButtonDidTap), for: .touchUpInside)
    }

    override func loadView() {
        self.view = RecoveryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Metods
    
    @objc func getPasswordButtonDidTap() {
        guard let login = recoveryView.loginTextField.text, !login.isEmpty else {
            recoveryView.loginTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return }
        
        
        if let password = userManager.getPassword(for: login) {
            showAlert(title: "Password:", message: password)
        } else {
            showAlert(title: "Error", message: "User not found")
        }
        
    }

}
