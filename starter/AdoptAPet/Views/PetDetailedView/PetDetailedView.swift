/// Copyright (c) 2022 Razeware LLC
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

struct PetDetailedView: View {
  var pet: Pet
  @State private var showingAlert = false
  @State private var adopt = false
  @State private var emailAddress = ""

  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack(alignment: .leading, spacing: 15) {
          ZStack(alignment: .bottom) {
            Image(pet.photo)
              .resizable()
              .scaledToFill()
              .frame(maxWidth: geometry.size.width, maxHeight: 300)
              .clipped()
            Rectangle()
              .overlay(alignment: .trailing) {
                Text("Photo by \(pet.photoAuthor)")
                  .foregroundColor(.white)
                  .font(.title2)
                  .padding(.trailing, 15)
              }
              .frame(maxWidth: geometry.size.width, maxHeight: 50)
              .opacity(0.6)
          }
          //Information view
          VStack(alignment: .leading, spacing: 8) {
            // Breed
            Text("Breed")
              .lineLimit(1)
              .font(.title2)
              .bold()
            HStack {
              Image(systemName: "pawprint")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
              Text(pet.breed)
            }
            .padding(.leading, 12)
            
            // Characteristics
            Text("Characteristics")
              .lineLimit(1)
              .font(.title2)
              .bold()
            HStack {
              Image(systemName: "theatermasks.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
              Text(pet.characteristics)
            }
            .padding(.leading, 12)
            
            // Size
            Text("Size")
              .lineLimit(1)
              .font(.title2)
              .bold()
            HStack {
              Image(systemName: "flame")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
              Text(pet.size)
            }
            .padding(.leading, 12)
            
            // Sex
            Text("Sex")
              .lineLimit(1)
              .font(.title2)
              .bold()
            HStack {
              Image(systemName: "bolt.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
              Text(pet.sex)
            }
            .padding(.leading, 12)
            
            // Age
            Text("Age")
              .lineLimit(1)
              .font(.title2)
              .bold()
            HStack {
              Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
              Text(pet.age)
            }
            .padding(.leading, 12)
          }
          .padding(.leading, 20)
          .padding(.bottom, 15)

          Divider()
            .padding(.horizontal, 16)

          AdoptionFormView()

          Spacer()
        }
      }
    }
  }
}

struct PetDetailedView_Previews: PreviewProvider {
  static var previews: some View {
    PetDetailedView(pet: Pet.example)
  }
}
