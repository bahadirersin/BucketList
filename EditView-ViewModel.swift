//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Bahadır Ersin on 10.03.2023.
//

import Foundation

extension EditView{
    @MainActor class EditViewModel:ObservableObject{
        
        enum LoadingState{
            case loading,loaded,failed
        }
        
        @Published var loadingState:LoadingState
        @Published var pages:[Page]
        var location: Location
        
        init(location:Location){
            loadingState = .loading
            pages = [Page]()
            self.location = location
        }
        
        func fetchNearbyPlaces() async{
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else{
                print("Bad URL")
                return
            }
            
            do{
                let (data,_) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            }catch{
                loadingState = .failed
            }
        }
        
    }
}
