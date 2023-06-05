import Foundation

enum Color {
    case red, green, blue
}
enum Size {
    case small, medium, large, yuge
}

class Product {
    var name: String
    var color: Color
    var size: Size
    
    init(name: String, color: Color, size: Size) {
        self.name = name
        self.color = color
        self.size = size
    }
}

/// もし色で検索する機能を追加したいとき、サイズや両方満たす検索処理の詳細（満たしてたらリストに追加して返すなど）を追加することを考えると毎回コピペしてクラスを増やすのはバグの原因になるしめんどい。
/// class ColorFilter
///  class SizeFilter
///  class ColorAndSizeFilter
///  ...

// 検索条件
// クラスを元にBool値を返す、という処理は固定できる
protocol Specification {
    associatedtype T
    func isSatisfied(_ item: T) -> Bool
}
//フィルター機能を持つプロトコル
//リストをもらって検索条件に一致したものを返す、という処理はどれも同じ
protocol Filter {
    associatedtype T
    func filter<Spec: Specification>(_ items: [T], _ spec: Spec) -> [T] where Spec.T == T;
}

// 具体できな検索条件やフィルター内容はプロトコルに準拠したクラスで定義する
class ColorSpecification: Specification {
    typealias T = Product
    let color: Color
    init(_ color: Color) {
        self.color = color
    }
    func isSatisfied(_ item: Product) -> Bool {
        return color == item.color
    }
}

class SizeSpecification: Specification {
    typealias T = Product
    let size: Size
    init(_ size: Size) {
        self.size = size
    }
    func isSatisfied(_ item: Product) -> Bool {
        return size == item.size
    }
}
/// whereで定義した条件を満たせば複数の検索なども簡単に実装できる
class AndSpecification<T, SpecA: Specification, SpecB: Specification> : Specification where SpecA.T == SpecB.T, T == SpecA.T, T == SpecB.T {

    let first: SpecA
    let second: SpecB
    init(_ first: SpecA, _ second: SpecB) {
        self.first = first
        self.second = second
    }
    func isSatisfied(_ item: T) -> Bool {
        first.isSatisfied(item) && second.isSatisfied(item)
    }
}

class BetterFilter: Filter {
    /// 実際の検索処理
    func filter<Spec>(_ items: [Product], _ spec: Spec) -> [Product] where Spec : Specification, Product == Spec.T {
        return items.filter { item in spec.isSatisfied(item) }
    }
    
    typealias T = Product
}

func main() {
    let tree = Product(name: "tree", color: .green, size: .large)
    let apple = Product(name: "apple", color: .green, size: .small)
    let ocean = Product(name: "ocean", color: .blue, size: .large)
    let items = [tree, apple, ocean]
    let colorSpec = ColorSpecification(.green) /// 検索条件：緑
    let bf = BetterFilter()
    let filteredItems = bf.filter(items, colorSpec)
    for item in filteredItems {
        print("\(item.name) is \(item.color)")
    }
    print("=====")
    let andSpec = AndSpecification(ColorSpecification(.blue), SizeSpecification(.large))
    let andFilteredItems = bf.filter(items, andSpec)
    for item in andFilteredItems {
        print("\(item.name) is \(item.color)")
    }
}

main()
