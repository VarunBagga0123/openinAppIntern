//
//  homeView.swift
//  OpenAssignment
//
//  Created by Varun Bagga on 12/04/24.
//

import SwiftUI

struct homeView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State var selectedTab = 1
    var body: some View {
        ZStack{
            VStack() {
                HStack{
                    Text("Dashboard")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                    Image("Settings")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding()
                .padding(.top,30)

                Spacer()
                
                ScrollView{
                    VStack(alignment: .leading,spacing: 28){

                        VStack(alignment: .leading){
                            Text("Good Morning")
                                .font(.system(size: 23))
                                .foregroundStyle(.gray.opacity(0.9))

                            Text("Varun Bagga")
                                .font(.system(size: 30))
                        }

                        ScrollView(.horizontal) {
                            HStack{
                                if let clicks = homeViewModel.linksData?.todayClicks{
                                    cellView(image: "clickicon1", title:"Today's click" , subtitle:"\(clicks)" )
                                }else{
                                    cellView(image: "clickicon1", title:"Today's click" , subtitle:"\(0)" )
                                }
                                
                                if let location = homeViewModel.linksData?.topLocation{
                                    cellView(image: "location", title: "Top Location", subtitle: location)
                                }
                                
                                if let topSources = homeViewModel.linksData?.topSource{
                                    cellView(image: "webicon", title: "Top source", subtitle: topSources)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)

                        HStack{
                            Spacer()
                            Image("priceicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("View Analytics")
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 0.5))
                            .fill(.black.opacity(0.5))
                        )

                        HStack(alignment:.center){

                            Text("Top Links")
                                .bold()
                                .foregroundColor(selectedTab == 1 ? .white : .black.opacity(0.4))
                                .padding(.horizontal)
                                .padding(.vertical,8)
                                .background( selectedTab == 1 ? .blue : .clear)
                                .cornerRadius(18)
                                .onTapGesture {
                                    if selectedTab == 1 {
                                        selectedTab = 0
                                    } else{
                                        withAnimation {
                                            selectedTab = 1
                                        }
                                     
                                    }
                                }

                            Spacer()

                            Text("Recent Links")
                                .bold()
                                .foregroundColor(selectedTab == 2 ? .white : .black.opacity(0.4))
                                .padding(.horizontal)
                                .padding(.vertical,8)
                                .background( selectedTab == 2 ? .blue : .clear)
                                .cornerRadius(18)
                                .onTapGesture {
                                    if selectedTab == 2 {
                                        selectedTab = 0
                                    } else{
                                        withAnimation {
                                            selectedTab = 2
                                        }
                                    }
                                }

                            Spacer()
                            Spacer()
                            
                            Image("searchicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36,height: 36)
                        }


                        VStack(alignment:.leading, spacing:28) {
                            if selectedTab == 1 {
                                if let topLinks = homeViewModel.topLinks {
                                    ForEach(topLinks) { item in
                                        linkInfoCell(item: item)
                                    }
                                }
                            }
                            
                            if selectedTab == 2 {
                                if let recentLinks = homeViewModel.recentLinks {
                                    ForEach(recentLinks) { item in
                                        linkInfoCell(item:item)
                                    }
                                }
                            }
                            
                        }
                        .padding(.top)
                        
                        HStack{
                            Spacer()
                            Image("linkicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("View all Links")
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 0.5))
                            .fill(.black.opacity(0.5))
                        )
                        
                    }
                    .padding()
                }
                .frame(maxWidth: UIScreen.main.bounds.width,alignment: .leading)
                .background(Color(hex: "#F5F5F5"))
                .cornerRadius(25)
            }
            .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
            .background(Color(hex: "#0E6FFF"))
            .padding()
            .onAppear {
                homeViewModel.fetchData()
                print("hello")
            }
        }
        
    }
    
    func getImageData(url:String) -> UIImage? {
        var image:UIImage? = nil
        DispatchQueue.main.async {
          
            if let url = URL(string:url){
                URLSession.shared.dataTask(with: url){ (data,response,error) in
                    
                    guard let gifData = data else {return}
                    
                    image = UIImage(data: gifData)
                }.resume()
            }
        }
        return image
    }
                        
    func dateFormatter(date: String) -> String? {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: "2023-03-15T07:33:50.000Z")
        let normalDateFormatter = DateFormatter()
        normalDateFormatter.dateFormat = "MMM dd, yyyy"
        let normalDateString = normalDateFormatter.string(from: date!)
        return normalDateString
    }
}


