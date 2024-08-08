//
//  LoginResponse.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import Foundation
struct LoginResponse: Codable {
    let user: User
    let token: String
}
