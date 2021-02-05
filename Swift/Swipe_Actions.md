# UITableViewCell에 커스텀 Swipe action 적용하기



<img height="700" src="https://user-images.githubusercontent.com/22260098/106893252-a0468780-6730-11eb-9b1e-90305eaf5cf9.png"> <img height="700" src="https://user-images.githubusercontent.com/22260098/106901857-8cece980-673b-11eb-81ee-14d41f180004.png">



위와 같이 UITableViewCell을 통해 여러개의 항목을 표시하는 상황에서 각 cell Swipe action을 통해 수정, 삭제 등의 동작을 하고 싶을 때,

Swipe action 을 적용 하는 방법을 알아 보자



<hr>

<img height="700" src="https://user-images.githubusercontent.com/22260098/106976519-e71d9700-679b-11eb-89e3-e3750835e3b7.png">

사용자의 입력을 받아, 구매할 목록을 테이블뷰 셀을 통해 표시 해주는 상황에서 Swipe action을 통해

목록을 삭제하거나 내용을 수정할 수 있도록 하려면



## tableView(_:leadingSwipeActionsConfigurationForRowAt:)

UITableViewDelegate에 있는 tableView(_:leadingSwipeActionsConfigurationForRowAt:) 메소드를 구현 해야한다

(혹은 tableView(_:trailingSwipeActionsConfigurationForRowAt:))

```swift
optional func tableView(_ tableView: UITableView, 
leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
```

Parameter로 tableView, indexPath를 받고 UISwipeActionConfiguration을 리턴 하는데, 



## UISwipeActionsConfiguration

UISwipeActionsConfiguration은  <img width="199" alt="스크린샷 2021-02-05 오전 11 25 44" src="https://user-images.githubusercontent.com/22260098/106981178-e5a49c80-67a4-11eb-8a04-2d663f979957.png"> 이것 처럼 Table row를 스와이프 했을 때, 표시할 항목(메뉴)이다

UISwipeActionsConfiguration 은 UIContextualAciton를 모아둔 오브젝트 이기 때문에, 

여러개의 UIContextualAciton을 먼저 정의하고, 한 UISwipeActionsConfiguration 객체에 담아 리턴하면 된다



## UIContextualAction

<img width="800" alt="스크린샷 2021-02-05 오전 11 33 18" src="https://user-images.githubusercontent.com/22260098/106981757-f3a6ed00-67a5-11eb-9f7b-e9bd7ca67188.png">



애플 문서에서 볼 수 있듯이, UIContextualAction은 style, title, handler 3개의 파라미터를 통해 만들 수 있다

```swift
let action = UIContextualAction(style: UIContextualAction.Style, title: String?, handler: UIContextualAction.Handler)
```



### style

UIContextualAction.Style 은 .normal, .destructive가 있는데,

.destructive는 스와이프를 통해 삭제 등을 할 때, table row가 끝까지 밀리는 스타일 이고, ![des](https://user-images.githubusercontent.com/22260098/106982684-e3900d00-67a7-11eb-9b72-d2668623aba7.gif)

.normal은 스와이프를 통해 수정 등을 할 때, row가 끝까지 밀리지 않고 고정되는 스타일 이다 ![nor](https://user-images.githubusercontent.com/22260098/106982686-e559d080-67a7-11eb-93bb-c02f6f9fd6db.gif)



### title

title은 action의 title을 자유롭게 정의하면 된다



### handler

<img width="787" alt="스크린샷 2021-02-05 오전 11 50 21" src="https://user-images.githubusercontent.com/22260098/106982917-55685680-67a8-11eb-95b7-83e4c6a8d853.png">

handler는 action, view, completionHandler를 파리미터로 갖고, 액션을 선택했을 때 실행 된다



## 결론

이렇게 3개의 파라미터를 통해 UIContextualAction을 정의하고, UISwipeActionsConfiguration에 담아 리턴 해주면 완성 이다

 ```swift
func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "swipe", handler: {(action, view, completionHandler) in
        print("Swiped") // 실행하고 싶은 내용
        completionHandler(true)
    })
    
    return UISwipeActionsConfiguration(actions: [action])
}
 ```



