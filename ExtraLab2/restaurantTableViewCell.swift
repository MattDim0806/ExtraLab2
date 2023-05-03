//
//  restaurantTableViewCell.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/20.
//

import UIKit

class restaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var vicinityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(image:UIImage, restaurantName:String,vicinity:String,distance:String,rate:Double,reviewsNumber:Int){
        //將img設為圓角
        self.img.layer.cornerRadius = 10
        self.img.image = image
        self.restaurantName.text = restaurantName
        self.vicinityLabel.text = vicinity
        self.distanceLabel.text = "距離：" + distance + " 公里"
        self.rateLabel.text = "評價：" + String(rate) + "(" + String(reviewsNumber) + "則評論)"
    }
    
    func setCellHidden() {
        self.isHidden = true
        self.contentView.isHidden = true
    }

}
