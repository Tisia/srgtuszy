//
//  Repository.swift
//  srgtuszy
//
//  Created by admin on 9/9/21.
//

import Foundation

struct Repository: Codable {
    struct Item: Codable {
        struct Owner: Codable {
            var login: String
            var avatarUrl: URL
        }
        var name: String
        var description: String?
        var htmlUrl: URL?
        var owner: Owner
    }
    var items: [Item]
}
