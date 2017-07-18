//
//  Post.swift
//  Palooka
//
//  Created by Duane Jordaan on 2017/07/16.
//  Copyright © 2017 Duane Jordaan. All rights reserved.
//

import Foundation
class Post {
    var caption: String?
    var photoUrl: String?
    var courseName: String?
    var gross: String?
    var score: String?
    
}

extension Post {
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.courseName = dict["courseName"] as? String
        post.gross = dict["gross"] as? String
        post.score = dict["score"] as? String
        
        return post
    }
    
    static func transformPostVideo() {
        
    }
}
