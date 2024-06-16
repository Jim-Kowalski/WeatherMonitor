//
//  PasswordFieldView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//

import SwiftUI
//This view handles the UI for the password field.
struct PasswordFieldView: View {
    @FocusState.Binding var isPasswordFieldFocused: Bool //This variation allows the FocusState variable to be passed in to the view.
    @Binding var password: String //Bound to the TextField or SecureField, depending on the password visibility.
    @State private var isPasswordVisible: Bool = false //Flag to indicate that the password is visible. (TODO: if the field loses focus, should go invisible)
    
    var onEnterPressed: () -> Void //Closure back to AccountView so we can advance to the next field when the end-user presses the enter key.
    
    var body: some View {
        HStack{
            Image(systemName: "lock")
            
            ZStack(alignment: .leading){
                if password.isEmpty
                {
                    Text("Enter Password")
                        .foregroundColor(isPasswordFieldFocused ?  .white: Color(UIColor.lightText) )
                }
                if isPasswordVisible {
                    TextField("", text: $password)
                        .foregroundColor(.white)
                        .keyboardType(.default)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                        .focused($isPasswordFieldFocused)
                        .onSubmit {
                            // Closure back to the AccountView so that we can advance
                            // to the next field
                            onEnterPressed()
                        }
                    
                }
                else
                {
                    SecureField("", text: $password)
                        .foregroundColor(.white)
                        .keyboardType(.default)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                        .focused($isPasswordFieldFocused)
                        .onSubmit {
                            // Closure back to the AccountView so that we can advance
                            // to the next field
                            onEnterPressed()
                        }
                }
            }
            Spacer()
            if (password.count != 0)
            {
                //This button displays/hides the password when clicked
                Button(action: {
                    isPasswordVisible.toggle()
                    
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.blue)
                }
                
                Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                    .foregroundColor(isValidPassword(password) ? .blue : .red)
                
            }
        }
        .foregroundColor(.white)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: isPasswordFieldFocused ? 3 : 2)
                .foregroundColor(.blue)
        )
        .padding()
    }
    private func isValidPassword(_ pasword: String) -> Bool
    {
        // minimum 6 characters long
        // 1 upercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
}
