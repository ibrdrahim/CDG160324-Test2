//
//  DetailsMovie.swift
//  Codigo TMDB
//
//  Created by Ibrahim Baisa on 16/03/24.
//

import Combine
import RealmSwift

class MovieDetailViewModel: ObservableObject {
    var movie: Movie

    @Published var isFavorite: Bool

    init(movie: Movie) {
        self.movie = movie
        self.isFavorite = movie.isFavorite
    }
    
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }

    func toggleFavorite() {
        do {
            try realm.write {
                movie.isFavorite = !movie.isFavorite
                realm.add(movie, update: .modified)
            }
            isFavorite = movie.isFavorite
        } catch {
            print("Error saving favorite state: \(error)")
        }
    }
}

