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
import MessageUI

struct AdoptionFormView: View {
  @State private var showingAlert = false
  @State private var adopt = false
  @State var isShowingMailView = false
  @StateObject var emailValidator = EmailValidator()
  @State var result: Result<MFMailComposeResult, Error>? = nil
  @Binding var colorRed: Float
  @Binding var colorGreen: Float
  @Binding var colorBlue: Float
  
  var body: some View {
    VStack(alignment: .leading) {
      Section {
        TextField("Email address", text: $emailValidator.email)
          .validateEmail(value: emailValidator.email) { email in
            emailValidator.isValid(email)
          }
          .textFieldStyle(.roundedBorder)
          .padding()
          .autocorrectionDisabled()
          .keyboardType(.emailAddress)
          .textInputAutocapitalization(.never)
      } header: {
        Text("Please enter your email address")
          .font(.callout)
          .padding(.leading, 16)
      }

      VStack(alignment: .center) {
        Button {
          isShowingMailView = true
        } label: {
          Text("Adopt Me")
        }
        .alert("Thank you!", isPresented: $showingAlert) {
          Button("OK", role: .cancel) {}
        }
        .buttonStyle(PrimaryButtonStyle())
      }
      .frame(maxWidth: .infinity)
    }
    .sheet(isPresented: $isShowingMailView) {
      MailView(isShowing: self.$isShowingMailView, result: self.$result, receipients: [emailValidator.email], messageBody: "I want a pet with this colors: Red \(colorRed), Blue \(colorBlue), Green \(colorGreen)")
    }
  }
}
//
//struct AdoptionFormView_Previews: PreviewProvider {
//  static var previews: some View {
//    AdoptionFormView()
//  }
//}
