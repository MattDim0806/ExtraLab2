//
//  timeTableViewCell.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/12.
//

import UIKit

class timeTableViewCell: UITableViewCell {
    @IBOutlet weak var trainInfo: UILabel!
    @IBOutlet weak var DestinationTime: UILabel!
    @IBOutlet weak var driveTime: UILabel!
    @IBOutlet weak var OriginArrivalTime: UILabel! //發車時間
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(Direction: Int, TrainNo: String, originArrivalTime: String, DestinationArrivalTime: String){
        trainInfo.layer.cornerRadius =  8
        trainInfo.layer.masksToBounds = true
        if(Direction == 0){
            trainInfo.text = String(format: "南下\n%@", TrainNo)
        }
        else{
            trainInfo.text = String(format: "北上\n%@", TrainNo)
        }
        DestinationTime.text = DestinationArrivalTime
        OriginArrivalTime.text = originArrivalTime
        let difference = calculateTimeDifference(start: originArrivalTime, end: DestinationArrivalTime)
        driveTime.text = difference
    }
    
    func calculateTimeDifference(start: String, end: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startDate = dateFormatter.date(from: start), let endDate = dateFormatter.date(from: end) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: startDate, to: endDate)
            
            if let hours = components.hour, let minutes = components.minute {
                let timeDifference = "\(hours) 小時 \(minutes) 分鐘"
                return timeDifference
            }
        }
        
        return "計算失敗"  // 若計算失敗，回傳空字串或其他適當的預設值
    }
}
