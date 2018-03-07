//
//  StatisticsCell.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Calderon on 3/6/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class StatisticsCell: UITableViewCell {
    @IBOutlet weak var counterRewteetsLabel: UILabel!
    @IBOutlet weak var counterLikesLabel: UILabel!
    var tweet: Tweet! {
        didSet{
            
            counterRewteetsLabel.text = formatCounter(count: tweet.retweetCount)
            counterLikesLabel.text = formatCounter(count: tweet.favoriteCount!)
        }
    }
    func formatCounter(count: Int) -> String{
        var formattedCount = ""
        // Billion, just in case
        if(count >= 1000000000){
            formattedCount = String(format: "%.1fb", Double(count) / 1000000000.0)
        }
        else if(count >= 1000000){
            formattedCount = String(format: "%.1fm", Double(count) / 1000000.0)
        }
        else if(count >= 10000){
            formattedCount = String(format: "%.1fk", Double(count) / 1000.0)
        }
        else{
            formattedCount = "\(count)"
        }
        
        return formattedCount
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
