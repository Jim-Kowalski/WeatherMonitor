//
//  EmailFieldView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//

import SwiftUI

struct EmailFieldView: View {
    @FocusState.Binding var isEmailFieldFocused: Bool //This variation allows the FocusState variable to be passed in to the view.
    @Binding var email: String
    
    var onEnterPressed: () -> Void //Closure back to AccountView so we can advance to the next field on submission
    
    var body: some View {
        HStack{
            Image(systemName: "mail")
            ZStack(alignment: .leading){
                if email.isEmpty
                {
                    Text("Enter Email")
                        .foregroundColor(isEmailFieldFocused ?  .white: Color(UIColor.lightText) )
                }
                TextField("", text: $email)
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .focused($isEmailFieldFocused)
                    .onSubmit {
                        // Closure back to the AccountView so that we can advance
                        // to the next field
                        onEnterPressed()
                    }
                
            }
            Spacer()
            
            //If the number of letters typed into the email
            //TextField is greater than zero validate.
            if (email.count != 0) {
                Image(systemName: isValidEmail(email) ? "checkmark" : "xmark")
                    .foregroundColor(isValidEmail(email) ? .blue : .red)
                
            }
        }
        .foregroundColor(.white)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: isEmailFieldFocused ? 3 : 2)
                .foregroundColor(.blue)
            
        )
        .padding()
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

