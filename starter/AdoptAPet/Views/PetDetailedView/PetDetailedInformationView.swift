/// Copyright (c) 2024 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct PetDetailedInformationView: View {
  @Binding var pet: Pet
  @State private var isFavorite = false

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // Breed
      Text("Breed")
        .detailedInfoTitle()
      Text(pet.breed)
        .prefixedWithSFSymbol(named: "pawprint")


      // Characteristics
      Text("Characteristics")
        .detailedInfoTitle()
      Text(pet.characteristics)
        .prefixedWithSFSymbol(named: "theatermasks.circle")

      // Size
      Text("Size")
        .detailedInfoTitle()
      Text(pet.size)
        .prefixedWithSFSymbol(named: "flame")

      // Sex
      Text("Sex")
        .detailedInfoTitle()
      Text(pet.sex)
        .prefixedWithSFSymbol(named: "bolt.circle")

      // Age
      Text("Age")
        .detailedInfoTitle()
      Text(pet.age)
        .prefixedWithSFSymbol(named: "star")


      ColorPickerView(red: $pet.colorRed , green: $pet.colorGreen , blue: $pet.colorBlue )
        .padding()
    }
  }
}

//struct PetDetailedInformationView_Previews: PreviewProvider {
//  static var previews: some View {
//    PetDetailedInformationView(pet: Pet.example)
//  }
//}
