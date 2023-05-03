//
//  trainTableViewCell.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/16.
//

import UIKit

class trainTableViewCell: UITableViewCell {

    @IBOutlet weak var indexNumber: UILabel!
    @IBOutlet weak var timeInfoLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(index: Int, timeInfo: String, stationName: String){
        
        if index < 10{
            let indexStr = "0" + String(index) + "."
            indexNumber.text = indexStr
        }
        else{
            let indexStr = String(index) + "."
            indexNumber.text = indexStr
        }
        
        timeInfoLabel.text = timeInfo
        stationNameLabel.text = stationName + "高鐵站"
    }
    

}
