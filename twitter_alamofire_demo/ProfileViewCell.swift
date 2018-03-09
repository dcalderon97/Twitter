//
//  ProfileViewCell.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Calderon on 3/7/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var folllowingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var user : User! {
        didSet{
            bannerImageView.af_setImage(withURL: user.coverPictureUrl)
            profileImageView.af_setImage(withURL: user.profilePictureURL)
            profileImageView.layer.cornerRadius = 34
            profileImageView.clipsToBounds = true
            usernameLabel.text = user.name
            screenNameLabel.text = user.screenName
            descriptionLabel.text = user.description
            tweetCountLabel.text = String(user.numberOfTweets)
            followersCountLabel.text = "\(user.followersCount ?? -1)"
            followingCountLabel.text = "\(user.followingCount ?? -1)"
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
