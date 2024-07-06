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
            ZStack{
                BackgroundView()
                VStack
                {
                    //If the user is already logged in, go
                    //right to the WeatherView(). TODO: will
                    //need to get the location of the weather
                    //they have associated with their account.
                    WeatherView(accountViewModel: accountViewModel)

                    Spacer()
                    
                    //This button will be present for the Daily and Hourly
                    //views and allow the end user the ability to log
                    //out.
                    Button(
                        action:
                            {
                                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    withAnimation {
                                        accountViewModel.userID = ""
                                    }
                                } catch let signOutError as NSError {
                                    print("Error signing out: %@", signOutError)
                                }
                            },
                        label: {
                            Text("Log Off")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .bold()
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue)
                                )
                                .padding(.horizontal)
                                
                            
                        }
                    )
                }
                .background(Color.clear)
            }
        }
    }
}

#Preview {
    WeatherMonitorView()
}
