//
//  CreateAccountView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//
import SwiftUI
import FirebaseAuth
struct AccountView: View {
    @FocusState private var isEmailFieldFocused: Bool
    @FocusState private var isPasswordFieldFocused: Bool
    @ObservedObject var accountViewModel: AccountViewModel //Contains the ViewModel logic for the AccountView
    
    var body: some View {

        ZStack{
            //Gradient background
            BackgroundView()
            VStack{
                //Weather Monitor title
                HStack{
                    Text ("Weather Monitor")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.top) //Pad the top of the view to get it off the notch
                Image(systemName: "cloud.sun.fill")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                //Email field
                EmailFieldView(isEmailFieldFocused: $isEmailFieldFocused, email: $accountViewModel.email)
                {
                    isEmailFieldFocused = false
                    isPasswordFieldFocused = true
                }
                
                //Password field
                PasswordFieldView(isPasswordFieldFocused: $isPasswordFieldFocused, password: $accountViewModel.password)
                {
                    isEmailFieldFocused = false
                    isPasswordFieldFocused = false
                    accountViewModel.logInOrCreateAccount() //Login or create account 
                }
                // Error message if unable to login
                if let authError = accountViewModel.authError {
                    Text(accountViewModel.accountView == .createAccount ? "Account Creation Error! Please Try Again" : "Invalid Login!!! Please Try Again!")
                        .foregroundColor(Color(red: 139/255, green: 0, blue: 0))
                        .padding()
                }

                
                
                //Create Account / Login button
                Button
                {
                    accountViewModel.logInOrCreateAccount()
                } label: {
                    Text(
                        accountViewModel.accountView == .createAccount ? "Create New Account" : "Login")
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                        
                        
                    )
                    .padding(.horizontal)
                    
                }
                .padding(.top)
                
                //Already have account / Login button flipper
                Button(action: {
                    //If they are clicking an authentication mode
                    //switch, we'll clear out the error to prevent
                    //the message from switching erroneously.
                    accountViewModel.authError = nil
                    if accountViewModel.accountView == .createAccount
                    {
                        accountViewModel.accountView = .logIn
                    }
                    else{
                        accountViewModel.accountView = .createAccount
                    }
                }, label: {
                    Text(accountViewModel.accountView == .createAccount ? "Already have an account?" : "Create an account?")
                        .foregroundColor(.black.opacity(0.8))
                })
                Spacer()
                
            }
            
            
        }


    }
}
