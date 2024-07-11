extension Array where Element: Hashable {
    func distinct() -> Array {
        var set = Set<Element>()
        var result = [Element]()
        forEach {
            if set.insert($0).inserted {
                result.append($0)
            }
        }
        return result
    }
}
