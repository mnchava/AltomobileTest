//
//  ViewController.swift
//  test2
//
//  Created by ChavaFerrer on 14/01/20.
//  Copyright © 2020 ChavaFerrer. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {
    @IBOutlet weak var loginB: UIButton!
    @IBOutlet weak var listaB: UIButton!
    
    var isLoggedIn: Bool = false
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginB.layer.cornerRadius = 15
        
        if AccessToken.current != nil {
            print("\nLogin out from SSO")
            loginManager.logOut()
        }
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        let alertController: UIAlertController
        
        switch result {
        case .cancelled:
            isLoggedIn = false
            alertController = UIAlertController(
                title: "Login Cancelled",
                message: "User cancelled login.",
                preferredStyle: .alert
            )
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okButton)

            self.present(alertController, animated: true, completion: nil)

        case .failed(let error):
            isLoggedIn = false
            alertController = UIAlertController(
                title: "Login Fail",
                message: "Login failed with error \(error)",
                preferredStyle: .alert
            )
            print("\nFailed with error: \n\(error)")
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)

        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            if declinedPermissions.contains(.email){
                alertController = UIAlertController(
                    title: "Login Fail",
                    message: "Please grant the email permission to login",
                    preferredStyle: .alert
                )
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                loginManager.logOut()
            }else{
                print("\nLogged in\n")
                loginB.setTitle("Log out", for: .normal)
                listaB.setTitle("Go to list", for: .normal)
                listaB.isEnabled = true
                isLoggedIn = true
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let listView = storyBoard.instantiateViewController(withIdentifier: "lista")
                self.present(listView, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func logIO(){
        if isLoggedIn {
            print("\nLogin out")
            loginManager.logOut()
            isLoggedIn = false
            loginB.setTitle("Log in", for: .normal)
            listaB.setTitle("Log in to see list", for: .normal)
            listaB.isEnabled = false
        }else{
            print("\nLogin in")
            loginManager.logIn(permissions: [.publicProfile, .email], viewController: self
            ){ result in
                self.loginManagerDidComplete(result)
            }
        }
    }
    @IBAction func verLista(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let listView = storyBoard.instantiateViewController(withIdentifier: "lista")
                    self.present(listView, animated: true, completion: nil)
    }
}

