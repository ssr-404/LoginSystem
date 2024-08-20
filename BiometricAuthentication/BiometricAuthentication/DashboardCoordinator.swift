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
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let dashboardViewController = DashboardViewController()
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
