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
    
    func configure(item: RecordInfo, index: Int) {
        lapLabel.text = "lap\(index + 1)"
        recordTimeLabel.text = "\(String(format: "%.2f", item.time))"
    }
    
}
