//
//  Coordinator.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/19/24.
//

import UIKit

protocol Coordinator {
  // Use impolicitly unwrapped navigationController here because this won't be set in init() but in start()
  var navigationController: UINavigationController! { get set }
  var rootViewController: UIViewController { get set }
  func start()
}
