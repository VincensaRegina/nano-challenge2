//
//  ContentView.swift
//  nano-challenge2
//
//  Created by Vincensa Regina on 26/07/22.
//

import SwiftUI
import CoreData
import RichTextKit

struct Heading: Hashable {
    static func == (lhs: Heading, rhs: Heading) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    @State var showSub: Bool = false
    
    func toggled() {
        self.showSub = showSub == true ? false : true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(showSub)
    }
}

struct Notes: Hashable {
    var name: String
    var heading: [Heading]
    var subheading: [String]
    var content: String
}

struct ContentView: View {
    var notes: [Notes] = [
        .init(name: "Mini Challenge 1",
              heading: [.init(name: "Market Research"), .init(name: "General Info")],
              subheading: ["Sub 1-1", "Sub 1-2"],
              content: "Content 1"),
        .init(name: "Nano Challenge 2",
              heading: [.init(name: "Swift Syntaxes"), .init(name: "General Info")],
              subheading: ["Sub 2-1", "Sub 2-2"],
              content: "Content 2")
    ]
    
    var body: some View {
        NavigationView {
            NotesListView(notes: notes)
            //            NotesNavigationView()
            //            NotesContentView()
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
    @State var notes: [Notes]
    @State var searchText = ""
    var body: some View {
        VStack {
            Text("Notes").bold().font(.largeTitle).foregroundColor(Color("TitleColor"))
                .frame(minWidth: 250, idealWidth: 250, alignment: .leading)
                .padding(.init(top: 15, leading: 10, bottom: 0, trailing: 0))
            
            List {
                ForEach(searchResults, id: \.self) { item in
                    ZStack {
                        NavigationLink (destination: NotesNavigationView(note: item, showSub: false, headingName: "")){
                            HStack {
                                Text(item.name)
                                Spacer()
                                Button {
    
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                       
                    }
                    
                   
                }
                //                .onDelete(perform: deleteItems)
            }
            .searchable(text: $searchText,placement: .sidebar, prompt: "Search")
            
        }
        
        .background(Color("NotesListColor"))
        //        .toolbar {
        //            ToolbarItem {
        //                Button(action: addItem) {
        //                    Label("Add Item", systemImage: "plus")
        //                }
        //            }
        //        }
    }
    
    var searchResults: [Notes] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.name.lowercased().contains(searchText) }
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
    @State var note: Notes
    @State var showSub: Bool
    @State var headingName: String

    var body: some View {
        
        HStack {
            VStack {
                List {
                    Text("Navigations").font(.body).foregroundColor(Color.gray)
                        .frame(maxWidth: 250, alignment: .leading)
                        .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 0))
                    Text(note.name).bold().font(.largeTitle).foregroundColor(Color("TitleColor"))
                        .frame(maxWidth: 250, alignment: .leading)
                        .padding(.bottom)
                    
                    ForEach(note.heading, id: \.self) { item in
                        Button {
                            showSub.toggle()
                            headingName = item.name
                        } label: {
                            Image(systemName: showSub && headingName == item.name ? "chevron.down" : "chevron.up")
                            Text(item.name)
                        }
                        .buttonStyle(PlainButtonStyle())
                        if (showSub && headingName == item.name) {
                            ForEach(note.subheading, id: \.self) { sub in
                                
                                NavigationLink (destination: NotesContentView(note: note)) {
                                    Text(sub)
                                    
                                }
                                .padding(.init(top: 2, leading: 20, bottom: 0, trailing: 0))
                                
                                
                            }
                        }
                        
                    }
                }
                //.onDelete(perform: deleteItems)
            }
            
            
            Divider()
            
            NotesContentView(note: note)
        }
        .background(Color.white)
    }
}

struct NotesContentView: View {
    var note: Notes
    var icons = ["bold", "italic", "underline", "list.bullet", "list.number", "textformat", "divider",
                 "text.alignleft", "text.alignright", "text.aligncenter", "text.justify", "divider", "photo"]
    @StateObject
        var context = RichTextContext()
    @State
       private var text = NSAttributedString(string: "Type here...")
    @State private var content: String = ""
    var body: some View {
        VStack {
            List {
                HStack {
                    ForEach(icons, id: \.self) {
                        item in
                        Image(systemName: item).padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        if (item == "divider") {
                            Divider().padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                    }
                }
                .frame(height: 35, alignment: .topLeading)
                Divider()
                TextEditor(text: $content).textSelection(.enabled)
//                RichTextEditor(text: $text, context: context) {
//                   // You can customize the native text view here
//                   $0.textContentInset = CGSize(width: 10, height: 20)
//                    print("The current font size is \(context.fontSize)")
//                }.background(Color.red)
            }
        }
        .frame(minWidth: 900, alignment: .leading)
        .background(Color.white)
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
