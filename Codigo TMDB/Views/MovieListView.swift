import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    let navigationTitle:String
    let isPopular:Bool
    
    var body: some View {
        List {
            ForEach(viewModel.movies.filter { !$0.isPopular }) { movie in
                NavigationLink(destination: MovieDetailsView(viewModel: viewModel, movie: movie)) {
                    Text(movie.title)
                }
            }
        }
        .navigationTitle(navigationTitle)
        .padding()
    }
}
