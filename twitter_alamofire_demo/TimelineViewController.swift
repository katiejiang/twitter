//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewPostViewControllerDelegate, TweetCellDelegate {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        updateTweets()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        updateTweets()
        refreshControl.endRefreshing()
    }
    
    func updateTweets() {
        print("getting from home timeline")
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                print(tweets)
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func did(post: Tweet) {
        updateTweets()
    }
    
    func tweetCell(_ tweetCell: TweetCell, didTap user: User) {
        performSegue(withIdentifier: "userSegue", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "newPostSegue" {
                let vc = segue.destination as! NewPostViewController
                vc.delegate = self
            } else if identifier == "tweetDetailsSegue" {
                let vc = segue.destination as! TweetDetailsViewController
                let cell = sender as! TweetCell
                vc.tweet = cell.tweet
            } else if identifier == "userSegue" {
                let vc = segue.destination as! ProfileViewController
                let user = sender as! User
                vc.user = user
            }
        }
    }
}
