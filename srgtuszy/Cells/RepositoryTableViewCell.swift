//
//  RepositoryTableViewCell.swift
//  srgtuszy
//
//  Created by admin on 9/9/21.
//

import UIKit

final class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var authorNameLabel: UILabel!
    @IBOutlet private var authorAvatarImageView: UIImageView! {
        didSet {
            authorAvatarImageView.layoutIfNeeded()
            authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.frame.size.width / 2
            authorAvatarImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        authorNameLabel.text = nil
        authorAvatarImageView.image = nil
    }
    
    public func setRepositoryItem(_ repository: Repository.Item?) {
        titleLabel.text = repository?.name
        descriptionLabel.text = repository?.description
        authorNameLabel.text = repository?.owner.login
        authorAvatarImageView.load(url: repository?.owner.avatarUrl)
    }
}


