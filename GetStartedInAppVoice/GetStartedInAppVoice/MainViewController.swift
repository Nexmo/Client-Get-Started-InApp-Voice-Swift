//
//  MainViewController.swift
//  GetStartedInAppVoice
//
//  Created by Paul Ardeleanu on 11/01/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import UIKit
import NexmoClient


enum CallStatus {
    case unknown
    case initiated
    case inProgress
    case error
    case rejected
    case completed
}


class MainViewController: UIViewController {
    var user: User!
    var client: NXMClient?
    var call: NXMCall?
    var callStatus: CallStatus = .unknown
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
        setupNexmoClient()
    }
    
    //MARK: - Setup Nexmo Client
    func setupNexmoClient() {
        
    }
    
    
    @IBAction func call(_ sender: Any) {
        
    }
    
    private func startCall() {
        
    }
    
    private func end(call: NXMCall) {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        client?.logout()
        dismiss(animated: true, completion: nil)
    }
    
}


extension MainViewController: NXMClientDelegate {
    
    func connectionStatusChanged(_ status: NXMConnectionStatus, reason: NXMConnectionStatusReason) {
        
    }
    
    func incomingCall(_ call: NXMCall) {
        
    }
    
    //MARK: Incoming call - Accept
    private func answer(call: NXMCall) {
        
    }
    
    //MARK: Incoming call - Reject
    private func reject(call: NXMCall) {
        
    }
    
}



//MARK:- Call Delegate

extension MainViewController: NXMCallDelegate {

    func statusChanged(_ member: NXMCallMember) {
        
    }
    
}

