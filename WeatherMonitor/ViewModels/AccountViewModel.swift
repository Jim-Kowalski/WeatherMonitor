//
//  AccountViewModel.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//
import SwiftUI
import FirebaseAuth
enum accountViewMode
{
    case createAccount
    case logIn
}
class AccountViewModel: ObservableObject {
    @Published var email: String = "" //Specifies the variable used to store the email (bound to the EmailFieldView)
    @Published var password: String = "" //Specifies the variable used to store the password (bound to the PasswordFieldView)
    @AppStorage("uid") var userID: String = "" //Contains the userID
    @Published var authError: String? //Contains authentication error's localized error string
    @Published var accountView: accountViewMode = .createAccount //Specifies the view mode for the AccountView

    
    //This funcion attempts to create a new account.
    func createAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.authError = error.localizedDescription
                return
            }
            if let authResult = authResult {
                self.userID = authResult.user.uid
                self.clearFields()
                self.navigateToWeatherView()
            }
        }
    }
    //This funcion attempts to log the end-user in.
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.authError = error.localizedDescription
                return
            }
            if let authResult = authResult {
                self.userID = authResult.user.uid
                self.clearFields()
                self.navigateToWeatherView()
                
            }
        }
    }
    //This function clears the email and password fields.
    func clearFields() {
        email = ""
        password = ""
        authError = nil
    }
    
    //This function will log the user in or attempt to create
    //an account depending on the state of accountState.
    func logInOrCreateAccount()
    {
        if self.accountView == .createAccount
        {
            self.createAccount()
        }
        else
        {
            self.logIn()
        }
    }
    
    private func navigateToWeatherView() {
        WeatherView()
    }
}

