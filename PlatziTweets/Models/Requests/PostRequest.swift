//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
