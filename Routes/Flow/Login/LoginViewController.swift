//
//  LoginViewController.swift
//  Routes
//
//  Created by Ekaterina on 2.06.21.
//

import UIKit

class LoginViewController: UIViewController {

    private var loginView: LoginView {
        return self.view as! LoginView
    }
    
    private let userManager = UserManagerFactory().makeUserManager()
    
    var loginRouter: LoginRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginRouter = LoginRouter(vc: self)
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        loginView.registrationButton.addTarget(self, action: #selector(registrationButtonDidTap), for: .touchUpInside)
        loginView.rcoveryButton.addTarget(self, action: #selector(rcoveryButtonDidTap), for: .touchUpInside)
    }

    override func loadView() {
        self.view = LoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Metods
    
    @objc func loginButtonDidTap() {
    
        guard let login = loginView.loginTextField.text, let password = loginView.passwordTextField.text else {
            loginView.loginTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        guard !login.isEmpty else {
            loginView.loginTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        
        guard !password.isEmpty else {
            loginView.passwordTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        
        if userManager.validateUser(by: login, and: password) {
            UserDefaults.standard.setValue(true, forKey: "isLogin")
            loginRouter.toMapVc()
        } else {
            self.showAlert(title: "Autorisation error", message: "User not found")
        }
    }
    
    @objc func registrationButtonDidTap() {
        
        guard let login = loginView.loginTextField.text, let password = loginView.passwordTextField.text else {
            loginView.loginTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        guard !login.isEmpty else {
            loginView.loginTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        
        guard !password.isEmpty else {
            loginView.passwordTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        
        userManager.saveUser(with: login, password: password)
        showAlert(title: "Success", message: "")
    }
    
    @objc func rcoveryButtonDidTap() {
        loginRouter.toRecoveryVc()
    }
}

// MARK: - Alert

extension UIViewController {
    func showAlert(title : String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Router

final class LoginRouter: BaseRouter {
        
    func toMapVc() {
        let mapViewController = MapViewController()
        push(vc: mapViewController)
    }
    func toRecoveryVc() {
        let recoveryViewController = RecoveryViewController()
        present(vc: recoveryViewController)
    }
}
