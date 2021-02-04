# UITableView 와 Custom UITableViewCell 적용 하기 | Swift

쓸 때마다 헷갈리는 UITableView와 커스텀 셀 적용 순서대로 정리

## 1. Table View 추가

<img width="600" alt="스크린샷 2021-02-04 오후 9 50 37" src="https://user-images.githubusercontent.com/22260098/106895379-7cd10c00-6733-11eb-89fc-723dab5cee2c.png">



<br>

## 2. Table View Cell 추가

<img width="500" alt="스크린샷 2021-02-04 오후 9 51 09" src="https://user-images.githubusercontent.com/22260098/106895394-80fd2980-6733-11eb-8ceb-d834cbda25bc.png"> <img height="600" alt="스크린샷 2021-02-04 오후 9 51 23" src="https://user-images.githubusercontent.com/22260098/106895398-822e5680-6733-11eb-85c8-716beba5afd2.png">



<br>

## 3. ViewController에 Table View outlet 연결

<img width="1500" src="https://user-images.githubusercontent.com/22260098/106896114-7ee79a80-6734-11eb-8abb-8215640986d8.png">

```swift
class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!  // 생성한 Table View를 연결
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
```



<br>

## 4. Table View Cell에 필요한 UI 추가

Cell 안에 표시할 UI - 이미지, 라벨, 등 추가

<img width="973" alt="image" src="https://user-images.githubusercontent.com/22260098/106896341-c79f5380-6734-11eb-99cd-613ac1265d0f.png">



<br>

## 5. Custom Cell을 위한 파일을 생성하고, 연결 하기

### Custom UITableViewCell Class 파일 생성

<img width="500" alt="image" src="https://user-images.githubusercontent.com/22260098/106896769-5a3ff280-6735-11eb-8c4d-9fc9bc4b5c0c.png"><img width="500" alt="image" src="https://user-images.githubusercontent.com/22260098/106896804-65931e00-6735-11eb-898a-8a8be8709776.png">

> UITableViewCell 파일 생성(이름은 자유)



### 생성한 파일과 생선한 셀 연결하기

<img width="299" alt="image" src="https://user-images.githubusercontent.com/22260098/106897144-e0f4cf80-6735-11eb-9b5c-8d432f20c4bb.png"><img width="261" alt="image" src="https://user-images.githubusercontent.com/22260098/106897207-f833bd00-6735-11eb-9a2c-88d345b748d1.png"><img width="261" alt="image" src="https://user-images.githubusercontent.com/22260098/106897263-084b9c80-6736-11eb-9753-c9118a9589d4.png">

1. Storyboard에서 TableViewCell 선택
2. Custom Class의 Class를 내가 생성한 Cell Class로 수정
3. Identifier를 만들어 주기(이름 자유)



### 셀의 요소를 class 파일과 연결하기

<img width="1127" alt="스크린샷 2021-02-04 오후 10 14 58" src="https://user-images.githubusercontent.com/22260098/106897574-75f7c880-6736-11eb-83a4-416a6b5d411b.png">

```swift
import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel! 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
```



<br>

## 6. UITableView delegate, datasource 채택, 구현

```swift
import UIKit

// UITableViewDelegate, UITableViewDataSource 채택
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var myTableView: UITableView!
    // Cell의 Label에 표시할 내용
    let data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 대리자 위임
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    /// 필수 함수 구현
    // 한 섹션(구분)에 몇 개의 셀을 표시할지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // 한 개의 섹션당 10개의 셀을 표시하겠다
    }
    
    // 특정 row에 표시할 cell 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 내가 정의한 Cell 만들기
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        // Cell Label의 내용 지정
        cell.myLabel.text = data[indexPath.row]
        
        // 생성한 Cell 리턴
        return cell
    }
}
```

<br>

## 7. 결과

<img height="1000" src="https://user-images.githubusercontent.com/22260098/106899211-71341400-6738-11eb-9e00-8be3a55468bf.png">