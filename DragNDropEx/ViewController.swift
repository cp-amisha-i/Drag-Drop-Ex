//
//  ViewController.swift
//  DragNDropEx
//
//  Created by Amisha I on 23/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var userCollectionView: UICollectionView!

    let foods: [Food] = [.init(id: 1, name: "Pizza", price: 20, image: "pizza"),
                               .init(id: 2, name: "Pasta", price: 13, image: "pasta"),
                               .init(id: 6, name: "Burger", price: 10, image: "burger"),
                               .init(id: 7, name: "Sizzler", price: 50, image: "sizzler")]

    var users: [User] = [.init(id: 1, name: "John", image: "person1", amount: 0, items: 0),
                         .init(id: 2, name: "Daizy", image: "person2", amount: 0, items: 0),
                         .init(id: 3, name: "Tom", image: "person3", amount: 0, items: 0)]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.register(FoodItemCollectionViewCell.NIB, forCellWithReuseIdentifier: FoodItemCollectionViewCell.ID)

        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userCollectionView.register(UserCollectionViewCell.NIB, forCellWithReuseIdentifier: UserCollectionViewCell.ID)

        foodCollectionView.dragDelegate = self
        userCollectionView.dropDelegate = self
    }
}


// MARK: - UICollectionViewDataSource Methods
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == foodCollectionView {
            return foods.count
        } else {
            return users.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == foodCollectionView {
            return foodCollectionView(collectionView, cellForItemAt: indexPath)
        } else {
            return userCollectionView(collectionView, cellForItemAt: indexPath)
        }
    }

    private func foodCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodItemCollectionViewCell.ID, for: indexPath) as! FoodItemCollectionViewCell
        cell.layer.cornerRadius = 20
        cell.name.text = foods[indexPath.item].name
        cell.price.text = "$" + String(foods[indexPath.item].price)
        cell.imageView.image = UIImage(named: foods[indexPath.item].image)
        return cell
    }

    private func userCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.ID, for: indexPath) as! UserCollectionViewCell
        cell.layer.cornerRadius = 20
        cell.userName.text = users[indexPath.item].name
        cell.totalAmount.isHidden = users[indexPath.item].amount == 0
        cell.totalAmount.text = "$" + String(users[indexPath.item].amount)
        cell.itemLabel.isHidden = users[indexPath.item].amount == 0
        cell.itemLabel.text = String(users[indexPath.item].items) + " items"
        cell.imageView.image = UIImage(named: users[indexPath.item].image)
        cell.containerView.backgroundColor = users[indexPath.item].isHighlighted ? .lightGray : .white
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout Methods
extension ViewController: UICollectionViewDelegateFlowLayout {

    // To put inset to the collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 20, bottom: 0, right: 20)
    }
}


// MARK: - UICollectionViewDragDelegate Methods
extension ViewController: UICollectionViewDragDelegate {

    // Get dragItem from the indexpath
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemPrice = String(foods[indexPath.item].price)
        let itemProvider = NSItemProvider(object: itemPrice as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = itemPrice
        return [dragItem]
    }

    // To only select needed view as preview instead of whole cell
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == foodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodItemCollectionViewCell.ID, for: indexPath) as! FoodItemCollectionViewCell
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: cell.imageView.frame.minX, y: cell.imageView.frame.minY, width: cell.imageView.frame.width + 30, height: cell.imageView.frame.height + 30), cornerRadius: 20)
            return previewParameters
        }
        return nil
    }
}


// MARK: - UICollectionViewDropDelegate Methods
extension ViewController: UICollectionViewDropDelegate {

    // Get the position of the dragged data over the collection view changed
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView == userCollectionView, let indexPath = destinationIndexPath {
            users.indices.forEach { users[$0].isHighlighted = false }
            users[indexPath.item].isHighlighted = true
            collectionView.reloadData()
        }
        return UICollectionViewDropProposal(operation: .copy)
    }

    // Update collectionView after ending the drop operation
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        users.indices.forEach { users[$0].isHighlighted = false }
        collectionView.reloadData()
    }

    // Called when the user initiates the drop operation
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }

        if collectionView == userCollectionView {
            if coordinator.proposal.operation == .copy {
                copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            }
        }
    }

    // Actual logic which perform after drop the view
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        collectionView.performBatchUpdates {
            for (_, item) in coordinator.items.enumerated() {
                if collectionView === userCollectionView {
                    let productPrice = item.dragItem.localObject as? String
                    if let price = productPrice, let intPrice = Int(price) {
                        users[destinationIndexPath.item].amount += intPrice
                        users[destinationIndexPath.item].items += 1
                        UIView.performWithoutAnimation {
                            collectionView.reloadSections(IndexSet(integer: 0))
                        }
                    }
                }
            }
        }
    }
}
