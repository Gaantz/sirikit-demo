//
//  Services.swift
//  CoreDemo
//
//  Created by Cristian on 4/20/19.
//  Copyright © 2019 Cristian Palomino. All rights reserved.
//

import Foundation

public class Services {
    
    public func login(_ completion: @escaping (() -> Void)) {
        DispatchQueue.global().async {
            CoreDemo.shared().session.isLoggedIn = true
            sleep(1)
            completion()
        }
    }
    
    public func obtainBankAccounts(_ completion: @escaping (([BankAccount]) -> Void)) {
        let accounts = ["Cuenta Free Soles,100.00,SOLES,Checking",
                        "Cuenta Free Dolares,150.00,DOLARES,Checking",
                        "Cuenta Sueldo,5000.00,SOLES,Checking"]
            .map(BankAccount.init)
        DispatchQueue.global().async {
            sleep(1)
            completion(accounts)
        }
    }
    
}

public struct BankAccount {
    
    public let name: String
    public let balance: Double
    public let currency: String
    public let type: String
 
    init(from strings: String) {
        let data = strings.split(separator: ",")
        self.name = String(data[0])
        self.balance = Double(data[1])!
        self.currency = String(data[2])
        self.type = String(data[3])
    }
    
}
