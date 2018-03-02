//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import ActiveLabel

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var screennameTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let url = URL(string: tweet.user.profilePicutreUrl)!
            profileImageView.af_setImage(withURL: url)
            
            profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
            profileImageView.layer.masksToBounds = true
            
            tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
            tweetTextLabel.text = tweet.text
            tweetTextLabel.handleURLTap { (url) in
                UIApplication.shared.openURL(url)
            }
            
            screennameTextLabel.text = tweet.user.screenName
            timestampLabel.text = tweet.createdAtString
            usernameTextLabel.text = tweet.user.name
            
            
            // favorite button
            if tweet.favorited! {
                favoriteButton.isSelected = true
            }
            else {
                favoriteButton.isSelected = false
            }
            
            // retweet button
            if tweet.retweeted {
                retweetButton.isSelected = true
            } else {
                retweetButton.isSelected = false
            }
            
            
            
            // favorite count
            print(tweet.favoriteCount)
            if tweet.favoriteCount! == 0 {
                favoriteLabel.text = "0"
            } else {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                    
                } else {
                    favoriteLabel.text = String(tweet.favoriteCount!)
                }
            }
            
            
            // retweet count
            if tweet.retweetCount == 0 {
                retweetLabel.text = ""
            } else {
                if tweet.retweetCount >= 1000000 {
                    retweetLabel.text = String(tweet.retweetCount / 1000000) + "M"
                } else if tweet.retweetCount >= 1000 {
                    retweetLabel.text = String(tweet.retweetCount / 1000) + "K"
                    
                } else {
                    retweetLabel.text = String(tweet.retweetCount)
                }
            }
        }
    }
    @IBAction func didTapFavorite(_ sender: Any) {
        if tweet.favorited! {
            favoriteButton.isSelected = false
            tweet.favorited = false
            
            tweet.favoriteCount = tweet.favoriteCount! - 1
            
            // favorite count
            if tweet.favoriteCount == 0 {
                favoriteLabel.text = ""
            } else {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                    
                } else {
                    favoriteLabel.text = String(tweet.favoriteCount!)
                }
            }
            
            // network request
            APIManager.shared.unfavorite(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Unfavorite success!")
                    
                }
                
            })
        }else {
            favoriteButton.isSelected = true
            tweet.favorited = true
            
            tweet.favoriteCount = tweet.favoriteCount! + 1
            
            // favorite count
            if tweet.favoriteCount == 0 {
                favoriteLabel.text = ""
            } else {
                if tweet.favoriteCount! >= 1000000 {
                    favoriteLabel.text = String(tweet.favoriteCount! / 1000000) + "M"
                } else if tweet.favoriteCount! >= 1000 {
                    favoriteLabel.text = String(tweet.favoriteCount! / 1000) + "K"
                    
                } else {
                    favoriteLabel.text = String(tweet.favoriteCount!)
                }
            }
            // network request
            APIManager.shared.favorite(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Favorite success!")
                }
            })
        }
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if tweet.retweeted {
            retweetButton.isSelected = false
            tweet.retweeted = false
            
            tweet.retweetCount = tweet.retweetCount - 1
            
            // retweet count
            if tweet.retweetCount == 0 {
                retweetLabel.text = ""
            } else {
                if tweet.retweetCount >= 1000000 {
                    retweetLabel.text = String(tweet.retweetCount / 1000000) + "M"
                } else if tweet.retweetCount >= 1000 {
                    retweetLabel.text = String(tweet.retweetCount / 1000) + "K"
                    
                } else {
                    retweetLabel.text = String(tweet.retweetCount)
                }
            }
            
            // network request
            APIManager.shared.unretweet(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Unretweet success!")
                    
                }
                
            })
        } else {
            retweetButton.isSelected = true
            tweet.retweeted = true
            
            retweetButton.isSelected = true
            tweet.retweetCount = tweet.retweetCount + 1
            
            // retweet count
            if tweet.retweetCount == 0 {
                retweetLabel.text = ""
            } else {
                if tweet.retweetCount >= 1000000 {
                    retweetLabel.text = String(tweet.retweetCount / 1000000) + "M"
                } else if tweet.retweetCount >= 1000 {
                    retweetLabel.text = String(tweet.retweetCount / 1000) + "K"
                    
                } else {
                    retweetLabel.text = String(tweet.retweetCount)
                }
            }
            
            // network request
            APIManager.shared.retweet(with: tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("Error retweeting Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Retweet success!")
                    
                }
                
            })
            
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
