//
//  EditView.swift
//  BucketList
//
//  Created by Bahadır Ersin on 8.03.2023.
//

import SwiftUI

struct EditView: View {
    
    @StateObject var viewModel:EditViewModel
    
    @State private var name:String
    @State private var description:String
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place Name", text:$name)
                    TextField("Place Description", text:$description)
                }
                
                Section("Nearby"){
                    switch viewModel.loadingState{
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id:\.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Failed to load")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar{
                Button("Save"){
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }.task{
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location:Location, onSave: @escaping (Location)-> Void){
        _viewModel = StateObject(wrappedValue: EditViewModel(location: location))
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example){_ in}
    }
}
