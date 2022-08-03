//
//  SettingsViewController.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/26.
//

import UIKit
import GoogleSignIn

class SettingsViewController: BaseViewController {

    @IBOutlet weak var userEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        userEmailLabel.text = UserDefaults.standard.string(forKey: "USER_EMAIL")
    }
    
    private func moveLogin() {
        moveRootLoginViewController()
    }
    
    
    //MARK: Action
    @IBAction func onClickLogout(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        
        self.moveLogin()
    }
    
    @IBAction func onClickSwitchAppearance(_ sender: UISegmentedControl) {
        view.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: sender.selectedSegmentIndex) ?? .unspecified
    }
}
