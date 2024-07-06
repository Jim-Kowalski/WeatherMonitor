//
//  CityListView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/29/24.
//

import SwiftUI

struct CityListView: View {
    @ObservedObject var accountViewModel: AccountViewModel //Contains the ViewModel logic for the AccountView
    @ObservedObject var viewModel: CitySearchViewModel
    
    @Binding var selectedCity: CityModel?
    @Binding var isShowingCityList: Bool
    @Binding var isShowingCitySearch: Bool
    
    var body: some View {
        
        NavigationView {
            ZStack{
                BackgroundView()
                
                VStack {
                    // Custom toolbar
                    HStack {
                        Text("Select City")
                            .font(.system(size: 28))
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .background(Color.clear)
                    .padding(.top, 10) // Adjust this padding to move the toolbar down
                    .padding(.horizontal)
                    
                    //Divider line
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)
                    
                    
                    List(viewModel.cities) { city in
                        Button(action: {
                            selectedCity = city
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(city.name)
                                        .font(.headline)
                                    if let state = city.admin1 {
                                        Text(state)
                                            .font(.subheadline)
                                    }
                                    if let country = city.country_code {
                                        Text(country)
                                            .font(.subheadline)
                                    }
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("Lat: \(city.latitude, specifier: "%.2f")")
                                    Text("Long: \(city.longitude, specifier: "%.2f")")
                                }
                            }
                            .foregroundColor(selectedCity?.id == city.id ? Color(red: 0, green: 0, blue: 139/255) : .black)
                            .background(selectedCity?.id == city.id ? Color.white.opacity(0.4) : Color.clear)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain) //Change ListStyle
                    
                    Spacer()
                    
                    Button(action: {
                        // Dismiss the sheet
                        if let selectedCity = selectedCity {
                            // Update the selected city
                            accountViewModel.updateSelectedCity(newCityName: selectedCity.name, newStateName: selectedCity.admin1 ?? "", newLatitude: selectedCity.latitude, newLongitude: selectedCity.longitude)
                            withAnimation(nil) {
                                isShowingCityList = false
                            }
                            withAnimation(nil) {
                                isShowingCitySearch = false
                            }
                        } else {
                            // Provide feedback if no city is selected (optional)
                            // For example, show an alert or print a message
                            print("No city selected")
                        }
                        
                        
                    }) {
                        Text("OK")
                            .foregroundColor(.white)
                        
                            .font(.system(size: 16))
                            .bold()
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                            )
                            .padding(.horizontal)
                    }
                    .padding()
                    
                }
                
            }
            
        }
    }
}
