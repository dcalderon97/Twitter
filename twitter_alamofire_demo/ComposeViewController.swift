//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Daniel Calderon on 3/6/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import UITextView_Placeholder
protocol ComposeViewControllerDelegate : NSObjectProtocol {
    
    func did(post: Tweet)
}
class ComposeViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    weak var delegate: ComposeViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.isUserInteractionEnabled = false
        tweetButton.setTitleColor(UIColor.gray, for: .normal)
        textView.placeholder = "What's Happening?"
        textView.placeholderColor = UIColor.lightGray
        profileImageView.af_setImage(withURL: (User.current?.profilePictureURL)!)
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        
        textView.becomeFirstResponder()
        textView.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        //Tweet then dismiss
        APIManager.shared.composeTweet(with: textView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            tweetButton.isUserInteractionEnabled = false
            tweetButton.setTitleColor(UIColor.gray, for: .normal)
        }
        else{
            tweetButton.isUserInteractionEnabled = true
            tweetButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        countLabel.text = "\(characterLimit - newText.count)"
        // The new text should be allowed? True/False
        return newText.count < characterLimit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
