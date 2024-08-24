//
//  LogonViewModel.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/19/24.
//

import Foundation

public enum LoginError: Error, Equatable {
  case wrongCredentials
  case systemFailure
  case biometricLoginFailure
}

class LogonViewModel: NSObject {
  
  private weak var coordinatorDelegate: LogonCoordinatorDelegate?
  
  init(coordiatorDelegate: LogonCoordinatorDelegate) {
    self.coordinatorDelegate = coordiatorDelegate
  }
  
  func proceedBiometricAuthentication() {
    BiometricAuthManager.shared.authenticateWithBiometrics(completion: { [self] result in
      switch result {
      case .success(let status):
        // TODO: proceed to login: KeychainManager.shared.retrieveLoginInfo() -> username, pwd, error in ...
        NSLog("Biometric is supported by user's device")
        KeychainManager.shared.retrieveLoginInfo() { [weak self] username, pwd, error in
          if let username = username, let pwd = pwd {
            self?.verifyCredentials(username: username, pwd: pwd, isBiometricLogin: true)
          } else if let error = error {
            self?.showSystemFailureAlert()
          }
        }
      case .failure(let error):
        // TODO: Show users that biometric authentication failed.
        self.showBiometricLoginFailureAlert()
        NSLog("Biometric Login Failed. ")
        return
      }
    })
  }
  
  func verifyCredentials(username: String, pwd: String, isBiometricLogin: Bool){
    // TODO: change the hard-coded stored credentials
    if username == "testuser123" && pwd == "testpwd123" {
      if !isBiometricLogin {
        NSLog("Biometric Login Succeeded. ")
        KeychainManager.shared.storeLoginInfo(username: username, password: pwd)
      } else {
        NSLog("Pwd Login Succeeded. ")
      }
      self.navigateToDashboard()
    } else {
      self.showWrongCrendentialAlert()
    }
  }
  
  func navigateToDashboard() {
    self.coordinatorDelegate?.coordinateToDashboardScreen()
  }
  
  func showWrongCrendentialAlert() {
    self.coordinatorDelegate?.popUpLoginFailedAlert(error: .wrongCredentials)
  }
  
  func showSystemFailureAlert() {
    self.coordinatorDelegate?.popUpLoginFailedAlert(error: .systemFailure)
  }
  
  func showBiometricLoginFailureAlert() {
    self.coordinatorDelegate?.popUpLoginFailedAlert(error: .biometricLoginFailure)
  }
}
