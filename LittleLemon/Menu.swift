//
//  Menu.swift
//  LittleLemon
//
//  Created by Carlos Martínez on 01/08/23.
//

import SwiftUI

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var selectedCategory = "all"
    
    var body: some View {
        VStack {
            VStack {
                Text("Little Lemon")
                    .foregroundColor(Color.primary)
                    .font(.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .top) {
                    VStack {
                        Text("Chicago")
                            .foregroundColor(Color.onSecondary)
                            .font(Font.title.weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("We are a family owned Mediterranean restaurant, focus on traditional recipes served with a modern twist.")
                            .foregroundColor(Color.onSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                    }
                    Spacer()
                    Image("Hero image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150.0)
                        .cornerRadius(8)
                        .clipped()
                }
                TextField("Search menu", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                    .background(Color.onSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Color.secondary)
            
            FetchedObjects(predicate: NSPredicate(value: true)) { (dishes: [Dish]) in
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing: 15) {
                        let categories = ["all"] + Array(Set(dishes.map { $0.category ?? "" })).sorted(by: <)
                        ForEach(categories, id: \.self) { category in
                            VStack(spacing: 0.0) {
                                Text(category.capitalized)
                                    .foregroundColor(selectedCategory == category ? .black : .gray)
                                    .padding(.horizontal, 16)
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                                if selectedCategory == category {
                                    Rectangle()
                                        .frame(height: 2.0)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
                }
            }
            
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(dish.title ?? "")
                                    .font(.title3.weight(.semibold))
                                Text(dish.dishDescription ?? "")
                                    .font(.body.weight(.thin))
                                    .padding(.vertical, 5)
                                Text("$\(dish.price ?? "")")
                                    .font(.body.weight(.medium))
                            }
                            Spacer(minLength: 10)
                            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 70, height: 70)
                        }
                    }
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    
    func getMenuData() {
        PersistenceController.shared.clear()
        let serverAddress = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: serverAddress)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                let recipes = try? decoder.decode(MenuList.self, from: data)
                recipes?.menu.forEach {
                    let dish = Dish(context: viewContext)
                    dish.title = $0.title
                    dish.image = $0.image
                    dish.price = $0.price
                    dish.category = $0.category
                    dish.dishDescription = $0.description
                }
                try? viewContext.save()
            }
        }
        task.resume()
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        let cleanText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filterMenuPredicate = selectedCategory == "all" ? NSPredicate(value: true) : NSPredicate(format: "category == %@", selectedCategory)
        let filterPredicate = cleanText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", cleanText)
        return NSCompoundPredicate(type: .and, subpredicates: [filterMenuPredicate, filterPredicate])
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
