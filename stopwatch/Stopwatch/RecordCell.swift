//
//  RecordCell.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/27.
//

import UIKit

class RecordCell: UICollectionViewCell {
    
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var recordTimeLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(item: RecordInfo) {
        lapLabel.text = item.title
        recordTimeLabel.text = Utils.transStopwatchTime(item.time)
    }
    
}
