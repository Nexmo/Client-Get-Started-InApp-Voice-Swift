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
        client = NXMClient(token: user.token)
        client?.setDelegate(self)
        client?.login()
    }
    
    
    @IBAction func call(_ sender: Any) {
        // call initiated but not yet active
        if callStatus == .initiated && call == nil {
            return
        }
        // start a new call (check if a call already exists)
        guard let call = call else {
            startCall()
            return
        }
        end(call: call)
    }
    
    private func startCall() {
        callStatus = .initiated
        client?.call([user.callee.userId], callType: .inApp, delegate: self) { [weak self] (error, call) in
            guard let self = self else { return }
            // Handle create call failure
            guard let call = call else {
                if let error = error {
                    // Handle create call failure
                    print("❌❌❌ call not created: \(error.localizedDescription)")
                } else {
                    // Handle unexpected create call failure
                    print("❌❌❌ call not created: unknown error")
                }
                self.callStatus = .error
                self.call = nil
                self.updateInterface()
                return
            }
            
            // Handle call created successfully.
            // callDelegate's  statusChanged: will be invoked with needed updates.
            call.setDelegate(self)
            self.call = call
            self.updateInterface()
        }
        updateInterface()
    }
    
    private func end(call: NXMCall) {
        call.myCallMember.hangup()
        callStatus = .completed
        self.call = nil
        updateInterface()
    }
    
    @IBAction func logout(_ sender: Any) {
        client?.logout()
        dismiss(animated: true, completion: nil)
    }
    
}


extension MainViewController: NXMClientDelegate {
    
    func connectionStatusChanged(_ status: NXMConnectionStatus, reason: NXMConnectionStatusReason) {
        print("👁👁👁 connectionStatusChanged - status: \(status.description()) - reason: \(reason.description())")
        updateInterface()
    }
    
    func incomingCall(_ call: NXMCall) {
        print("📲 📲 📲 Incoming Call: \(call)")
        DispatchQueue.main.async {
            let names: [String] = call.otherCallMembers.compactMap({ participant -> String? in
                return (participant as? NXMCallMember)?.user.name
            })
            let alert = UIAlertController(title: "Incoming call from", message: names.joined(separator: ", "), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Answer", style: .default, handler: { _ in
                self.answer(call: call)
            }))
            alert.addAction(UIAlertAction(title: "Reject", style: .default, handler: { _ in
                self.reject(call: call)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Incoming call - Accept
    private func answer(call: NXMCall) {
        self.call = call
        call.answer(self) { [weak self] error in
            if let error = error {
                print("error answering call: \(error.localizedDescription)")
            }
            self?.updateInterface()
        }
    }
    
    //MARK: Incoming call - Reject
    private func reject(call: NXMCall) {
        call.reject { [weak self] error in
            if let error = error {
                print("error declining call: \(error.localizedDescription)")
            }
            self?.updateInterface()
        }
    }
    
}



//MARK:- Call Delegate

extension MainViewController: NXMCallDelegate {

    func statusChanged(_ member: NXMCallMember) {
        //print("🤙🤙🤙 Call Status changed | member: \(String(describing: member.user.name))")
        print("🤙🤙🤙 Call Status changed | member status: \(String(describing: member.status.description()))")
        
        guard let call = call else {
            // this should never happen
            self.callStatus = .unknown
            self.updateInterface()
            return
        }
        
        // call ended before it could be answered
        if member == call.myCallMember, member.status == .answered, let otherMember = call.otherCallMembers.firstObject as? NXMCallMember, [NXMCallMemberStatus.completed, NXMCallMemberStatus.cancelled].contains(otherMember.status)  {
            self.callStatus = .completed
            self.call?.myCallMember.hangup()
            self.call = nil
        }
        
        // call rejected
        if call.otherCallMembers.contains(member), member.status == .cancelled {
            self.callStatus = .rejected
            self.call?.myCallMember.hangup()
            self.call = nil
        }
        
        // call ended
        if call.otherCallMembers.contains(member), member.status == .completed {
            self.callStatus = .completed
            self.call?.myCallMember.hangup()
            self.call = nil
        }

        updateInterface()
    }
    
}

