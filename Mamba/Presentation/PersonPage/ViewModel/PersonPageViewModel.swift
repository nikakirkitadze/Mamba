//
//  PersonPageViewModel.swift
//  Mamba
//
//  Created by Nika Kirkitadze on 9/29/20.
//

import Foundation

final class PersonPageViewModel {
    
    // MARK: - Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didFetchPersonData: ((PersonViewModel) -> Void)?
    
    private(set) var person: Person! {
        didSet {
            didFetchPersonData?(PersonViewModel(person: person))
        }
    }
    
    // Inputs
    func ready(with personId: Int) {
        DispatchQueue.main.async {self.isRefreshing?(true)}
        
        PersonServiceManager.getPerson(by: personId) { [weak self] (person) in
            guard let strongSelf  = self else { return }
            strongSelf.finishShowsFetching(with: person)
        }
    }
    
    private func finishShowsFetching(with person: Person) {
        DispatchQueue.main.async {self.isRefreshing?(false)}
        self.person = person
    }
}
