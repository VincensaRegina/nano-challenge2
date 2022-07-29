//
//  ContentView.swift
//  nano-challenge2
//
//  Created by Vincensa Regina on 26/07/22.
//

import SwiftUI
import CoreData

struct Notes: Hashable {
    let name: String
    let heading: [String]
}

struct ContentView: View {
    let notes: [Notes] = [
        .init(name: "Mini Challenge 1",
              heading: ["Market Research", "General Info"]),
        .init(name: "Nano Challenge 1",
              heading: ["Swift Syntaxes", "General Info"])
    ]
    var body: some View {
        NavigationView {
            NotesListView()
            NotesNavigationView()
            NotesContentView()
        }
    }
}

struct NotesListView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    //
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    @State private var searchText = ""
    let notes = ["Mini Challenge 1", "Mini Challenge 2"]
    
    var body: some View {
        VStack {
            Text("Notes").bold().font(.largeTitle).foregroundColor(Color("TitleColor"))
                .frame(minWidth: 250, idealWidth: 250, alignment: .leading)
                .padding(.init(top: 15, leading: 10, bottom: 0, trailing: 0))
            
            List {
                ForEach(searchResults, id: \.self) { item in
                    NavigationLink (destination: Text(item)){
                        HStack {
                            Text(item)
                            Spacer()
                            Button {
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .searchable(text: $searchText,placement: .sidebar, prompt: "Search")
            
        }
        
        .background(Color("NotesListColor"))
        .navigationTitle("Notes TTTTT")
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.lowercased().contains(searchText) }
        }
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
}

struct NotesNavigationView: View {
    var body: some View {
        Text("Notes").bold().font(.largeTitle).foregroundColor(Color("TitleColor"))
            .frame(minWidth: 250, idealWidth: 250, alignment: .leading)
            .padding(.init(top: 15, leading: 10, bottom: 0, trailing: 0))
    }
}

struct NotesContentView: View {
    var body: some View {
        Text("Select an item")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
