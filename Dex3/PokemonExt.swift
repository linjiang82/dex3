//
//  PokemonExt.swift
//  Dex3
//
//  Created by Jiang Lin on 11/12/2023.
//

import Foundation

extension Pokemon{
  var background: String {
    switch self.types?.first{
    case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
      return "rockgroundsteelfightingghostdarkpsychic"
    case "normal", "grass", "electric", "poison", "fairy":
      return "normalgrasselectricpoisonfairy"
    case "fire", "dragon":
      return "firedragon"
    case "flying", "bug":
      return "flyingbug"
    case "water":
      return "water"
    default:
      return "normalgrasselectricpoisonfairy"
    }
  }
  var stats:[Stat] {
    [
      Stat(id: 1, label: "HP", value: self.hp),
      Stat(id: 2, label: "Attack", value: self.attack),
      Stat(id: 3, label: "Speed", value: self.speed),
      Stat(id: 4, label: "SpecialAttack", value: self.specialAttack),
      Stat(id: 5, label: "Defense", value: self.defense),
      Stat(id: 6, label: "SpecialDefense", value: self.specialDefense),
    ]
  }
  
  var highestStat: Stat {
    self.stats.max { $0.value < $1.value }!
  }
}


struct Stat: Identifiable {
let id: Int
let label: String
  let value: Int16
  
}
