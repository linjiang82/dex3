//
//  StatChart.swift
//  Dex3
//
//  Created by Jiang Lin on 11/12/2023.
//

import SwiftUI
import CoreData
import Charts

struct StatChart: View {
  
  @EnvironmentObject var pokemon: Pokemon
  
  var body: some View {
    Chart{
      ForEach(pokemon.stats){stat in
        BarMark(x: .value("value", stat.value), y: .value("Stat", stat.label) )
          .annotation(position: .trailing){
            Text("\(stat.value)")
              .font(.footnote)
              .foregroundStyle(.secondary)
          }
      }
    }
    .frame(height: 200)
    .padding([.leading, .bottom, .trailing])
    .foregroundStyle(Color(pokemon.types!.first!.capitalized))
    .chartXScale(domain: 0...pokemon.highestStat.value+5)
  }
}

#Preview {
  return StatChart()
    .environmentObject(SamplePokemon.samplePokemon)
}
