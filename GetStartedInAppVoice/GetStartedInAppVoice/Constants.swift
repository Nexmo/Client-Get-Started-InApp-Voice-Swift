//
//  Constants.swift
//  GetStartedInAppVoice
//
//  Created by Paul Ardeleanu on 11/01/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import Foundation


enum User: String {
    case jane = "Jane"
    case joe = "Joe"
    
    var userId: String {
        switch self {
        case .jane:
            return "" //TODO: swap with Jane's userId
        case .joe:
            return "" //TODO: swap with Joe's userId
        }
    }
    
    var token: String {
        switch self {
        case .jane:
            return "" //TODO: swap with a token for Jane
        case .joe:
            return "" //TODO: swap with a token for Joe
        }
    }
    
    var callee: User {
        switch self {
        case .jane:
            return .joe
        case .joe:
            return .jane
        }
    }
}
