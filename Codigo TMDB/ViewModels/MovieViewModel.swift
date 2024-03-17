//
//  UpcomingMovies.swift
//  Codigo TMDB
//
//  Created by Ibrahim Baisa on 16/03/24.
//

import RealmSwift
import Alamofire
import Combine
import Reachability

class MovieViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let realm: Realm
    private let service: MovieAPIService
    private let reachability = try! Reachability()

    @Published var movies: Results<Movie>
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isOffline = false
    private var notificationToken: NotificationToken?
    
    private var upcomingMoviesCache: [Movie] = []
    private var popularMoviesCache: [Movie] = []

    init(realm: Realm = try! Realm(), service: MovieAPIService = .shared) {
        self.realm = realm
        self.service = service
        movies = realm.objects(Movie.self)
        observeDatabaseChanges()
        observeReachability()
        if reachability.connection != .unavailable {
            fetchMovies(endpoint: "upcoming", isPopular: false)
            fetchMovies(endpoint: "popular", isPopular: true)
        }
    }
    
    deinit {
        notificationToken?.invalidate()
        reachability.stopNotifier()
    }

    private func observeReachability() {
        reachability.whenReachable = { [weak self] _ in
            guard let self = self else { return }
            if !self.upcomingMoviesCache.isEmpty {
                self.updateDatabase(with: self.upcomingMoviesCache)
                self.upcomingMoviesCache.removeAll()
            }
            if !self.popularMoviesCache.isEmpty {
                self.updateDatabase(with: self.popularMoviesCache)
                self.popularMoviesCache.removeAll()
            }
            self.isOffline = false
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.isOffline = true
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    func fetchMovies(endpoint: String, isPopular: Bool) {
        print("fetchMovies started")
        isLoading = true
        service.fetchMovies(endpoint: endpoint) { [weak self] result in
            defer { self?.isLoading = false }
            switch result {
            case .success(let movieResponse):
                var movies = movieResponse.results
                if isPopular {
                    movies = movies.map { movie in
                        let modifiedMovie = movie
                        modifiedMovie.id *= 1000
                        modifiedMovie.isPopular = true
                        return modifiedMovie
                    }
                }
                if self?.reachability.connection != .unavailable {
                    self?.updateDatabase(with: movies)
                } else {
                    if isPopular {
                        self?.popularMoviesCache = movies
                    } else {
                        self?.upcomingMoviesCache = movies
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func observeDatabaseChanges() {
        notificationToken = movies.observe { [weak self] changes in
            switch changes {
            case .initial, .update:
                self?.objectWillChange.send()
            case .error(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func updateDatabase(with movies: [Movie]) {
        do {
            try realm.write {
                for movie in movies {
                    if checkMovieByID(id: movie.id) == nil {
                        realm.add(movie, update: .error)
                    }
                }
            }
        } catch {
            errorMessage = "Failed to update database"
        }
    }
    
    private func checkMovieByID(id: Int) -> Movie? {
        return realm.object(ofType: Movie.self, forPrimaryKey: id)
    }
    
    func toggleFavorite(movie: Movie) {
        do {
            try realm.write {
                movie.isFavorite.toggle()
            }
        } catch {
            errorMessage = "Failed to toggle favorite status"
        }
    }
}
