//
//  ViewController.swift
//  RK Social
//
//  Created by Rex Kung on 1/5/18.
//  Copyright © 2018 Rex Kung. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = LoginManager()

        facebookLogin.logIn(readPermissions: [.email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged In")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
            }
        
        
        }
    
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("REX: Unable to authenticate with firebase = \(String(describing: error))")
            } else {
                print("Rex: authenticated to firebase")
            }
            
        })
        
    }
}

