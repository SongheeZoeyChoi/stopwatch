//
//  MainNavigationViewController.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/08/01.
//

import UIKit
import GoogleSignIn

class MainNavigationViewController: UINavigationController {
    
    let userData = AppDelegate.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
        setToken()
    }
    private func setUserData() {
        UserDefaults.standard.set(userData?.profile?.email, forKey: "USER_EMAIL")
    }
    
    private func setToken() {
    
        print("song : \(userData?.profile?.email)")
        userData?.authentication.do(freshTokens: { authentication, error in
            guard error == nil else {return}
            guard let authentication = authentication else {return}
            
            let idToken = authentication.idToken
            print("song token: \(idToken)")
        })
    }
    
}
