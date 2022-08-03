//
//  BaseViewController.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/26.
//

import UIKit

enum RootView: String{
    case login = "Login"
    case main = "Main"
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: MOVE Page Function
    func moveRootLoginViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        
        var keyWindow: UIWindow?
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            // Fallback on earlier versions
            keyWindow = UIApplication.shared.keyWindow
        }
        keyWindow?.rootViewController?.dismiss(animated: false, completion: {
            keyWindow?.rootViewController = vc
        })
    }

}
