//
//  CommunityTableViewCell.swift
//  Reddit
//
//  Created by Angelo Acero on 5/9/21.
//

import UIKit
import SDWebImage

class CommunityTableViewCell: UITableViewCell {

    @IBOutlet weak var communityImage: UIImageView!
    @IBOutlet weak var communityTitle: UILabel!
    
    var post: CommunityTableViewCellViewModel?{
        didSet{
            guard  let post = post  else { return }
            communityTitle.text = post.display_name_prefixed
            guard let urlString = post.icon_img,
                  !urlString.isEmpty, urlString != "",
                  let url = URL(string: urlString)
                  else { self.communityImage.image = UIImage(named: "blankImage")
                        return }
            communityImage.sd_setImage(with: url, completed: nil)
            
        }
    }
    
}

