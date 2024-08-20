//
//  DashboardViewModel.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/19/24.
//

import Foundation

class DashboardViewModel {
  
  weak var dashboardCoordinatorDelegate: DashboardCoordinatorDelegate?
  
  init(dashboardCoordinatorDelegate: DashboardCoordinatorDelegate) {
    self.dashboardCoordinatorDelegate = dashboardCoordinatorDelegate
  }
  
  func navigateToSettingsView() {
    self.dashboardCoordinatorDelegate?.coordinateToSettingsScreen()
  }
}
