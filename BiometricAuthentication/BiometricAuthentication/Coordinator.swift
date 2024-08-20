//
//  Coordinator.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/19/24.
//

import UIKit

protocol Coordinator {
  var navigationController: UINavigationController { get set }
  func start()
}
