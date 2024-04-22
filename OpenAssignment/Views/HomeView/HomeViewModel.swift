//
//  HomeViewModel.swift
//  OpenAssignment
//
//  Created by Varun Bagga on 12/04/24.
//

import Foundation


class HomeViewModel:ObservableObject{
    
    @Published var linksData :JSONData?
    @Published var isLoading = false
    @Published var topLinks: [Link]?
    @Published var recentLinks:[Link]?
    @Published var errorMessage = ""
    

    func fetchData() {
        isLoading = true
        let baseURL = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew")!
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI"
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            self?.isLoading = false
            guard let data = data, error == nil else {
                self?.errorMessage = error?.localizedDescription ?? "Unknown error"
                return
            }
            print("data\(data)")
            do {
                let decodedData = try JSONDecoder().decode(JSONData.self, from: data)
                //                print("decodedDAta \(decodedData)")
                DispatchQueue.main.async {
                    self?.linksData = decodedData
                    self?.recentLinks = decodedData.data.recentLinks
                    self?.topLinks = decodedData.data.topLinks
                }
                
            } catch {
                self?.errorMessage = error.localizedDescription
                print("getting error\(self?.errorMessage)")
            }
        }
        task.resume()
    }
    
  }
