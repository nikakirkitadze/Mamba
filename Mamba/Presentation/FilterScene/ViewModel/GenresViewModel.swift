//
//  GenresViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 10/1/20.
//

import Foundation

final class GenresViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didFetchGenresData: (([GenreViewModel]) -> Void)?
    var didSelecteGenre: ((Genre) -> Void)?
    
    private(set) var tvShowGenres: [Genre] = [Genre]() {
        didSet {
            didFetchGenresData?(tvShowGenres.map { GenreViewModel(genre: $0) })
        }
    }
    
    var numberOfRows: Int {
        return tvShowGenres.count
    }
    
    // Inputs
    func ready(for page: Int = 1) {
        DispatchQueue.main.async {self.isRefreshing?(true)}
        GenresServiceManager.tvGenresList { [weak self]  (data) in
            guard let strongSelf  = self else { return }
            strongSelf.finishGenresFetching(with: data)
        }
    }
    
    private func finishGenresFetching(with genres: [Genre]) {
        DispatchQueue.main.async {self.isRefreshing?(false)}
        self.tvShowGenres = genres
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if tvShowGenres.isEmpty { return }
        didSelecteGenre?(tvShowGenres[indexPath.row])
    }
}
