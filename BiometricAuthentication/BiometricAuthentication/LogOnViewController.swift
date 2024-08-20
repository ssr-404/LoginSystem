//
//  LogOnViewController.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/14/24.
//

import UIKit

class LogOnViewController: UIViewController {
  
  public var viewModel: LogonViewModel?
  
  lazy var usernameField: UITextField = {
    let label = "Email (default: testuser123)".localizedLowercase
    let textfield =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    textfield.placeholder = label
    textfield.font = UIFont.systemFont(ofSize: 15)
    textfield.borderStyle = UITextField.BorderStyle.roundedRect
    textfield.backgroundColor = .clear
    textfield.textColor = .black
    textfield.clearButtonMode = .whileEditing
    textfield.translatesAutoresizingMaskIntoConstraints = false
    return textfield
  }()
  
  lazy var passwordField: UITextField = {
    let label = "Password (default: testpwd123)".localizedLowercase
    let textfield =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    textfield.placeholder = label
    textfield.font = UIFont.systemFont(ofSize: 15)
    textfield.borderStyle = UITextField.BorderStyle.roundedRect
    textfield.backgroundColor = .clear
    textfield.textColor = .black
    textfield.clearButtonMode = .whileEditing
    textfield.translatesAutoresizingMaskIntoConstraints = false
    return textfield
  }()
  
  var biometricBtnImage: UIImage?
  
//  lazy var biometricBtnImage: UIImage = {
//    return UIImage(systemName: "touchid")
//  }()!
  
  lazy var biometricButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 30, y: 30, width: 50, height: 50))
    button.setImage(biometricBtnImage, for: .normal)
    button.addTarget(self, action: #selector(biometricButtonPressed), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var signInButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign In", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Login System"
    self.view.backgroundColor = .white
    
    //    if BiometricAuthManager.shared.isBiometricAuthEnabled {
    //      setUpBiometricImage()
    //    }
    setUpBiometricImage()
    addSubviews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func addSubviews() {
    self.view.addSubview(usernameField)
    NSLayoutConstraint.activate([
      usernameField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
      usernameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      usernameField.heightAnchor.constraint(equalToConstant: 30),
      usernameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
      usernameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
    ])
    
    self.view.addSubview(passwordField)
    NSLayoutConstraint.activate([
      passwordField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60),
      passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      passwordField.heightAnchor.constraint(equalToConstant: 30),
      passwordField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
      passwordField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
    ])
    
    self.view.addSubview(biometricButton)
    NSLayoutConstraint.activate([
      biometricButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20),
      biometricButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      biometricButton.heightAnchor.constraint(equalToConstant: 50),
      biometricButton.widthAnchor.constraint(equalToConstant: 50)
    ])
    
    self.view.addSubview(signInButton)
    NSLayoutConstraint.activate([
      signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 20),
      signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      signInButton.heightAnchor.constraint(equalToConstant: 40),
      signInButton.widthAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  private func setUpBiometricImage() {
    if BiometricAuthManager.shared.isBiometricAuthenticationAvailable() {
      switch BiometricAuthManager.shared.getBiometricType() {
      case .touchID:
        self.biometricBtnImage = UIImage(systemName: "touchid") ?? UIImage()
      case .faceID:
        self.biometricBtnImage = UIImage(systemName: "faceid") ?? UIImage()
      case .opticID:
        self.biometricBtnImage = UIImage(systemName: "opticid") ?? UIImage()
      default:
        self.biometricButton.isHidden = false
      }
    }
  }
  
  @objc private func loginButtonPressed() {
    self.viewModel?.navigateToDashboard()
  }
  
  @objc private func biometricButtonPressed() {
    
  }
}
