//
//  LoginViewController.swift
//  Routes
//
//  Created by Ekaterina on 2.06.21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    private var loginView: LoginView {
        return self.view as! LoginView
    }
    
    private let userManager = UserManagerFactory().makeUserManager()
    
    var loginRouter: LoginRouter!
    let bag = DisposeBag()
    let imageStorage = ImageStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginRouter = LoginRouter(vc: self)
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        loginView.registrationButton.addTarget(self, action: #selector(registrationButtonDidTap), for: .touchUpInside)
        loginView.rcoveryButton.addTarget(self, action: #selector(rcoveryButtonDidTap), for: .touchUpInside)
        loginView.selfieButton.addTarget(self, action: #selector(selfieButtonDidTap), for: .touchUpInside)
        
        configureLoginBindings()
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
    
    @objc func selfieButtonDidTap() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    func configureLoginBindings() {
        Observable
            .combineLatest(loginView.loginTextField.rx.text, loginView.passwordTextField.rx.text)
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 3
            }
            .bind { [weak self] inputFilled in
                self?.loginView.loginButton.isEnabled = inputFilled
                self?.loginView.loginButton.setTitleColor(inputFilled ? UIColor.black : UIColor.gray, for: .normal)
            }
            .disposed(by: bag)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) { [weak self] in
            guard let image = self?.extractImage(from: info) else  { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Error, image does not save", message: error.localizedDescription)
        } else {
            imageStorage.save(image: image)
            showAlert(title: "Success!", message: "Image saved to storage!")
        }
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
