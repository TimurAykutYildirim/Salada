//: Playground - noun: a place where people can play

import Foundation

protocol IngredientType {
    var id: String? { get }
    var createdAt: NSDate { get }
    init(value: [String: AnyObject])
}

protocol Tasting {
    associatedtype Tsp: Ingredient
}

extension Tasting where Self.Tsp: IngredientType, Self.Tsp == Self {
    static func observe() -> Tsp {
        let tsp: Tsp = Tsp(value: [:])
        return tsp
    }
}

class Ingredient: NSObject, IngredientType, Tasting {
    
    typealias Tsp = Ingredient
    
    var id: String? { return "123" }
    
    var createdAt: NSDate
    
    private var hasObserve: Bool = false
    
    private let ignore: [String] = ["snapshot", "hasObserve", "ignore"]
    
    override init() {
        self.createdAt = NSDate()
    }
    
    convenience required init(value: [String: AnyObject]) {
        self.init()
        self.hasObserve = true
        Mirror(reflecting: self).children.forEach { (key, _) in
            print(key)
            if let key: String = key {
                if !self.ignore.contains(key) {
                    self.addObserver(self, forKeyPath: key, options: [.New], context: nil)
                    if let value: AnyObject = value[key] {
                        self.setValue(value, forKey: key)
                    }
                }
            }
        }
    }
}

class User: Ingredient {
    typealias Tsp = User
    var name: String?
}


let user: User = User.observe()

@objc enum UserType: Int {
    case User
    case Group
}

let mirror: Mirror = Mirror(reflecting: UserType.User)
mirror.displayStyle
mirror.subjectType
mirror.children
mirror.description
mirror.superclassMirror()


let t = mirror.subjectType
t


@objc class Relation: NSObject, ArrayLiteralConvertible {
    
    typealias _Self = Relation
    typealias Element = String
    
    required init(arrayLiteral elements: Relation.Element...) {
        self.object = elements
    }
    
    var object: [String] = []
    
    func insert(element: Element) {
        self.object.append(element)
    }
    
    override func copy() -> AnyObject {
        return self
    }
    
//    @objc internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
//        // Instances of this class should be visible outside of standard library as
//        // having `NSSet` type, which is immutable.
//        return self
//    }
    
}

//class New<Element : Hashable> : Hashable, CollectionType, ArrayLiteralConvertible {
//    
//    
//    required init(arrayLiteral elements: Relation.Element...) {
//        self.objects = elements
//    }
//    
//    private var objects: [String] = []
//    
//    public var count: Int {
//        return self.objects.count
//    }
//    
//    public var isEmpty: Bool {
//        return self.objects.count == 0
//    }
//    
//    public var startIndex: Int {
//        return 0
//    }
//    
//    public var endIndex: Int {
//        return count - 1
//    }
//    
//    public subscript(index: Int) -> String {
//        get { return self.objects[index] }
//    }
//    
//    public func generate() -> AnyGenerator<String> {
//        var index: Int = 0
//        return AnyGenerator<String> {
//            if index < self.objects.count {
//                let result = self.objects[index]
//                index += 1
//                return result
//            }
//            return nil
//        }
//    }
//    
//}

class Parent: NSObject {
    dynamic var array: [String] = []
    dynamic var relation: Relation = []
    dynamic var int: Int = 0
    dynamic var set: Set<String> = []
    
    override init() {
        super.init()
        self.addObserver(self, forKeyPath: "relation", options: [.New, .Old], context: nil)
        self.addObserver(self, forKeyPath: "Int", options: [.New, .Old], context: nil)
        self.addObserver(self, forKeyPath: "set", options: [.New, .Old], context: nil)
        self.addObserver(self, forKeyPath: "array", options: [.New, .Old], context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "Int")
        self.removeObserver(self, forKeyPath: "relation")
        self.removeObserver(self, forKeyPath: "set")
        self.removeObserver(self, forKeyPath: "array")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "relation" {
            print("relation")
        }
        if keyPath == "set" {
            print("set")
        }
        if keyPath == "array" {
            print("array")
        }
    }
}

let parent: Parent = Parent()

//parent.relation = ["sssssss"]
parent.relation.insert("ssss")
print(parent.set)
parent.set.insert("aaa")
print(parent.set)
parent.array.append("eeee")

