//
//  Codigo_TMDBApp.swift
//  Codigo TMDB
//
//  Created by Ibrahim Baisa on 16/03/24.
//

import SwiftUI

@main
struct Codigo_TMDBApp: App {
    let viewModel: MovieViewModel = MovieViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
