//
//  IntentTransactionsHandler.swift
//  DemoIntent
//
//  Created by Cristian on 4/14/19.
//  Copyright © 2019 Cristian Palomino. All rights reserved.
//

import Foundation
import Intents
import CoreDemo

class SearchForAccountsIntentHandler: NSObject, INSearchForAccountsIntentHandling {
    
    func handle(intent: INSearchForAccountsIntent,
                completion: @escaping (INSearchForAccountsIntentResponse) -> Void) {
        if !CoreDemo.shared().session.isLoggedIn {
            CoreDemo.shared().services.login {
                CoreDemo.shared().services.obtainBankAccounts { accounts in
                    if !accounts.isEmpty {
                        let result = INSearchForAccountsIntentResponse(code: .success, userActivity: .none)
                        result.accounts = accounts.map {
                            INPaymentAccount(nickname: INSpeakableString(spokenPhrase: $0.name),
                                             number: nil,
                                             accountType: .unknown,
                                             organizationName: nil,
                                             balance: INBalanceAmount(amount: NSDecimalNumber(value: $0.balance),
                                                                      currencyCode: $0.currency),
                                             secondaryBalance: nil)
                        }
                        completion(result)
                    } else {
                        let result = INSearchForAccountsIntentResponse(code: .failure, userActivity: .none)
                        completion(result)
                    }
                }
            }
        }
    }
    
}
