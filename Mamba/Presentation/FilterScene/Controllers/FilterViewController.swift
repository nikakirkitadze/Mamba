//
//  FilterViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func filterShows(with params: [String:String])
}

class FilterViewController: UIViewController, FilterStoryboardLodable {
    
    // MARK: - IBoutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var sliderMinimumUserVote: UISlider!
    
    // MARK: - Private properties
    private var genresViewModel = GenresViewModel()
    private var genreViewModels = [GenreViewModel]()
    private var selectedGenres = [Int:Int]()

    private var filterParams = [String:String]() {
        didSet {
            delegate?.filterShows(with: filterParams)
        }
    }
    
    weak var coordinator: MainCoordinator?
    weak var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configureCollectionView()
        configureViewModel()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = Colors.mainBG
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
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .vertical
        }
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
    
    @IBAction func sliderValueChanged(_ slider: UISlider) {
        filterParams["vote_count.gte"] = "\(slider.value)"
    }
}

// MARK: - UICollectionViewDataSource
extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(GenreCell.self, for: indexPath)
        cell.configure(with: genreViewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Taptic.selection()
        
        collectionView.deselectItem(at: indexPath, animated: false)

        if genreViewModels[indexPath.row].selected {
            selectedGenres.removeValue(forKey: indexPath.row)
        } else {
            selectedGenres[indexPath.row] = genreViewModels[indexPath.row].id
        }
        
        genreViewModels[indexPath.row].selected = !genreViewModels[indexPath.row].selected
        collectionView.reloadItems(at: [indexPath])
        
        filterParams["with_genres"] = selectedGenres.values.map({"\($0)"}).joined(separator: ",")
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = genreViewModels[indexPath.row]
        let font = UIFont.named(.firaGoBook, size: 17)
        let size = tag.name.size(withAttributes: [NSAttributedString.Key.font: font])
        let dynamicCellWidth = size.width
        
        /*
         The "+ 20" gives me the padding inside the cell
         */
        return CGSize(width: dynamicCellWidth + 20, height: 35)
    }
    
    // Space between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // Space between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
