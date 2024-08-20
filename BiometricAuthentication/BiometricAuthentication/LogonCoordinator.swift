//
//  LogonCoordinator.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/15/24.
//

import UIKit

// weak reference are only defined for reference type, so setting the delegate protocol to a class-only protocol.
protocol LogonCoordinatorDelegate: AnyObject {
  func coordinateToDashboardScreen()
}

class LogonCoordinator: Coordinator {
  var navigationController: UINavigationController
  let window: UIWindow
  
  init(window: UIWindow, navigationController: UINavigationController) {
    self.window = window
    self.navigationController = navigationController
  }
  
  func start() {
    let logonViewModel = LogonViewModel(coordiatorDelegate: self)
    let logonViewController = LogOnViewController()
    logonViewController.viewModel = logonViewModel
    self.navigationController.pushViewController(logonViewController, animated: true)
  }
}

extension LogonCoordinator: LogonCoordinatorDelegate {
  func coordinateToDashboardScreen() {
    let coordinator = DashboardCoordinator(navigationController: self.navigationController)
    coordinator.start()
  }
}
