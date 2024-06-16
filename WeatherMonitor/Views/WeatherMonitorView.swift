//
//  WeatherMonitorView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//

import SwiftUI
import FirebaseAuth
struct WeatherMonitorView: View {
    @StateObject private var accountViewModel = AccountViewModel()
    
    var body: some View {
        
        //If the user is not already logged in,
        //display the AccountView().
        if accountViewModel.userID.isEmpty
        {
            AccountView(accountViewModel: accountViewModel)
                .onAppear{
                    accountViewModel.accountView = .logIn
                }
        }
        else
        {
            //If the user is already logged in, go
            //right to the WeatherView(). TODO: will
            //need to get the location of the weather
            //they have associated with their account.
            WeatherView()
            Button(action: {
                let firebaseAuth = Auth.auth()
                
                //TODO: perhaps this belongs in the ViewModel.
                do {
                    try firebaseAuth.signOut()
                    withAnimation {
                        accountViewModel.userID = ""
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }
                   ,label: {
                Text("Log Out")
            })
        }
    }
}

#Preview {
    WeatherMonitorView()
}
