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
  func popUpLoginFailedAlert(error: LoginError)
}

class LogonCoordinator: Coordinator {
  var rootViewController: UIViewController
  var navigationController: UINavigationController!
  let window: UIWindow
  var dashboardCoordinator: Coordinator!
  var logonViewController: LogOnViewController!
  
  init(window: UIWindow, rootViewController: UIViewController) {
    self.window = window
    self.rootViewController = rootViewController
  }
  
  func start() {
    let logonViewModel = LogonViewModel(coordiatorDelegate: self)
    self.logonViewController = LogOnViewController()
    logonViewController.viewModel = logonViewModel
    self.navigationController = UINavigationController(rootViewController: logonViewController)
    self.rootViewController.present(self.navigationController, animated: true, completion: nil)
  }
}

extension LogonCoordinator: LogonCoordinatorDelegate {
  func coordinateToDashboardScreen() {
    let dashboardCoordinator = DashboardCoordinator(rootViewController: self.logonViewController, navigationController: self.navigationController)
    self.dashboardCoordinator = dashboardCoordinator
    dashboardCoordinator.start()
  }
  
  func popUpLoginFailedAlert(error: LoginError) {
    var alertTitle: String
    var alertMessage: String
    switch error {
    case .wrongCredentials:
      alertTitle = "Your username and password are wrong"
      alertMessage = "Please try again, you can also use Face ID or Touch ID to sign in."
    case .systemFailure:
      alertTitle = "System Failure"
      alertMessage = "We are temporarily unable to log you in, please try later."
    case .biometricLoginFailure:
      alertTitle = "We were unable authenticate your biometric info."
      alertMessage = "Please try again, you can also use Username and Password to sign in."
    }
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    logonViewController.present(alertController, animated: true, completion: nil)
  }
}
