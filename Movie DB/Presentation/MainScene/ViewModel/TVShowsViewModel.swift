//
//  TVShowsViewModel.swift
//  Movie DB
//
//  Created by Nika Kirkitadze on 9/26/20.
//

import Foundation

final class TVShowsViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didFetchShowsData: (([TVShowViewModel]) -> Void)?
    var didSelecteShow: ((TVShow) -> Void)?
    
    var numberOfRows: Int {
        return tvShows.count
    }
    
    private(set) var tvShows: [TVShow] = [TVShow]() {
        didSet {
            didFetchShowsData?(tvShows.map { TVShowViewModel(show: $0) })
        }
    }
    
    // Inputs
    func ready(for page: Int = 1) {
        DispatchQueue.main.async {self.isRefreshing?(true)}
        TVShowServiceManager.fetchShows(page: page) { [weak self] (data) in
            guard let strongSelf  = self else { return }
            strongSelf.finishShowsFetching(with: data)
        }
    }
    
    private func finishShowsFetching(with shows: [TVShow]) {
        DispatchQueue.main.async {self.isRefreshing?(false)}
        self.tvShows = shows
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if tvShows.isEmpty { return }
        didSelecteShow?(tvShows[indexPath.row])
    }
}
