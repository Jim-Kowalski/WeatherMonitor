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
    @Published var accountView: accountViewMode = .createAccount //Specifies the view mode for the AccountView
    @Published var authError: String? //Contains authentication error's localized error string
    @Published var email: String = "" //Specifies the variable used to store the email (bound to the EmailFieldView)
    @Published var password: String = "" //Specifies the variable used to store the password (bound to the PasswordFieldView)

    @AppStorage("uid") var userID: String = "" //Contains the userID
    @AppStorage("latitude") var latitude: Double = 33.1857 //Specifies the latitude of the city the end user sleected
    @AppStorage("longitude") var longitude: Double = -87.2647 //Specifies the longitude of the city the end user sleected
    @AppStorage("city") var cityName: String = "Birmingham" // Specifies the city's name
    @AppStorage("state") var stateName: String = "Alabama" // Specifies the state's name

    
    //This function updates the city selection for the AccountViewModel
    func updateSelectedCity(newCityName: String, newStateName: String, newLatitude: Double, newLongitude: Double)
    {
        self.cityName = newCityName
        self.stateName = newStateName
        self.latitude = newLatitude
        self.longitude = newLongitude
    }
    
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
        WeatherView(accountViewModel: self)
    }
}

