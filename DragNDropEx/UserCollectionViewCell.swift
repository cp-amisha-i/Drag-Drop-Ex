//
//  UserCollectionViewCell.swift
//  DragNDropEx
//
//  Created by Amisha I on 23/08/22.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    class var ID: String { String(describing: Self.self) }
    class var NIB: UINib { .init(nibName: String(describing: Self.self), bundle: .main) }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var itemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3 - (30)).isActive = true
    }
}
