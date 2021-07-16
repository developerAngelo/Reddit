//
//  CommunityViewModel.swift
//  Reddit
//
//  Created by Angelo Acero on 5/9/21.
//


import Foundation
import RxCocoa

struct CommunityTableViewCellViewModel {
    let display_name_prefixed: String?
    let header_img: String?
    let display_name: String?
    let title: String
    let community_icon: String?
    let icon_img: String?
} 

final class CommunityViewModel: NSObject {
    var posts: BehaviorRelay<[CommunityTableViewCellViewModel]> = BehaviorRelay(value: [])
    
    override init() {
        super.init()
        
        APIHandler.shared.fetchPosts(completion: { posts in
            guard let posts = posts else { return }
            self.posts.accept(posts)
        })
    }
    
}
