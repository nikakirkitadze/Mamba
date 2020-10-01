//
//  FilterViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import UIKit

class FilterViewController: UIViewController, FilterStoryboardLodable {
    
    // MARK: - IBoutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var genresViewModel = GenresViewModel()
    private var genreViewModels = [GenreViewModel]()
    private var sizingCell: GenreCell?
    
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        configureCollectionView()
        configureViewModel()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(class: GenreCell.self)
    }
    
    private func configureViewModel() {
        genresViewModel.isRefreshing = { loading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
        
        // api call
        genresViewModel.ready()
        
        // callbacks response
        genresViewModel.didFetchGenresData = { [weak self] genres in
            guard let strongSelf = self else { return }
            strongSelf.genreViewModels.append(contentsOf: genres)
            DispatchQueue.main.async { strongSelf.collectionView.reloadData() }
            DispatchQueue.main.async { strongSelf.collectionView.layoutIfNeeded() }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(GenreCell.self, for: indexPath)
        cell.setMaximumCellWidth(collectionView.frame.width)
        cell.configure(with: genreViewModels[indexPath.row])
        Log.debug(cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        genreViewModels[indexPath.row].selected = !genreViewModels[indexPath.row].selected
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.deque(GenreCell.self, for: indexPath)
        return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 0, right: 24)
    }
}
