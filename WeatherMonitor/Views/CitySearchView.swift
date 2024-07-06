//
//  CitySearchView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/29/24.
//

import SwiftUI

struct CitySearchView: View {
    @ObservedObject var accountViewModel: AccountViewModel //Contains the ViewModel logic for the AccountView
    @StateObject private var viewModel = CitySearchViewModel()
    @FocusState private var isCityFieldFocused: Bool //FocusState variable that indicates when the city field has focus.
    @FocusState private var isStateFieldFocused: Bool //FocusState variable that indicates when the state field has focus
    @State private var selectedCity: CityModel? // Specifies the selected city
    @State private var isShowingCityList = false // Controls the display of the city list sheet
    @Binding var isShowingCitySearch: Bool //Binding to the variable in WeatherView indicating this sheet is displayed
    
    var body: some View {
        NavigationView
        {
            ZStack
            {
                BackgroundView()
                VStack
                {
                    //Weather Monitor title
                    HStack
                    {
                        Text ("City Selection")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                    .background(Color.clear) // Make the VStack background clear
                    .padding(.top) //Pad the top of the view to get it off the notch
                    TextField("Enter city", text: $viewModel.city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($isCityFieldFocused)
                        .onSubmit {
                            isCityFieldFocused=false
                            isStateFieldFocused=true
                        }
                    TextField("Enter state", text: $viewModel.state)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($isStateFieldFocused)
                        .onSubmit {
                            isCityFieldFocused=false
                            isStateFieldFocused=false
                            Task {
                                await viewModel.fetchCities()
                                if !viewModel.cities.isEmpty
                                {
                                    isShowingCityList = true // Show the city list sheet
                                }
                            }
                            
                        }
                    Spacer()
                        .frame(height:20)
                    
                    Button(action: {
                        Task {
                            await viewModel.fetchCities()
                            if !viewModel.cities.isEmpty
                            {
                                isShowingCityList = true // Show the city list sheet
                            }
                        }
                    }) {
                        Text("Search")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue))
                    }
                    Spacer()
                }
                .padding()
                .sheet(isPresented: $isShowingCityList) {
                    CityListView(accountViewModel: accountViewModel, viewModel: viewModel, selectedCity: $selectedCity, isShowingCityList: $isShowingCityList, isShowingCitySearch: $isShowingCitySearch)
                }
                .alert(isPresented: $viewModel.hasError) {
                    Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "An error occurred"), dismissButton: .default(Text("OK")))
                }
            }
        }.onAppear
        {
            isCityFieldFocused=true
        }
    }
}

