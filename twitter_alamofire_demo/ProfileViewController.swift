//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Katie Jiang on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet] = []
    var user: User! = User.current
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTweets()
        updateProfile()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Make profile picture circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func updateProfile() {
        if let user = user {
            if let profileUrl = user.profileUrl {
                profileImageView.af_setImage(withURL: profileUrl)
            }
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
            bioLabel.text = user.bio
            tweetsLabel.text = String(describing: user.tweetCount!)
            followingLabel.text = String(describing: user.followingCount!)
            followersLabel.text = String(describing: user.followersCount!)
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        updateTweets()
        refreshControl.endRefreshing()
    }
    
    func updateTweets() {
        // TODO: change this to user timeline
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "tweetDetailsSegue" {
                let vc = segue.destination as! TweetDetailsViewController
                let cell = sender as! TweetCell
                vc.tweet = cell.tweet
            }
        }
    }
}
