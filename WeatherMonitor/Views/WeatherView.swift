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
    @StateObject private var viewModel = WeatherViewModel() //Specifies the view model of the MVVM architecture
    var body: some View
    {
        NavigationView
        {
            List
            {
                if let daily = viewModel.weatherData?.daily
                {
                    Text("Coming soon: Select different cities!")
                        .bold()
                        
                    //Iterate throught each time item in the WeatherModel & populate a list with each day's
                    //weather forecast for the week.
                    ForEach(daily.time.indices, id: \.self)
                    { index in
                        //When the end user clicks the navigation link, pass in the hourly data and the
                        //selected time (to filter out hours that do not correlate with the selected date).
                        NavigationLink(destination: HourlyWeatherView(hourly: viewModel.weatherData!.hourly,
                                                                      selectedDate: daily.time[index] ))
                        {
                            //Display the day of week card
                            DayOfWeekView(daily: daily, index: index)
                            
                        }
                        
                    }
                    
                }
            }
            .onAppear
            {
                //Fetch the data from the WeatherViewModel. This is an
                //asynchronous call (similar to the way it is done with
                //TPM in .NET). The thread of execution will suspend here
                //(not block). So the rest of the UI can continue to load.
                Task
                {
                    await viewModel.fetchData()
                }
            }
            .navigationTitle("")
            .toolbar
            {
                //Set the title of the view.
                ToolbarItem(placement: .principal)
                {
                    VStack
                    {
                        Text("Birmingham Weather")
                            .font(.system(size: 32))
                            .bold()
                        
                    }
                    .padding(.top)
                    
                }
                
            }
            //If an error has occurred while fetching the data,
            //an alert will be displayed on the UI.
            .alert(isPresented: $viewModel.hasError)
            {
                Alert(title: Text("Error"), message: Text("Unknown Error"), dismissButton: .default(Text("OK")))
            }
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

