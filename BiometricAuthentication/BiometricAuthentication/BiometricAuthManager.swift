//
//  BiometricAuthManager.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/15/24.
//

import UIKit
import LocalAuthentication

public enum BiometricAuthError: Error, Equatable {
  case userCancel
  case systemFailure
  case userFallback
}

class BiometricAuthManager {
  static let shared = BiometricAuthManager()
  
  // UserDefaults key for switching biometric state
  private let biometricKey = "biometricKey"
  private let context = LAContext()
  
  private init() {}
  
  public var isBiometricAuthEnabled: Bool { // If biometric is enabled in UserDefaults.
    return UserDefaults.standard.bool(forKey: self.biometricKey)
  }
  
  public func setBiometricAuthKey(to state: Bool) -> Void {
    UserDefaults.standard.set(state, forKey: self.biometricKey)
  }
  
  func isBiometricAuthenticationAvailable() -> Bool { // If the user's device enabled biometric.
    var error: NSError?
    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
      // TODO: Fall back to a asking for username and password
      return false
    }
    return true
  }
  
  func getBiometricType() -> LABiometryType {
    return context.biometryType
  }
  
  func authenticateWithBiometrics(completion: @escaping ( Result<Bool, BiometricAuthError> ) -> Void) {
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Authentication Login") { status, error in
      DispatchQueue.main.async { [status, error] in
        if status == true {
          completion(.success(status))
        } else {
          if let error = error as? LAError {
            switch error.code {
            case .userCancel: completion(.failure(.userCancel))
            case .systemCancel: completion(.failure(.systemFailure))
            case .userFallback: completion(.failure(.userFallback))
            default: break
            }
          }
        }
      }
    }
  }
  
  func showBiometricSettingsAlert(_ controller: UIViewController) {
    let alertController = UIAlertController(title: "Enable Face ID/Touch ID",
                                            message: "To use biometric authentication, you need to enable Face ID/Touch ID for this app in your device settings",
                                            preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(settingsAction)
    alertController.addAction(cancelAction)
    controller.present(alertController, animated: true, completion: nil)
  }
}
