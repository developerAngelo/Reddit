//
//  Community.swift
//  Reddit
//
//  Created by Angelo Acero on 5/9/21.
//

import Foundation

struct CommunityData: Decodable{
    let kind: String
    let data: Listing
}

struct Listing: Decodable {
    let dist: Int
    let children: [Child]
}

struct Child: Decodable {
    let data: ChildData
    let kind: String
}

struct ChildData: Decodable {
    let display_name_prefixed: String?
    let header_img: String?
    let display_name: String?
    let title: String
    let community_icon: String?
    let icon_img: String?
}
