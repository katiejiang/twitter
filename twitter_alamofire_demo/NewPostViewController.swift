//
//  NewPostViewController.swift
//  twitter_alamofire_demo
//
//  Created by Katie Jiang on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    var delegate: NewPostViewControllerDelegate?
    let CHARACTER_LIMIT = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.af_setImage(withURL: User.current!.profileUrl!)
        
        tweetText.becomeFirstResponder()
        tweetText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = tweetText.text {
            let count = text.characters.count
            if count >= 140 {
                let index = text.index(text.startIndex, offsetBy: 140)
                tweetText.text = text.substring(to: index)
                characterCountLabel.text = "0"
            } else {
                characterCountLabel.text = String(describing: (CHARACTER_LIMIT - count))
            }
        } else {
            characterCountLabel.text = "140"
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onTapTweet(_ sender: Any) {
        if tweetText.text != nil {
            APIManager.shared.composeTweet(with: tweetText.text) { (tweet, error) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTap(_ sender: Any) {
//        view.endEditing(true)
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

protocol NewPostViewControllerDelegate {
    func did(post: Tweet)
}
