//
//  LoginViewController.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/26.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    let signInConfig = GIDConfiguration(clientID: Const.googleSignInClientID)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func googleSingIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                // TODO: 알럿
                print(error)
                return
            }
            
            guard let user = user else { return }
            // If sign in succeeded, display the app's main content View.
            
            print(user)
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "MainNavigationViewController") as? MainNavigationViewController else {return}
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        }
    }
}
