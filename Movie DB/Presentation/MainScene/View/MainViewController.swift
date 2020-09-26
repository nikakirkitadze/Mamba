//
//  ViewController.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/25/20.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func openDetails(showId: Int)
}

class MainViewController: BaseViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var shows = [TVShow]()
    private var showViewModels = [TVShowViewModel]()
    
    var isLoading = false
    var hasNextPage = false
    var paginated = true
    var currentPage = 1
    let paginationIndicatorInset: CGFloat = 25
    
    weak var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
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

    func load(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        hasNextPage = false
        
        TVShowServiceManager.fetchShows(page: page) { (data) in
            self.isLoading = false
            
            let dataViewModels = data.map({ TVShowViewModel(show: $0) })
            self.showViewModels.append(contentsOf: dataViewModels)
            
            if data.isEmpty {
                self.collectionView.contentInset.bottom = 50
            } else {
                self.hasNextPage = true
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
        delegate?.openDetails(showId: showViewModels[indexPath.row].id)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
            let inset = tabBarController?.tabBar.frame.height ?? 0
            collectionView.contentInset.bottom = inset + paginationIndicatorInset
            
            let background = UIView(frame: collectionView.bounds)
            let indicator = UIActivityIndicatorView(style: .white)
            
            indicator.startAnimating()
            background.addSubview(indicator)
            
            indicator.center = background.center
            indicator.frame.origin.y = background.frame.height - indicator.frame.height - (inset + 20)
            
            collectionView.backgroundView = background
            
            // wait two seconds to simulate some work happening
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("Should reomve bottom spinner")
                // then remove the spinner view controller
                indicator.stopAnimating()
//                background.removeFromSuperview()
            }
            
            currentPage += 1
            load(page: currentPage)
        }
    }
    
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
