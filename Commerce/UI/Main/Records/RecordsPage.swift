import SwiftUI
import SwiftData

struct RecordsPage: View {
    @Query private let records: [Record]
    @State private var statusRecords = [("待出貨", [Record]()), ("已出貨", []), ("已收貨", []), ("完成訂單", [])]
    @State private var status = "待出貨"
    @State private var count = 0
    
    func update() {
        statusRecords.indices.forEach { index in
            statusRecords[index] = (
                statusRecords[index].0,
                records.filter {
                    ["買家": $0.buyer, "賣家": $0.seller][CommerceApp.user.role] == CommerceApp.user.name
                    && $0.status == statusRecords[index].0
                }
            )
        }
    }
    
    var body: some View {
        VStack {
            Picker(selection: $status) {
                ForEach(statusRecords, id: \.0) {
                    Text("\($0.0)(\($0.1.count))")
                }
            } label: {}
                .pickerStyle(.segmented)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(statusRecords.first { $0.0 == status }!.1) { record in
                        HStack {
                            ProductImage(record.images.first!)
                            VStack(alignment: .leading) {
                                Text(record.name)
                                    .lineLimit(2)
                                Text("$\(record.price)")
                                    .foregroundStyle(.red)
                                Text("訂購數量：\(record.amount)")
                                Text(
                                    [
                                        "買家": "自\(record.seller)購買",
                                        "賣家": "販售給\(record.buyer)"
                                    ][CommerceApp.user.role]!
                                )
                                HStack {
                                    Spacer()
                                    switch CommerceApp.user.role {
                                    case "買家":
                                        switch status {
                                        case "已出貨":
                                            Button("收貨") {
                                                record.status = "已收貨"
                                                count += 1
                                            }
                                        case "已收貨":
                                            Button("完成") {
                                                record.status = "完成訂單"
                                                count += 1
                                            }
                                        default:
                                            EmptyView()
                                        }
                                    case "賣家":
                                        if status == "待出貨" {
                                            Button("出貨") {
                                                record.status = "已出貨"
                                                count += 1
                                            }
                                        }
                                    default:
                                        EmptyView()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .frame(height: 150)
                    }
                }
            }
        }
        .task(id: records) {
            update()
        }
        .task(id: count) {
            update()
        }
    }
}
