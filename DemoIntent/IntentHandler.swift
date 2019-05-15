//
//  IntentHandler.swift
//  DemoIntent
//
//  Created by Cristian on 4/14/19.
//  Copyright © 2019 Cristian Palomino. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is INSearchForAccountsIntent else { fatalError("Unhandled intent type \(intent)") }
        return SearchForAccountsIntentHandler()
    }
    
}
