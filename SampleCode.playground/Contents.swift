import Foundation
import UIKit

// テストタブルを活用したテスト
/*
 
 コンポーネントの差し替えによるテスト方法
 具体的にはDIとスタブとモック
 
 テストタブルは本物のコンポーネントとすり替えるテスト用の代替えコンポーネントのことです。
 テストによっては、テスト対象のコンポーネントに意図した処理を行わせるために、必ず同じ結果を返却する代替のコンポーネント(=スタブ)に置き換えて、テストを制御することがあります。
 
 本物のコンポーネントと代替えのコンポーネントを置き換えたり、依存をコントロールしたりするために、このDIというテクニックを使う
 DIの方法は言語によって様々、本物のコンポーネントと代替のコンポーネントで共通の親クラスを継続するようにしたり、共通のインターフェースに準拠するようにしたりする
 
 Swiftでは、共通のプロトコルに準拠する方法があり、本項ではこの方法で解説を進める
 二つのDIの種類についてそれぞれ解説していく
 
 コンストラクタインジェクション
 
 コンストラクタインジェクションはコンポーネントの初期化時に依存するコンポーネントを代入するDI
 
 
 */

protocol LoggerProtocol {
    func sendLog(message: String)
}

class Logger: LoggerProtocol {
    func sendLog(message: String) {
        // 本番用のログ送信の実装
    }
}

class DebugLogger: LoggerProtocol {
    func sendLog(message: String) {
        // デバック用のログ送信の実装
    }
}

class Calculator {
    // LoggerProtocolに準拠したコンポーネントと置き換え可能な形
    
    private let logger: LoggerProtocol
    
    // コンストラクタインジェクション　VIPERもこれで実装している
    init(logger: LoggerProtocol) {
        self.logger = logger
    }
}

let logger = Logger()
// Debug用のLoggerを代入することも可能
let debugLogger = DebugLogger()
// コンストラクタインジェクションは依存するコンポーネントの代入を防げるメリットがある
// 依存の代入を忘れてしまうと、コンポーネントは期待した動きをしません
let calculator = Calculator(logger: debugLogger)

/*
 コンストラクタインジェクションでは解決できないシチュエーションもある
 UIStoryBoardからのUIViewControllerの初期化時にコンポーネントを代入できないといったiOS特有の問題も、コンストラクタインジェクションでは
 解決できないものとなっている
 ２つのコンポーネント同士が依存していると、どちらかのコンポーネントの初期化を先に解決する必要がある
 
 */

/*
// セッターインジェクション
// コンポーネントのイニシャライズ以降ニセターメゾット、あるいは外部に公開されたプロパティに対して依存するコンポーネントを代入するDI

 UIStoryboardから初期化するUIViewControllerに対して、コンポーネントで代入できないという問題についてセッターインジェクションによって解決する
 
 以下は依存コンポーネントをPrivateとして宣言し、初回の依存解決のためだけに使う意図でインジェクトというメソッドを宣言している
 */

protocol PresenterProtocol {}

final class Presenter: PresenterProtocol {}

final class SampleViewController: UIViewController {
    
    private var presenter: PresenterProtocol?
    
    func inject(presenter: PresenterProtocol) {
        self.presenter = presenter
    }
}

let presenter = Presenter()
let viewController = UIViewController()

/*
 let sampleViewController = UIStoryboard(name: "SampleViewController", bundle: nil)
 .instantiateInitialViewController() as? SampleViewController
 sampleViewController?.inject(presenter: presenter)
 
*/


// 二つのコンポーネント同士が依存しあっている場合に、
// どちらかのコンポーネントの初期化を先に解決できなければもう一方のコンポーネントの初期化が行えない問題についても、
// セッターインジェクションによって解決できる

protocol ViewInput {}

protocol ViewOutput: AnyObject {}

class ViewA: ViewOutput {
    private var input: ViewInput?
    func inject(input: ViewInput) {
        self.input = input
    }
}

class ViewB: ViewInput {
    private weak var output: ViewOutput?
    
    func inject(output: ViewOutput) {
        self.output = output
    }
}

// 本来なら以下のようにコンストラクタインジェクションしたいが
// 依存の順序が解決できないので、セッターインジェクションとする
// let a = ViewA(b: b)
// let b = ViewB(a: a)

// 基本的にはコンストラクタインジェクションを使う

let a = ViewA()
let b = ViewB()

a.inject(input: b)
b.inject(output: a)

