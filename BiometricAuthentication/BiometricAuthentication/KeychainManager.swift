//
//  KeychainManager.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/15/24.
//

import UIKit
import Security

class KeychainManager {
  
  static let shared = KeychainManager()
  static let service = "BioAuthAppService"
  static let account = "BioAuthAccount"
  static let errorDomain = "BioAuthErrorDomain"
  
  private typealias keychainTuple = [String: Any]
  
  private init() {}
  
  func storeLoginInfo(username: String, password: String) {
    let usernameKey = username.data(using: .utf8)
    let passwordData = password.data(using: .utf8)
    if let usernameKey = usernameKey, let passwordData = passwordData {
      let query: [String: Any] = [
        //"Internet passwords" are somewhat specialized records for Safari. They include host and user data that make them easier to look when you're storing hundreds of records for an unknown list of sites. They are almost never what anything other than a browser wants.
        
        // In almost all cases what apps want in order to store data is "generic password," no matter what you're storing, even if it's not a password. "Generic password" is basically "blob of encrypted data." (If your app needs to store public/private keys or certificates, then the applicable classes are useful for that, but this is less common than storing "blobs of encrypted data.")
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: KeychainManager.service,
        kSecAttrAccount as String: KeychainManager.account,
        kSecValueData as String: passwordData,
        kSecAttrGeneric as String: usernameKey
      ]
      
      DispatchQueue.global().async { [query] in
        let storingStatus = self.storeValueInKeychain(query: query as CFDictionary)
        // TODO: handle success/failure cases
        if storingStatus {
          print("Login information securely stored. ")
        } else {
          print("Failed to store login information securely. ")
        }
      }
    }
  }
  
  func retrieveLoginInfo(completion: @escaping (String?, String?, Error?) -> Void) {
    // TODO: need to research on how to construct query here, where to put the key in?
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrServer as String: KeychainManager.service,
      kSecAttrAccount as String: KeychainManager.account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    let result = retrieveKeychainValue(query: query as CFDictionary)
    switch result {
    case .success(let retrievedData):
      if let passwordData = retrievedData[kSecValueData as String] as? Data,
         let usernameData = retrievedData[kSecAttrGeneric as String] as? Data,
         let password = String(data: passwordData, encoding: .utf8),
         let username = String(data: usernameData, encoding: .utf8) {
        completion(username, password, nil)
      }
    case .failure(let error):
      completion(nil, nil, error)
    }
  }
}

// TODO: consider if separate these methods into an interface:
extension KeychainManager {
  
  private func retrieveKeychainValue(query: CFDictionary) -> Result<keychainTuple, NSError> {
    var item: AnyObject?
    let status = SecItemCopyMatching(query, &item)
    if status == errSecSuccess, let item = item as? keychainTuple {
      return .success(item)
    } else {
      if let error = SecCopyErrorMessageString(status, nil) as String? {
        return .failure(NSError(domain: KeychainManager.errorDomain, code: Int(status), userInfo: [NSLocalizedDescriptionKey: error]))
      } else {
        return .failure(NSError(domain: KeychainManager.errorDomain, code: Int(status), userInfo: nil))
      }
    }
  }
  
  private func storeValueInKeychain(query: CFDictionary) -> Bool {
    // Delete a previous reference, if it exists, before adding a new one.
    SecItemDelete(query)
    let status = SecItemAdd(query, nil)
    guard status == errSecSuccess else { return false }
    return true
  }
  
  
}
