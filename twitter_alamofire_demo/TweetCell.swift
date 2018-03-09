//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import DateToolsSwift
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
    @IBOutlet weak var verticalImageSpacing: NSLayoutConstraint!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            let url = tweet.user.profilePictureURL
            profileImageView.af_setImage(withURL: url)
            
            profileImageView.layer.cornerRadius = profileImageView.frame.width * 0.5
            profileImageView.layer.masksToBounds = true
            
            tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
            tweetTextLabel.text = tweet.text
            tweetTextLabel.handleURLTap { (url) in
                UIApplication.shared.openURL(url)
            }
            
            screennameTextLabel.text = tweet.user.screenName
            timestampLabel.text = "\(formattedDate(date: tweet.createdAtString))"
            usernameTextLabel.text = tweet.user.name
            
            favoriteLabel.text = "\(formatCounter(count: tweet.favoriteCount!))"
            retweetLabel.text = "\(formatCounter(count: tweet.retweetCount))"
            
            if(tweet.favorited)!{
                favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            }
            else{
                favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
            if(tweet.retweeted){
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            }
            else{
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
            if let url = tweet.mediaUrl {
                mediaImageView.isHidden = false
                print(tweet.user.name)
                print(url)
                mediaImageView.af_setImage(withURL: url)
                verticalImageSpacing.constant = 300
            }
            else {
                mediaImageView.isHidden = true
                verticalImageSpacing.constant = 8
            }
        }
    }
    @IBAction func didTapFavorite(_ sender: Any) {
        if(tweet.favorited == false){
            tweet.favorited = true
            tweet.favoriteCount! += 1
            favoriteLabel.text = "\(tweet.favoriteCount!)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            APIManager.shared.favorite(with: tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        else{
            tweet.favorited = false
            tweet.favoriteCount! -= 1
            favoriteLabel.text = "\(tweet.favoriteCount!)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            APIManager.shared.unfavorite(with: tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            })
        }
    
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if(tweet.retweeted == false){
            tweet.retweeted = true
            tweet.retweetCount += 1
            retweetLabel.text = "\(tweet.retweetCount)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            APIManager.shared.retweet(with: tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error retweeting: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            })
        }
        else{
            tweet.retweeted = false
            tweet.retweetCount -= 1
            retweetLabel.text = "\(tweet.retweetCount)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            APIManager.shared.unretweet(with: tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error unretweeting: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            })
        }
      
    }
    func formattedDate(date: String) -> String{
        
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .full
        
        var formattedTime = ""
        let today = Date()
        let postedDate = df.date(from: date)
        let timeDiff = postedDate?.secondsEarlier(than: today)
        
        //Seconds
        if(timeDiff! < 60){
            formattedTime = "\(timeDiff!)s"
        }
            //Minutes
        else if(timeDiff! < 3600){
            formattedTime = "\(timeDiff! / 60)m"
        }
            //Hours
        else if(timeDiff! < 86400){
            formattedTime = "\(timeDiff! / 60 / 60)h"
        }
            //Days
        else if(timeDiff! < 604800){
            formattedTime = "\(timeDiff! / 60 / 60 / 24)d"
        }
            //Simple date format
        else{
            df.dateStyle = .short
            df.timeStyle = .none
            formattedTime = df.string(from: df.date(from: date)!)
        }
        return formattedTime
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
