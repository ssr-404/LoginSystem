//
//  LogonViewModel.swift
//  BiometricAuthentication
//
//  Created by Rong Sun on 8/19/24.
//

import Foundation

class LogonViewModel: NSObject {
  
  private weak var coordinatorDelegate: LogonCoordinatorDelegate?
  
  init(coordiatorDelegate: LogonCoordinatorDelegate) {
    self.coordinatorDelegate = coordiatorDelegate
  }
  
  func navigateToDashboard() {
    self.coordinatorDelegate?.coordinateToDashboardScreen()
  }
  
}
