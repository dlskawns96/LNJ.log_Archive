# MVC 패턴으로 UITableView 구현하기

Swift 로 UITableView 를 구현할 때,
ViewController, TableViewCell 로만 클래스를 나누고 거의 모든 동작을 ViewController 안에서만 구현하다 보면 여러 역할들이 나누어져있지 않고, 코드의 가독성도 너무 떨어지기 때문에 MVC 패턴을 따르면서 UITableView 를 구현하는 예제 코드를 보도록 하자.

## MVC 로 나누기

UITableView 는 외부 혹은 내부로부터 다수의 데이터를 받아서 내가 원하는 형태(셀)에 맞게 데이터를 가공하여 테이블에 나타낸다.

이 동작에서 
데이터를 받고, 가공 하는 부분을 Model
화면을 구성하는 Storyboard 를 View
커스텀셀을 생성하고, tableView를 구성하는 부분을 Controller 로 나눈다.

## 코드로 구현 하기
**MVC 패턴을 이해하며 TableView를 구현하기 위해 간단한 주소록을 표시하는 어플리케이션을 구현 해보자.**

> [이 아티클](https://medium.com/ios-os-x-development/ios-tableview-with-mvc-a05103c01110)을 참고 하여 작성

UITableView 를 UITableViewController 에서 모두 처리 하는 것이 아니라 여러 개의 클래스로 분배한다:

- TableViewController: ViewController 의 Subclass 로 생성하고, UITableView 를 SubView 로 사용한다.
- TableViewCell
- TableViewDataModel: 데이터를 내부, 외부에서 받아와서 가공하고 ViewController 로 전달 한다.
- TableViewDataModelItem: TableViewCell 에 표시할 데이터의 집합.

### 1. TableViewCell

**TableViewCell 은 XIB file을 만들거나 storyboard를 이용해, UI를 구성하고, IBOutlet 을 세팅한다.**

![스크린샷 2021-03-04 오후 5 38 32](https://user-images.githubusercontent.com/22260098/109934978-71f89f80-7d10-11eb-92a9-014e2e3c91c8.png)

```swift
class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
}
```

이름을 나타내는 UILabel 과 주소를 표시하는 UILabel 이 있는 간단한 cell 을 만들고 Outlet을 세팅해줬다.

```swift
class MyTableViewDataModelItem {
    var name: String?
    var address: String?
}
```

cell 의 UILabel 을 세팅하기 위한 변수를 따로 사용하기 보다는 하나의 클래스 (or struct)를 만들었다.

그리고, MyTableViewCell 안에서 Label 들을 세팅하기 위한 함수를 만든다.

```swift
class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?

    func configureWithItem(item: MyTableViewDataModelItem) {
        nameLabel?.text = item.name
        addressLabel?.text = item.address
    }
}

```

### 2. TableView

1. 하나의 ViewController 를 생성하고, UITableView 를 추가하고, 오토레이아웃을 지정하고, outlet 을 세팅했다.

2. 그리고, ViewController 에 tableView에 표시할 데이터를 저장하기 위해 위에서 만들어둔 class 의 어레이를 생성한다.
3. viewDidLoad() 에서 tableView 의 컬러 등 기본 적인 세팅을 하고, nib을 register 해준다.
4. UINib 과 Identifier 를 하드코딩 하지 않고, MyTableViewCell 에 literal 을 생성해서 사용한다.
5. UITableViewDelegate, UITableViewDataSource 구현.
```swift
class MyTableViewController: UIViewController {
    // 1
    @IBOutlet weak var tableView: UITableView!
    
    // 2
    fileprivate var dataArray = [MyTableViewDataModelItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //3
        tableView.register(MyTableViewCell.nib, forCellReuseIdentifier: MyTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

// 5
extension MyTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 어레이의 개수 리턴
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell을 dequeue, downcast 하고
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        // cell을 구성한다
        cell.configureWithItem(item: dataArray[indexPath.row])
        return cell
    } 
}

extension MyTableViewController: UITableViewDelegate {
 // 이 예제에서 구현할 delegate 함수는 없다.   
}
```

```swift
class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    
    // class var 는 static var 와 비슷한 역할
    // 4
    class var identifier: String {
        return String(describing: self)
    }
    // 4
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    ...
}
```

### 3. DataModel

DataModel 클래스에서는 테이블뷰를 표시하는데 필요한 데이터를 JSON, HTTP request, 또는 로컬 파일에서 불러온다.

### 4. Delegate

DataModel 에서 생성한 data 를 테이블뷰에 넘겨 주기 위해서 delegate 를 사용한다.

```swift
class MyTableViewModel {
    weak var delegate: MyTableViewModelDelegate?

    func requestDate() {
        // 이 함수에서 필요한 데이터를 원하는 방식으로 불러오기
        var data = [MyTableViewDataModelItem]()

        // 어딘가로 부터 가져온 데이터를
        for item in fromSomeWhere {
            // 필요하면 modelItem의 형태로 가공해서
            data.append(item)
        }
        // data 를 직접 리턴 하는게 아니라 delegate 를 통해 위임
        delegate?.didUpdateData(data: data)
    }
}

protocol MyTableViewModelDelegate: class {
    func didUpdateData(data: data)
}
```

### 5. DataModel로 부터 데이터를 받아오고, Display 하기

1. Model 객체 생성
2. viewWillAppear() 에서 데이터 요청 (requestData())
3. Model 객체의 delegate 할당
4. MyTableViewModelDelegate 상속, 프로토콜 구현

```swift
class MyTableViewDataModelItem {
    var name: String?
    var address: String?
}

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?

    func configureWithItem(item: MyTableViewDataModelItem) {
        nameLabel?.text = item.name
        addressLabel?.text = item.address
    }

    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

class MyTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    // Property observer 를 세팅 해두면 데이터가 업데이트 될 때 자동으로 테이블뷰를 리로드
    // Notification 등으로 데이터의 변화를 감지하고 수동으로 리로드 해줄 필요가 없다
    fileprivate var dataArray = [MyTableViewDataModelItem]() {
        didSet {
            tableView.reloadData()
        }
    }

    // 데이터 모델 객체 생성
    let dataSource = MyTableViewModel()
    
    // 해당 뷰를 열 때마다 데이터를 갱신하기 위해서
    // viewWillAppear()에서 requestData()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MyTableViewCell.nib, forCellReuseIdentifier: MyTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self

        dataSource.delegate = self
    }
}

// MyTableViewModelDelegate를 상속받고, 프로토콜 구현
extension MyTableViewController: MyTableViewModelDelegate {
    // 데이터가 업데이트 되면, 받기
    func didUpdateData(data: data) {
        dataArray = data
    }
}

extension MyTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 어레이의 개수 리턴
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureWithItem(item: dataArray[indexPath.row])
        return cell
    } 
}

extension MyTableViewController: UITableViewDelegate {
 // 이 예제에서 구현할 delegate 함수는 없다.   
}

class MyTableViewModel {
    weak var delegate: MyTableViewModelDelegate?

    func requestDate() {
        // 이 함수에서 필요한 데이터를 원하는 방식으로 불러오기
        var data = [MyTableViewDataModelItem]()

        // 어딘가로 부터 가져온 데이터를
        for item in fromSomeWhere {
            // 필요하면 modelItem의 형태로 가공해서
            data.append(item)
        }
        // data 를 직접 리턴 하는게 아니라 delegate 를 통해 위임
        delegate?.didUpdateData(data: data)
    }
}

protocol MyTableViewModelDelegate: class {
    func didUpdateData(data: data)
}
```