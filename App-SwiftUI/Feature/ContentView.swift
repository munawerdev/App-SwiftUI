//
//  ContentView.swift
//  swiftUi_practice_project
//
//  Created by Syed Munawer Ali on 30/08/2026.
//

import SwiftUI
import MapKit

struct ContentView: View{
    
    @Environment(\.openURL) private var openUrl
    @State var logicModel : LogicCheckModel = LogicCheckModel()
    @State var isToggle: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.timeZone) var timeZone
    
    @State var logic=Logic()
    @State var region = MKCoordinateRegion(center: .init(latitude: 37.334722, longitude: -122.008889), latitudinalMeters: 300, longitudinalMeters: 300)

    var body: some View {
        let _ = Self._printChanges()
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://picsum.photos/200/300"))
                {
                    image in image.resizable()
                }
                placeholder: {
                    ProgressView()
                }
                
                Toggle("Is Active", isOn: $logicModel.isOn)
                    .padding(.horizontal, 50)
                HStack {
                    DayForecast(
                        day: "Mon",
                        image: "cloud.sun.fill",
                        high: 70,
                        low: 50
                    )
                    DayForecast(
                        day: "Tue",
                        image: "sun.max.fill",
                        high: 60,
                        low: 40
                    )
                    
                }
                
                Button("Open website") {
                    openUrl(
                        URL(
                            string: "https://google.com"
                        )!
                    )
                }
            }
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text("Hello World")
                .bold()
                .italic()
                .underline()
                .lineLimit(2)
                .foregroundColor(.red)
            Text("Hello\nWorld! \(logic.isToggle)").multilineTextAlignment(.center)
            Slider(value: .constant(0.5), in: 0...1)
            //        colorScheme == .dark ?
            //        Color.white.ignoresSafeArea() :
            //        Color.black.ignoresSafeArea()
            Text("\(timeZone)").font(Font.body.bold())
            Text("Hellowrld")
                .opacity(logic.isToggle ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: logic.isToggle)
            Label("Swift", image: "Logo")
            Label("Website", systemImage: "globe")
            Button("Toggle") {
                logic.isToggle.toggle()
            }
            Text("SwiftUI").padding()
                   .toolbar {
                       ToolbarItem(placement: .principal) {
                           VStack {
                               Text("Title")
                               Button("Clickable Subtitle") { print("principle") }
                           }
                       }
                   }
            
            Map(coordinateRegion: $region).frame(height: 300)

            
        }
    }
}

struct DayForecast: View {
    let day: String
    let image: String
    let high: Int
    let low: Int
    
    var imageColor: Color {
        switch image {
        case "cloud.sun.fill":
            return .blue
        case "sun.max.fill":
            return .yellow
        default:
            return .gray
        }
    }
    
    var body: some View {
        
        VStack {
            
            Text(day).font(Font.system(size: 20)).bold()
            Image(systemName: image).foregroundStyle(imageColor).font(
                Font.system(size: 50)
            )
            Text("High: \(high)").font(Font.system(size: 20)).bold().italic()
            Text("Low: \(low)").foregroundStyle(Color.gray)
        }.padding()
        
    }
}

#Preview {
    ContentView()
}

@Observable
class LogicCheckModel {
  var isOn: Bool = false
}

@Observable
class Logic {
    var isToggle = false
    
}

