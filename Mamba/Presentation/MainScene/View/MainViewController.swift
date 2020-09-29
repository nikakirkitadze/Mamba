//
//  MainViewController.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func openDetails(pass viewModel: TVShowViewModel)
}

class MainViewController: BaseViewController, MainStoryboardLodable {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var fieldSearch: MambaSearchField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var constraingCollectionViewTopMargin: NSLayoutConstraint!
    
    // MARK: - Private properties
    private var viewModel = TVShowsViewModel()
    private var showViewModels = [TVShowViewModel]()
    private var isLoading = false
    private var hasNextPage = false
    private var paginated = true
    private var currentPage = 1
    private let paginationIndicatorInset: CGFloat = 35 //25
    private var isSearchOpen = false
    private var searchText: String?
    private var searchAfterDelay = 0.3
    
    weak var delegate: MainViewControllerDelegate?
    weak var coordinator: MainCoordinator?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBarButton()
        configureFieldSearch()
        configureCollectionView()
        configureViewModel()
        load(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isBackgroundHidden = false
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(class: TVShowCell.self)
    }
    
    private func configureViewModel() {
        viewModel.isRefreshing = { loading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }
    
    func load(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        hasNextPage = false
        
        // calls api
        viewModel.ready(for: page)
        
        // callbacks response
        viewModel.didFetchShowsData = { [weak self] shows in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            
            strongSelf.spinner.stopAnimating()
            
            if shows.isEmpty {
                strongSelf.collectionView.contentInset.bottom = 50
            } else {
                strongSelf.hasNextPage = true
            }
            
            strongSelf.showViewModels.append(contentsOf: shows)
            DispatchQueue.main.async { strongSelf.collectionView.reloadData() }
        }
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(TVShowCell.self, for: indexPath)
        cell.size = itemSize(cv: collectionView)
        cell.configure(with: showViewModels[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Taptic.light()
        coordinator?.details(with: showViewModels[indexPath.row])
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let isIpad = UIDevice.isIpad
        return isIpad ? UIEdgeInsets(top: 60, left: 90, bottom: 60, right: 90) : UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize(cv: collectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard paginated else { return }
        
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        let height = scrollView.contentSize.height
        let reloadDistance: CGFloat = 10
        if y > height + reloadDistance && !isLoading && hasNextPage {
            collectionView.contentInset.bottom = paginationIndicatorInset
            
            let background = UIView(frame: collectionView.bounds)
            let indicator = UIActivityIndicatorView(style: .white)
            
            indicator.startAnimating()
            background.addSubview(indicator)
            
            indicator.center = background.center
            indicator.frame.origin.y = background.frame.height - indicator.frame.height - 20
            
            collectionView.backgroundView = background
            
            // wait two seconds to simulate some work happening
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("Should reomve bottom spinner")
                // then remove the spinner view controller
                indicator.stopAnimating()
                //                background.removeFromSuperview()
            }
            
            currentPage += 1
            isSearchOpen ? loadSearch(page: currentPage) : load(page: currentPage)
        }
    }
}

// MARK: Search
extension MainViewController {
    private func addSearchBarButton() {
        let barButtonSearch = UIBarButtonItem(image: UIImage(named: "ic-search"), style: .plain, target: self, action: #selector(onToggleSearch(_:)))
        barButtonSearch.tintColor = .white
        navigationItem.rightBarButtonItem = barButtonSearch
    }
    
    @objc private func onToggleSearch(_ sender: UIBarButtonItem) {
        constraingCollectionViewTopMargin.constant = isSearchOpen ? 0 : 54 + 5 + 5
        _ = isSearchOpen ? fieldSearch.resignFirstResponder() : fieldSearch.becomeFirstResponder()
        isSearchOpen.toggle()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureFieldSearch() {
        fieldSearch.mambaFieldEditingChanged = { [weak self] query in
            guard let strongSelf = self else {return}
            strongSelf.searchText = query
            NSObject.cancelPreviousPerformRequests(withTarget: strongSelf, selector: #selector(strongSelf.search), object: nil)
            strongSelf.perform(#selector(strongSelf.search), with: nil, afterDelay: strongSelf.searchAfterDelay)
        }
    }
    
    @objc private func search() {
        // clear dataset
        showViewModels.removeAll()
        spinner.startAnimating()
        
        // search for page = 1
        loadSearch()
    }
    
     private func loadSearch(page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        hasNextPage = false
        
        // calls api
        guard let query = searchText else {return}
        viewModel.search(with: query, and: page)
        
        // callbacks response
        viewModel.didFetchShowsData = { [weak self] shows in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            
            strongSelf.spinner.stopAnimating()
            
            if shows.isEmpty {
                strongSelf.collectionView.contentInset.bottom = 50
            } else {
                strongSelf.hasNextPage = true
            }
            
            strongSelf.showViewModels.append(contentsOf: shows)
            DispatchQueue.main.async { strongSelf.collectionView.reloadData() }
        }
    }
}
