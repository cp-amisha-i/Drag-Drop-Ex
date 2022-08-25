//
//  FoodItemCollectionViewCell.swift
//  DragNDropEx
//
//  Created by Amisha I on 23/08/22.
//

import UIKit

class FoodItemCollectionViewCell: UICollectionViewCell {

    class var ID: String { String(describing: Self.self) }
    class var NIB: UINib { .init(nibName: String(describing: Self.self), bundle: .main) }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
        containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20 - 20).isActive = true
    }
}
