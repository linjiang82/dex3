//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Jiang Lin on 11/12/2023.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
  @EnvironmentObject var pokemon: Pokemon
  @State var showShiny:Bool = false
  var body: some View {
    ScrollView {
      ZStack {
        
        Image(pokemon.background)
          .resizable()
          .scaledToFit()
          .shadow(color: .black, radius: 6)
        AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite){image in
          image
            .resizable()
            .scaledToFit()
            .frame(width: 300)
            .padding([.top], 150)
            .shadow(color: .black, radius: 6)
          
        } placeholder: {
          ProgressView()
        }
        
      }
      HStack{
        
        ForEach(pokemon.types!, id: \.self){type in
          Text(type.capitalized)
            .font(.title2)
            .shadow(color:.white, radius: 1)
            .padding([.top, .bottom], 7)
            .padding([.trailing, .leading])
            .background(Color(type.capitalized))
            .cornerRadius(50)
        }
        Spacer()
        Button(action: {
          pokemon.favourite.toggle()
          do {
            try PersistenceController.shared.container.viewContext.save()
          } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
          }
        }, label: {
          Image(systemName: pokemon.favourite ? "star.fill" : "star")
        })
      }
      .padding()
      
      Text("Stats")
        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        .padding(.bottom, -5)
      
      StatChart().environmentObject(pokemon)
    }
    .padding(.bottom)
    .navigationTitle(pokemon.name!.capitalized)
    .toolbar{
      ToolbarItem{
        Button{
          showShiny.toggle()
        } label: {
          
          if showShiny {
            Image(systemName: "wand.and.stars")
              .foregroundStyle(.yellow)
          } else {
            Image(systemName:"wand.and.stars.inverse" )
            
          }        }
      }
    }
  }
}

#Preview {
  PokemonDetail()
    .environmentObject(SamplePokemon.samplePokemon)
}
