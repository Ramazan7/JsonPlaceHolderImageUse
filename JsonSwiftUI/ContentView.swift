//
//  ContentView.swift
//  JsonSwiftUI
//
//  Created by Admin on 25.06.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var posts: [Post] = []
    
    var body: some View {
        NavigationView{
            List(posts) { post in
                VStack {
                    Text(post.title).fontWeight(.bold).foregroundColor(.blue)
                    Image(systemName: "person.fill")
                        .data(url: URL(string: post.url)!)
                        .frame(width: 150, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }.onAppear() {
                Api().getPost { (posts) in
                    self.posts = posts
                }
            }.navigationBarTitle("Posts")
        }
    }
}

struct Post: Codable, Identifiable {
    let id = UUID()
    var title: String
    var url: String
}

class Api {
    func getPost(complection: @escaping ([Post]) -> ()){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else{return}
        
        URLSession.shared.dataTask(with: url) { (data, _,_) in
            
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            DispatchQueue.main.async {
                complection(posts)
            }
            
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Image URL
extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
