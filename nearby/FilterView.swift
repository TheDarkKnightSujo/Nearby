import SwiftUI

struct FilterView: View {
    @EnvironmentObject var viewModel: LocationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Distance")) {
                    VStack {
                        HStack {
                            Text("Maximum Distance")
                            Spacer()
                            Text("\(String(format: "%.1f", viewModel.maxDistance)) km")
                                .bold()
                        }
                        Slider(value: $viewModel.maxDistance, in: 0.5...20.0, step: 0.5)
                    }
                }
                
                Section(header: Text("Minimum Rating")) {
                    Stepper(value: $viewModel.minRating, in: 0.0...5.0, step: 0.5) {
                        HStack {
                            Text("Rating")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", viewModel.minRating))
                                .bold()
                        }
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $viewModel.selectedCategory) {
                        ForEach(PlaceCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Button(action: {
                    viewModel.applyFilters()
                    dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.maxDistance = 10.0
                        viewModel.minRating = 0.0
                        viewModel.selectedCategory = .all
                    }
                }
            }
        }
    }
}

#Preview {
    FilterView().environmentObject(LocationViewModel())
}
