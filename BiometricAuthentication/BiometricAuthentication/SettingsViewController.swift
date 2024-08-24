//
//  SettingsViewController.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/19/24.
//

import UIKit

class SettingsViewController: UIViewController {
  
  public var viewModel: SettingsViewModel?
  
  lazy var biometricToggleStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .equalSpacing
    stack.alignment = .center
    stack.addArrangedSubview({
      let label = UILabel()
      label.text = "Enable Biometric"
      label.textColor = .black
      label.backgroundColor = .white
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }())
    stack.addArrangedSubview({
      let toggle = UISwitch(frame: .zero)
      toggle.layer.cornerRadius = toggle.bounds.height / 2.0
      toggle.onTintColor = .systemMint
      toggle.backgroundColor = .systemGray
      toggle.addTarget(self, action: #selector(self.toggleBiometricSetting(_:)), for: .valueChanged)
      toggle.isOn = BiometricAuthManager.shared.isBiometricAuthEnabled
      toggle.translatesAutoresizingMaskIntoConstraints = false
      return toggle
    }())
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Account Settings"
    self.view.backgroundColor = .white
    
    self.view.addSubview(biometricToggleStack)
    NSLayoutConstraint.activate([
      biometricToggleStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
      biometricToggleStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      biometricToggleStack.heightAnchor.constraint(equalToConstant: 30),
      biometricToggleStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
      biometricToggleStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
    ])
  }
  
  @objc private func toggleBiometricSetting(_ switchTapped: UISwitch) {
    BiometricAuthManager.shared.setBiometricAuthKey(to: switchTapped.isOn)
  }
}
