//
//  ViewController.swift
//  Demo
//
//  Created by Cristian on 4/14/19.
//  Copyright © 2019 Cristian Palomino. All rights reserved.
//

import UIKit
import CoreDemo

class ViewController: UIViewController {

    private let credentialsProtocol: CredentialsProtocol = CoreDemo.shared().session
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillForm()
    }
    
    private func fillForm() {
        guard
            let doiInput = view.subviews.first?.subviews[0] as? UITextField,
            let passwordInput = view.subviews.first?.subviews[1] as? UITextField
        else { return }
        let credentials = credentialsProtocol.credentials
        doiInput.placeholder = credentials?.doi ?? "Doi*"
        passwordInput.placeholder = credentials?.password ?? "Password*"
    }

    @IBAction func tapLogin() {
        guard
            let doiInput = view.subviews.first?.subviews[0] as? UITextField,
            let passwordInput = view.subviews.first?.subviews[1] as? UITextField
        else { return }
        guard
            let doi = doiInput.text, !doi.isEmpty,
            let password = passwordInput.text, !password.isEmpty
        else { return }
        let credentials = Credentials(doi: doi, password: password)
        credentialsProtocol.save(credentials)
    }
    
    @IBAction func tapTrash() {
        credentialsProtocol.delete()
        fillForm()
    }
    
}

