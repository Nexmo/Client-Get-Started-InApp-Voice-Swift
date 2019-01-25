//
//  MainViewController+Interface.swift
//  GetStartedInAppVoice
//
//  Created by Paul Ardeleanu on 24/01/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import Foundation
import NexmoClient


enum InterfaceState {
    case notAuthenticated
    case connecting
    case disconnected
    case loggedIn(User)
    case callInitiated(User)
    case callError(User)
    case inCall(User)
    case callRejected(User)
    case callEnded(User)
}


extension MainViewController {
    
    var interfaceState: InterfaceState {
        // not authenticated if no client present
        guard let client = client else {
            return .notAuthenticated
        }
        // Disconnected or currently Connecting
        switch client.connectionStatus {
        case .disconnected:
            return .disconnected
        case .connecting:
            return .connecting
        case .connected: break
        }
        
        // Edge case - connected but user not present
        guard let clientUser = client.user else {
            return .disconnected
        }
        
        // Determining the current user
        var loggedInUser: User!
        if clientUser.userId == User.jane.userId {
            loggedInUser = User.jane
        } else if clientUser.userId == User.joe.userId {
            loggedInUser = User.joe
        } else {
            // this should never happen
            return .disconnected
        }
        
        guard let call = call else {
            switch callStatus {
            case .unknown:
                return .loggedIn(loggedInUser)
            case .initiated:
                return .callInitiated(loggedInUser.callee)
            case .inProgress:
                // this should never happen
                return .loggedIn(loggedInUser)
            case .error:
                return .callError(loggedInUser.callee)
            case .rejected:
                return .callRejected(loggedInUser.callee)
            case .completed:
                return .callEnded(loggedInUser.callee)
            }
        }
        switch call.status  {
        case .disconnected:
            return .callEnded(loggedInUser.callee)
        case .connected:
            return .inCall(loggedInUser.callee)
        }
    }
    
    
    func updateInterface() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.statusLabel.text = "Ready."
            self.logoutButton.alpha = 0
            self.callButton.alpha = 0
            
            switch self.interfaceState {
                
            case .notAuthenticated:
                self.call = nil
                self.statusLabel.text = "Not Authenticated."
                self.logoutButton.alpha = 1
                
            case .connecting:
                self.activityIndicator.startAnimating()
                self.statusLabel.text = "Connecting..."
                self.logoutButton.alpha = 1
                
            case .disconnected:
                self.statusLabel.text = "Disconnected"
                self.logoutButton.alpha = 1
                
            case .loggedIn(let user):
                self.statusLabel.text = "Connected as \(user.rawValue)"
                self.logoutButton.alpha = 1
                self.callButton.alpha = 1
                self.callButton.setTitle("Call \(user.callee.rawValue)", for: .normal)
                
            case .callInitiated(let callee):
                self.statusLabel.text = "Calling \(callee.rawValue)..."
                self.logoutButton.alpha = 0
                self.callButton.alpha = 0
                
            case .inCall(let callee):
                self.statusLabel.text = "Speaking with \(callee.rawValue)..."
                self.logoutButton.alpha = 0
                self.callButton.alpha = 1
                self.callButton.setTitle("End call", for: .normal)
                
            case .callError(let callee):
                self.statusLabel.text = "Could not call \(callee.rawValue)"
                self.logoutButton.alpha = 1
                self.callButton.alpha = 1
                self.callButton.setTitle("Call \(callee.rawValue)", for: .normal)
                
            case .callRejected(let callee):
                self.statusLabel.text = "Call rejected by \(callee.rawValue)"
                self.logoutButton.alpha = 1
                self.callButton.alpha = 1
                self.callButton.setTitle("Call \(callee.rawValue)", for: .normal)
                
            case .callEnded(let callee):
                self.statusLabel.text = "Call with \(callee.rawValue) ended."
                self.logoutButton.alpha = 1
                self.callButton.alpha = 1
                self.callButton.setTitle("Call \(callee.rawValue)", for: .normal)
                
            }
            
            
//            var message = ""
//
//            // Authenticated
//            switch(client.connectionStatus, client.user) {
//            case (.disconnected, _):
//                self.statusLabel.text = "Disconnected"
//                self.logoutButton.alpha = 1
//                return
//            case (.connecting, _):
//                self.activityIndicator.startAnimating()
//                self.statusLabel.text = "Connecting"
//                self.logoutButton.alpha = 1
//                return
//            case (.connected, let user):
//
//            case (_, _):
//                self.statusLabel.text = "Unknown state"
//                self.logoutButton.alpha = 1
//                return
//            }
//
//            // Not in a call
//            guard let call = self.call else {
//                self.callButton.setTitle("Call \(self.user.callee)", for: .normal)
//                message.append("\nReady...")
//                self.statusLabel.text = message
//                return
//            }
//
//            let names: [String] = call.otherCallMembers?.compactMap({ participant -> String? in
//                return (participant as? NXMCallMember)?.user.name
//            }) ?? []
//            self.activityIndicator.startAnimating()
//            self.statusLabel.text = "Calling \(names.joined(separator: ", "))"
//            self.callButton.setTitle("End call", for: .normal)
//            self.logoutButton.alpha = 0
            
        }
    }
    
}
