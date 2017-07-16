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
}

extension Post {
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        return post
    }
    
    static func transformPostVideo() {
        
    }
}
