//
//  APIHandler.swift
//  Reddit
//
//  Created by Angelo Acero on 5/9/21.
//

import Foundation

class APIHandler {
    static var shared = APIHandler()
    
    func fetchPosts(completion: @escaping([CommunityTableViewCellViewModel]?) -> Void) {
        guard let url = URL(string: "https://www.reddit.com/subreddits/.json") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else{return}
            do{
                let postModels = try JSONDecoder().decode(CommunityData.self, from: data)
                let mappedPosts = postModels.data.children.compactMap({
                    CommunityTableViewCellViewModel(display_name_prefixed: $0.data.display_name_prefixed, header_img: $0.data.header_img, display_name: $0.data.display_name, title: $0.data.title, community_icon: $0.data.community_icon, icon_img: $0.data.icon_img)
                })
                completion(mappedPosts)
            }
            catch{
                completion(nil)
            }
        }
        task.resume()
    }
}
