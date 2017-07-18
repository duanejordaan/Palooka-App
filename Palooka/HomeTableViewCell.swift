//
//  HomeTableViewCell.swift
//  Palooka
//
//  Created by Duane Jordaan on 2017/07/17.
//  Copyright © 2017 Duane Jordaan. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var gross: UILabel!
    @IBOutlet weak var score: UILabel!
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        gross.text = post?.gross
        score.text = post?.score
        courseName.text = post?.courseName
        captionLabel.text = post?.caption
        profileImageView.image = UIImage(named: "photo3.jpeg")
        nameLabel.text = "Duane"
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
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
