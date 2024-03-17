//
//  Views.swift
//  Codigo TMDB
//
//  Created by Ibrahim Baisa on 16/03/24.
//

import SwiftUI
import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.title)
            Text(movie.overview)
            Button(action: {
                viewModel.toggleFavorite(movie: movie)
            }) {
                Text(movie.isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
        .padding()
    }
}
