//
//  TweetHomeTableViewCell.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 9/8/24.
//

import UIKit
import Kingfisher
class TweetHomeTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // NOTA IMPORTANTE
    // Las celdas NUNCA deben invocar ViewController!
    
    @IBAction func openVideoAction() {
        guard let videoUrl = videoUrl else {
            return
        }
        
        needsToShowVideo?(videoUrl)
    }
    
    // MARK: - Properties
    private var videoUrl: URL?
    var needsToShowVideo: ((_ url: URL) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCellWith(post: Post) {
        videoButton.isHidden = !post.hasVideo
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        messageLabel.text = post.text
        
        if post.hasImage {
            // configurar imagen
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        } else {
            tweetImageView.isHidden = true
        }
        
        videoUrl = URL(string: post.videoUrl)
    }
}