struct cellView: View{
    var image: String
    var title: String
    var subtitle: String
    
    var body: some View{
        VStack(alignment: .leading){
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
           
                Text(subtitle)
                    .bold()
                    .padding(.top)
                    .padding(.bottom,4)
            
            
            Text(title)
                .opacity(0.5)
           
        }
        .frame(width:120, height:120)
        .background(.white)
        .cornerRadius(8)
    }
}

struct linkInfoCell: View {
    
    var item:Link?
    @State var image:UIImage?
    var body: some View{
        VStack(alignment:.leading,spacing:0) {
            if let item = item {
                HStack(alignment:.center){
                    if let image = image {
                        Image(uiImage:image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } else{
                        ProgressView {
                            Image(systemName: "swift")
                        }
                    }
                   
                    
                    VStack(alignment:.leading){
                        Text(item.title)
                            .lineLimit(1)
                        
                        if let date = dateFormatter(date: item.createdAt) {
                            Text(date)
                        }else{
                            Text("heloo")
                        }
                    }
                    .padding(.bottom,3)
                    
                    Spacer()
                    
                    VStack(alignment:.trailing){
                        Text("\(item.totalClicks)")
                        Spacer()
                        Text("Clicks")
                    }
                    .padding(.bottom,3)
                    
                }
                .padding(.vertical)
                .padding(.horizontal,5)
                .cornerRadius(10)
                .background(.white)
                .cornerRadius(10)
                .offset(y:10)
                
                ZStack(alignment: .leading) {
                    
                    BottomRoundedRectangle(cornerRadius: 8, borderWidth: 2, dashLength: 3, dashGap: 5)
                        .background(Color(hex:"#E8F1FF"))
                        .foregroundColor(Color(hex:"#A6C7FF"))
                    HStack(alignment: .center){
                        Text(item.smartLink)
                            .lineLimit(1)
                            .padding()
                        Spacer()
                        
                        Image("copyicon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24,height: 24)
                    }
                    .padding(.trailing)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
        .onAppear{
            if self.image == nil {
                self.getImageData(url: self.item?.originalImage ?? "")
            }
        }
    }
    
    func getImageData(url:String) {
        DispatchQueue.main.async {
            if let url = URL(string:url){
                URLSession.shared.dataTask(with: url){ (data,response,error) in
                    guard let gifData = data else {return}
                    self.image = UIImage(data: gifData)
                }.resume()
            }
        }
    }
                        
    func dateFormatter(date: String) -> String? {
        let dateString = date

        // Create a date formatter for parsing the original date string
        let dateFormatter = DateFormatter()

        // Set the date format to the format of the given date string.
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        // Parse the given date string into a Date object.
        let date = dateFormatter.date(from: dateString)

        // Create a new DateFormatter object to format the date in a normal format.
        let normalDateFormatter = DateFormatter()

        // Set the date format to the desired normal date format.
        normalDateFormatter.dateFormat = "MMM dd, yyyy"

        // Format the date object into a normal date string.
        let normalDateString = normalDateFormatter.string(from: date!)
        return normalDateString
    }
}


struct BottomRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let dashLength: CGFloat
    let dashGap: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from top-left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))

        // Draw top edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        // Draw right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        // Draw bottom-right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)

        // Draw bottom edge
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))

        // Draw bottom-left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)

        // Close the path
        path.closeSubpath()

        return path
    }

    var body: some View {
        GeometryReader { geometry in
            self.path(in: CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height))
                .stroke(style: StrokeStyle(lineWidth: borderWidth, dash: [dashLength, dashGap]))
        }
    }
}

#Preview {
    homeView()
}
