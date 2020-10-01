//
//  CastViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/28/20.
//

import UIKit

protocol CastViewControllerDelegate: class {
    func openPersonPage(viewModel: CastViewModel)
}

class CastViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var castsViewModel = CastsViewModel()
    private var castViewModels = [CastViewModel]()
    
    internal var showId: Int?
    
    weak var delegate: CastViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureViewModel()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(class: CastCell.self)
    }
    
    private func configureViewModel() {
        castsViewModel.isRefreshing = { loading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
        
        load(for: showId)
    }
    
    private func load(for showId: Int?) {
        castsViewModel.ready(for: showId)
        
        // callbacks response
        castsViewModel.didFetchCastsData = { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.castViewModels.append(contentsOf: data)
            DispatchQueue.main.async { strongSelf.collectionView.reloadData() }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CastCell.self, for: indexPath)
        cell.configure(with: castViewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CastViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openPersonPage(viewModel: castViewModels[indexPath.row])
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
        return .init(width: 100, height: 170)
    }
}
