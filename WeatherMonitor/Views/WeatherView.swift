//
// WeatherView.swift : Assignment3
//
// Copyright © 2023 Auburn University.
// All Rights Reserved.
import SwiftUI

//This is the main view for the application and lists Birmingham's weather for
//the week. What makes this the main view is the scene manager designation in the
//Assignment3App file.
struct WeatherView: View {
    
    @ObservedObject var accountViewModel: AccountViewModel //Contains the ViewModel logic for the AccountView
    @StateObject private var viewModel = WeatherViewModel() //Specifies the view model of the MVVM architecture
    @State private var isShowingCitySearch = false // Controls the display of the city search view
    @State private var isShowingRadar = false // Controls the display of the radar view
    @State private var lastUpdated: String = "Never" //Stores when the last time the weather was last updated
    var body: some View
    {
        
        NavigationView
        {
            ZStack{
                BackgroundView() //Contains the gradient background
                
                //Header containing the city and information about the
                //current weather.
                VStack
                {
                    HStack{
                        Spacer()
                        HStack
                        {
                            //This button allows selection of a different city
                            Image(systemName: viewModel.getCurrentWeatherImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.white)
                            Text("\(accountViewModel.cityName)")
                                .font(.system(size: 28))
                                .bold()
                                .foregroundColor(.white)
                        }
                        Spacer()
                        HStack
                        {
                            //The following button allows selection of the city.
                            Button(action: {
                                isShowingCitySearch = true
                            }) {
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.white)
                            }
                            .sheet(isPresented: $isShowingCitySearch) {
                                CitySearchView(accountViewModel: accountViewModel, isShowingCitySearch: $isShowingCitySearch)
                                
                            }
                            .padding(.trailing, 10)
                        }.frame(width: 54, height: 48)
                    }
                    
                    //The following text items display current weather information
                    Text(viewModel.getCurrentCloudCoverString()!)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)

                    Text(viewModel.getCurrentWeatherTempAndHumidityString()!)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)

                    Text(viewModel.getCurrentWindSpeedString()!)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)

                    
                    
                    //Divider line between header and the list of of Days
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white)

                    //Displays the forecast for the current and next 6 days
                    List
                    {
                        if let daily = viewModel.weatherData?.daily
                        {
                            //Iterate throught each time item in the WeatherModel & populate a list with each day's
                            //weather forecast for the week.
                            ForEach(daily.time.indices, id: \.self)
                            { index in
                                //When the end user clicks the navigation link, pass in the hourly data and the
                                //selected time (to filter out hours that do not correlate with the selected date).
                                NavigationLink(destination: HourlyWeatherView(
                                    hourly: viewModel.weatherData!.hourly,
                                    selectedDate: daily.time[index] ))
                                {
                                    //Display the day of week card
                                    DayOfWeekView(daily: daily, index: index)
                                }
                                .foregroundColor(.black)
                            }
                            .listRowBackground(Color.clear) //Checked
                        }
                    }
                    
                    //If an error has occurred while fetching the data,
                    //an alert will be displayed on the UI.
                    .alert(isPresented: $viewModel.hasError)
                    {
                        Alert(title: Text("Error"), message: Text("Unknown Error"), dismissButton: .default(Text("OK")))
                    }
                    .listStyle(.plain) //Change ListStyle
                }
                .background(Color.clear)
            }
        }
        .tint(.black)
        .onAppear
        {
            UINavigationBar.appearance().tintColor = .white
            //Fetch the data from the WeatherViewModel. This is an
            //asynchronous call (similar to the way it is done with
            //TPM in .NET). The thread of execution will suspend here
            //(not block). So the rest of the UI can continue to load.
            Task
            {
                await viewModel.fetchData(latitude: accountViewModel.latitude,longitude: accountViewModel.longitude)
                lastUpdated = viewModel.getTimestamp()!
            }
        }
        .onChange(of: isShowingCitySearch) {
            // Fetch data when the city search sheet is dismissed.
            // This updates the view so that it updates the temps.
            Task {
                await viewModel.fetchData(latitude: accountViewModel.latitude, longitude: accountViewModel.longitude)
            }
        }
        .background(Color.clear)
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure NavigationView does not affect background
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let accountViewModel: AccountViewModel = AccountViewModel()
        WeatherView(accountViewModel: accountViewModel)
    }
}

