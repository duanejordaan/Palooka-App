//
//  Post.swift
//  Palooka
//
//  Created by Duane Jordaan on 2017/07/16.
//  Copyright © 2017 Duane Jordaan. All rights reserved.
//

import Foundation
class Post {
    var caption: String
    var photoUrl: String
    
    init(captionText: String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
    }
}
