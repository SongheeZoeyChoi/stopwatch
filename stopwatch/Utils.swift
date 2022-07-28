//
//  Utils.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/28.
//

import Foundation
import UIKit

class Utils {
    class func transStopwatchTime(_ time: Double) -> String {
        var transTime = String()
        let strTime = String(format: "%.2f", time) // .00
        // milliSec
        let index = strTime.index(strTime.endIndex, offsetBy: -2)
        let milliSec = String(strTime[index...])
        // sec
        let sec = String(format: "%02d", Int(fmod(time, 60)))
        let min = String(format: "%02d", Int(time / 60))
        
        transTime = "\(min):\(sec).\(milliSec)"
        return transTime
    }
}



