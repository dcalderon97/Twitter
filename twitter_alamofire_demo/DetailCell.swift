//
//  DetailCell.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Calderon on 3/6/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            tweetTextLabel.text = tweet.text
            profileImageView.layer.cornerRadius = 34
            profileImageView.clipsToBounds = true
            profileImageView.af_setImage(withURL: tweet.user.profilePictureURL)
            usernameLabel.text = tweet.user.name
            screenNameLabel.text = "@\(tweet.user.screenName)"
            let df = DateFormatter()
            df.dateStyle = .full
            df.timeStyle = .full
            
            let date = df.date(from: tweet.createdAtString)!
            df.dateStyle = .short
            df.timeStyle = .short
            dateLabel.text = df.string(from: date)
        }
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
