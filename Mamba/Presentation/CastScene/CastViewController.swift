//
//  CastViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/28/20.
//

import UIKit

class CastViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(class: CastCell.self)
    }
}

// MARK: - UICollectionViewDataSource
extension CastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CastCell.self, for: indexPath)
//        cell.size = itemSize(cv: collectionView, defaultSize: false)
//        cell.configure(with: showViewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CastViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: Margins.leading, bottom: 0, right: Margins.trailing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 180)
    }
}
