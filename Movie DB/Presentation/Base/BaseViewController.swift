//
//  BaseViewController.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.mainBG
        configureNavBar()
    }

    private func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.backgroundColor = .clear
    }
}

// MARK: CollectionView
extension BaseViewController {
    func itemSize(cv: UICollectionView) -> CGSize {
        guard let flowLayout = cv.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let minItemSize = self.minItemSize()
        
        var width: CGFloat = 0
        let sectionInset = CGFloat(30)
        let spacing = flowLayout.scrollDirection == .horizontal ? flowLayout.minimumLineSpacing : flowLayout.minimumInteritemSpacing
        
        for items in (2...Int.max) {
            let items = CGFloat(items)
            let newWidth = (view.bounds.width/items) - (sectionInset/items) - (spacing * (items - 1)/items)
            if newWidth < minItemSize.width && items > 2 // Minimum of 2 cells no matter the screen size
            {
                break
            }
            width = newWidth
        }
        
        let ratio = width/minItemSize.width
        let height = minItemSize.height * ratio
        
        return CGSize(width: width, height: height)
    }
    
    func minItemSize() -> CGSize {
        return CGSize(width: 108, height: 185)
    }
}
