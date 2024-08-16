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
  
  public var isBiometricAuthEnabled: Bool {
    return UserDefaults.standard.bool(forKey: self.biometricKey)
  }
  
  public func setBiometricAuthKey(to state: Bool) -> Void {
    UserDefaults.standard.set(state, forKey: self.biometricKey)
  }
  
  func isBiometricAuthenticationAvailable() -> Bool {
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
  
//  func showBiometricSettingsAlert(_ controller: UIViewController) {
//    let alertController = UIAlertController(title: <#T##String?#>, message: <#T##String?#>, preferredStyle: <#T##UIAlertController.Style#>)
//  }
}
