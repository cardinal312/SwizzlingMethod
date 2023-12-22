import Foundation
import UIKit
import PlaygroundSupport

final class SwizlingClass: NSObject {
    
    var closure1: (() -> ())?
    var closure2: (() -> ())?
    
    @objc dynamic func firstMethod() -> String {
        closure1?()
        return "First" }
    @objc dynamic func secondMethod() -> String {
        closure2?()
        return "Second" }
    
    func swizzlingMethods() {
        let first = class_getInstanceMethod(SwizlingClass.self, #selector(SwizlingClass.firstMethod))
        let second = class_getInstanceMethod(SwizlingClass.self, #selector(SwizlingClass.secondMethod))
        method_exchangeImplementations(first!, second!)
    }
}

let swizzlingInstance = SwizlingClass()

//print(swizzlingInstance.firstMethod(), swizzlingInstance.secondMethod())
//swizzlingInstance.swizzlingMethods()
//print(swizzlingInstance.firstMethod(), swizzlingInstance.secondMethod())

class ViewController: UIViewController {
    
    private let swizzlingInstance = SwizlingClass()
    
    override func loadView() {
        super.loadView()
        
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.main.bounds.width, UIScreen.main.bounds.height))
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Main VC"
        
        swizzlingInstance.closure1 = { self.view.backgroundColor = .yellow }
        swizzlingInstance.closure2 = { self.view.backgroundColor = .red }
        
        print(swizzlingInstance.firstMethod(), swizzlingInstance.secondMethod())
        
        // Start Swizzling method
        
        swizzlingInstance.swizzlingMethods()
        print(swizzlingInstance.firstMethod(), swizzlingInstance.secondMethod())
    }
}

let navigation: UINavigationController = UINavigationController(rootViewController: ViewController())
PlaygroundPage.current.liveView = navigation
