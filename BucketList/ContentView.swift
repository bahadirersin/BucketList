//
//  ContentView.swift
//  BucketList
//
//  Created by Bahadır Ersin on 7.03.2023.
//
import MapKit
import SwiftUI

struct ContentView: View {
    
@StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked{
            ZStack{
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations){ location in
                    MapAnnotation(coordinate: location.coordinate){
                        VStack{
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width:22,height:22)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .padding(4)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .background(.red.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                        
                    }
                }.ignoresSafeArea()
                
                Circle()
                    .stroke(.white,lineWidth:2)
                    .background(.blue)
                    .opacity(0.4)
                    .frame(width:32,height:32)
                    .clipShape(Circle())
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            viewModel.addLocation()
                        }label:{
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .clipShape(Circle())
                        .padding([.trailing,.bottom])
                        
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace){ place in
                EditView(location: place){ newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        }else{
            Button("Unlock"){viewModel.authenticate()}
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
