//
//  LogOnViewController.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/14/24.
//

import UIKit

class LogOnViewController: UIViewController {
  
  public var viewModel: LogonViewModel?
  var biometricBtnImage: UIImage?
  
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
    
    if BiometricAuthManager.shared.isBiometricAuthEnabled {
      setUpBiometricImage()
    }
    addSubviews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if BiometricAuthManager.shared.isBiometricAuthEnabled {
      setUpBiometricImage()
    } else {
      self.biometricButton.isHidden = true
    }
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
        self.biometricButton.isHidden = false
      case .faceID:
        self.biometricBtnImage = UIImage(systemName: "faceid") ?? UIImage()
        self.biometricButton.isHidden = false
      case .opticID:
        self.biometricBtnImage = UIImage(systemName: "opticid") ?? UIImage()
        self.biometricButton.isHidden = false
      default:
        self.biometricButton.isHidden = true
      }
    }
  }
  
  @objc private func loginButtonPressed() {
    guard let username = usernameField.text,
          let pwd = passwordField.text else {
      // TODO: Add Alert to handle non username or pwd scenarios.
      return
    }
    if usernameField.text?.isEmpty == true || passwordField.text?.isEmpty == true {
      // TODO: Add Alert to handle empty username or pwd scenarios.
      return
    }
    self.viewModel?.verifyCredentials(username: username, pwd: pwd, isBiometricLogin: false)
//    self.viewModel?.navigateToDashboard()
  }
  
  @objc private func biometricButtonPressed() {
    if BiometricAuthManager.shared.isBiometricAuthenticationAvailable() {
      self.viewModel?.proceedBiometricAuthentication()
    } else {
      // This would happen only when: user device turned Biometric from on to off after user is already on the login screen.
      // Show user alert that Biometric setting is not enabled in this app. Guide the user to the device settings.
      BiometricAuthManager.shared.showBiometricSettingsAlert(self)
    }
  }
}
