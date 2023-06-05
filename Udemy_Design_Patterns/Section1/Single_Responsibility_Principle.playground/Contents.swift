import Foundation

/// 単一責任の原則
///　一つのクラス、構造体には一つの責任を持たせる
///　他の機能を追加したいときはその機能だけを持った別のクラスを作る

///　日記クラスの中に端末保存処理を書くこともできるが、端末保存処理用のクラスを作るのがこの原則
class Journal: CustomStringConvertible {
    
    var entries = [String]()
    var count = 0
    
    func addEntry(_ text: String) {
        count += 1
        entries.append(text)
    }
    
    func remove(index: Int) {
        guard entries.indices.contains(index) else { return }
        entries.remove(at: index)
    }
    
    var description: String {
        entries.joined(separator: "\n")
    }
    
    /// ここに保存処理等を書き込むこともできるが日記としての処理を超えてるため単一責任ではなくなってしまう
    ///　func save()...
    ///   func load()...
}

class Persistence {
    func saveToFile(_ journal: Journal, _ filename: String, _ overwrite: Bool) {
        print("Save is complieted")
    }
    
    /// func loadFromFileなど
}


func main() {
    let j = Journal()
    j.addEntry("first")
    j.addEntry("second")
    print(j.description)
    j.remove(index: 1)
    print(j.description)
    
    let filename = "adfaf/fasdf"
    let p = Persistence()
    p.saveToFile(j, filename, false)
}

main()
