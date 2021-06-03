//
//  RecoveryView.swift
//  Routes
//
//  Created by Ekaterina on 3.06.21.
//

import UIKit

class RecoveryView: UIView {

    // MARK: - Subviews
    
    private(set) lazy var nameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .black
        textLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        textLabel.text = "Password recovery"
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    private(set) lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15.0)
        textField.placeholder = "Login"
        return textField
    }()
    
    private(set) lazy var getPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get password", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12.0)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(self.nameLabel)
        self.addSubview(self.loginTextField)
        self.addSubview(self.getPasswordButton)
        
        setupConstraints()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30.0),
            self.nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.nameLabel.widthAnchor.constraint(equalToConstant: 300.0),
            
            self.loginTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 300.0),
            self.loginTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5.0),
            self.loginTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5.0),
            
            
            self.getPasswordButton.topAnchor.constraint(equalTo: self.loginTextField.bottomAnchor, constant: 50.0),
            self.getPasswordButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.getPasswordButton.widthAnchor.constraint(equalToConstant: 150.0)
            ])
    }

}
