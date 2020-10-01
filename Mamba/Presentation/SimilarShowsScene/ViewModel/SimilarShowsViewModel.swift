//
//  SimilarShowsViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import Foundation

final class SimilarShowsViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didFetchSimilarShowsData: (([TVShowViewModel]) -> Void)?
    var didSelecteShow: ((TVShow) -> Void)?
    
    var numberOfRows: Int {
        return tvShows.count
    }
    
    private(set) var tvShows: [TVShow] = [TVShow]() {
        didSet {
            didFetchSimilarShowsData?(tvShows.map { TVShowViewModel(show: $0) })
        }
    }
    
    // Inputs
    func ready(for showId: Int?) {
        DispatchQueue.main.async {self.isRefreshing?(true)}
        guard let showId = showId else {return}
        TVShowServiceManager.fetchSimilarShows(id: showId) { [weak self] (data) in
            guard let strongSelf  = self else { return }
            strongSelf.finishShowsFetching(with: data)
        }
    }
    
    private func finishShowsFetching(with shows: [TVShow]) {
        DispatchQueue.main.async {self.isRefreshing?(false)}
        self.tvShows = shows
    }
}
