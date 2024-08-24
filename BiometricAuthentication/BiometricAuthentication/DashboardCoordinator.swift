//
//  AuthCoordinator.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/14/24.
//

import UIKit

protocol DashboardCoordinatorDelegate: AnyObject {
  func coordinateToSettingsScreen()
}

class DashboardCoordinator: Coordinator {
  var navigationController: UINavigationController!
  var rootViewController: UIViewController
  var dashboardViewController: DashboardViewController!
    
  init(rootViewController: UIViewController, navigationController: UINavigationController) {
    self.rootViewController = rootViewController
    self.navigationController = navigationController
  }
  
  func start() {
    self.dashboardViewController = DashboardViewController()
    let dashboardViewModel = DashboardViewModel(dashboardCoordinatorDelegate: self)
    dashboardViewController.viewModel = dashboardViewModel
    self.navigationController.pushViewController(dashboardViewController, animated: true)
  }
}

extension DashboardCoordinator: DashboardCoordinatorDelegate {
  func coordinateToSettingsScreen() {
    let settingsViewController = SettingsViewController()
    let settingsViewModel = SettingsViewModel()
    settingsViewController.viewModel = settingsViewModel
    self.navigationController.pushViewController(settingsViewController, animated: true)
  }
}
