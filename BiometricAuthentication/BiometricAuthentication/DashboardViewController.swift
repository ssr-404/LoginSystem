//
//  DashboardViewController.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/14/24.
//

import UIKit

class DashboardViewController: UIViewController {
  
  public var viewModel: DashboardViewModel?
  
  lazy var settingButton: UIButton = {
    let button = UIButton()
    button.setTitle("Settings", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .white
    button.addTarget(self, action: #selector(navigateToSettingsView), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var settingsView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .equalCentering
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.addArrangedSubview({
      let view = UIImageView()
      view.image = UIImage(systemName: "gearshape")
      return view
    }())
    stack.addArrangedSubview(settingButton)
    return stack
  }()
  
  lazy var signOutButton: UIButton = {
    let button = UIButton()
    button.setTitle("Sign Out", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .systemRed
    button.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Profile Dashboard"
    self.view.backgroundColor = .white
    
    self.addSubviews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = true
  }
  
  private func addSubviews() {
    self.view.addSubview(settingsView)
    NSLayoutConstraint.activate([
      settingsView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
      settingsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      settingsView.heightAnchor.constraint(equalToConstant: 30),
      settingsView.widthAnchor.constraint(equalToConstant: 90)
    ])
    
    self.view.addSubview(signOutButton)
    NSLayoutConstraint.activate([
      signOutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 200),
      signOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      signOutButton.heightAnchor.constraint(equalToConstant: 30),
      signOutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 170),
      signOutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -170)
    ])
  }
  
  @objc private func signOutButtonPressed(){
    DispatchQueue.main.async {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @objc private func navigateToSettingsView() {
    DispatchQueue.main.async {
      // TODO: 
    }
  }
}
