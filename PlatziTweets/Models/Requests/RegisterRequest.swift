//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by Jackson Cuevas on 3/8/24.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
