//
//  CastsViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import Foundation

final class CastsViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didFetchCastsData: (([CastViewModel]) -> Void)?
    var didSelecteShow: ((Cast) -> Void)?
    
    var numberOfRows: Int {
        return casts.count
    }
    
    private(set) var casts: [Cast] = [Cast]() {
        didSet {
            didFetchCastsData?(casts.map { CastViewModel(cast: $0) })
        }
    }
    
    // Inputs
    func ready(for showId: Int?) {
        DispatchQueue.main.async {self.isRefreshing?(true)}
        guard let showId = showId else {return}
        TVShowServiceManager.fetchCasts(showId: showId) { [weak self] (data) in
            guard let strongSelf  = self else { return }
            strongSelf.finishCastsFetching(with: data)
        }
    }
    
    private func finishCastsFetching(with casts: [Cast]) {
        DispatchQueue.main.async {self.isRefreshing?(false)}
        self.casts = casts
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if casts.isEmpty { return }
        didSelecteShow?(casts[indexPath.row])
    }
}
