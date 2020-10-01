//
//  SimilarShowsViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import UIKit

protocol SimilarShowsViewControllerDelegate: class {
    func openDetail(with viewModel: TVShowViewModel)
}

class SimilarShowsViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var showsViewModel = SimilarShowsViewModel()
    private var showViewModels = [TVShowViewModel]()
    
    weak var delegate: SimilarShowsViewControllerDelegate?
    var showId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureViewModel()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(class: TVShowCell.self)
    }
    
    private func configureViewModel() {
        showsViewModel.isRefreshing = { loading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
        
        load(for: showId)
    }
    
    private func load(for showId: Int?) {
        showsViewModel.ready(for: showId)
        
        // callbacks response
        showsViewModel.didFetchSimilarShowsData = { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.showViewModels.append(contentsOf: data)
            DispatchQueue.main.async { strongSelf.collectionView.reloadData() }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SimilarShowsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(TVShowCell.self, for: indexPath)
        cell.size = itemSize(cv: collectionView, defaultSize: false)
        cell.configure(with: showViewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SimilarShowsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openDetail(with: showViewModels[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SimilarShowsViewController: UICollectionViewDelegateFlowLayout {
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
