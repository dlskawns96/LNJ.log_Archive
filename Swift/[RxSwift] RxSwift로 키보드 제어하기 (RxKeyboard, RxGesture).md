# [RxSwift] RxSwift로 키보드 제어하기 (RxKeyboard, RxGesture)

iOS 앱을 구현하다보면, UITextField, UITextView에 사용자의 입력을 키보드를 통해 받는 경우가 매우 흔하게 있습니다.

구현 중인 앱에 키보드가 등장하게 되면 아래와 같은 문제를 꼭 마주하게 됩니다.

1. 키보드가 UITextField, UITextView 등 다른 View들을 가리는 경우
2. 이제 그만 좀 입력하고 싶은데 도저히 키보드가 안내려갈 때
3. 키보드가 scrollView를 가려 UITableViewCell 등을 제대로 조회하지 못하는 문제

위와 같은 문제는 "hide keyboard when tapping anywhere..." 이런식의 키워드로 구글링을 하면 수 많은 해결 방법을 찾을 수 있습니다.

저도 필요할 때마다 구글링을 통해 여러가지 방법으로 해결을 했었는데,  
현재 진행 중인 프로젝트에서는 RxSwift를 사용하고 있기 때문에 RxSwift를 이용하여 키보드가 만들어내는 문제를 해결하는 방법을 시리즈로 정리해보겠습니다.

# 1. 키보드가 다른 View들을 가리는 문제

기본적으로 키보드는 하단에서 올라와서 앱 내에 겹치는 부분을 가리기 때문에,  
키보드의 입력을 보여주는 입력칸이나 입력을 하는 중에도 계속 보여줘하는 view들을 가리는 문제가 있습니다.

<img src="https://user-images.githubusercontent.com/22260098/138893166-8019479c-e70e-4150-973f-a6523f147052.png" height=650>

위처럼 화면 최하단에 UITextField를 배치하는 것은 메시지, 카톡 등 많은 앱에서 볼 수 있는 것처럼 매우 흔한 경우입니다.

하지만 아무 설정없이 저 textField를 탭하면 

<img src="https://user-images.githubusercontent.com/22260098/138893569-399daa96-688b-4bc1-86cc-8df373d40973.png" height=650>

위처럼 키보드가 textField를 완전히 가려서 입력되는 값을 볼 수 없습니다.

이 문제를 해결하는 가장 흔한 방법은 키보드의 height를 계산해서 위치를 이동시켜줄 view의 constraints를 조정해주는 방법입니다.

## 기본 세팅

```swift
self.view.addSubview(textField)
        
textField.snp.makeConstraints {
    $0.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
}
```

ViewController에 textField를 만들어서 add하고, constraints를 위와 같이 세팅한 상태에서 예제를 진행하겠습니다.

이제 키보드가 올라왔을 때를 감지해서,   
키보드의 height를 구하고,  
textField의 bottom inset을 조정해주면 됩니다.

### 키보드 감지, 키보드 height 구하기

```RxKeyboard```를 사용하면, 키보드가 올라왔을 때를 감지하면서 height를 동시에 구할 수 있습니다.

> https://github.com/RxSwiftCommunity/RxKeyboard

```swift
RxKeyboard.instance.visibleHeight
    .skip(1)    // 초기 값 버리기
    .drive(onNext: { keyboardVisibleHeight in
        print(keyboardVisibleHeight)  // 346.0
    })
    .disposed(by: disposeBag)
```

위 코드를 사용하면, keyboard가 보이는 높이가 변화했을 때를 감지해서 현재 높이를 구할 수 있습니다.  
이제 ```drive(onNexe:)```안에서 textField의 constraints만 조정해주면 됩니다.

```swift
RxKeyboard.instance.visibleHeight
    .skip(1)    // 초기 값 버리기
    .drive(onNext: { keyboardVisibleHeight in
        self.textField.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight)
                }
    })
    .disposed(by: disposeBag)
```

위의 코드를 적용하면, 아래 화면처럼 동작하는 것을 볼 수 있습니다.

<img src="https://user-images.githubusercontent.com/22260098/138898884-66ed3370-cd3a-4922-ae9e-6d68356ea276.gif" height=650>

위 화면은 textField가 키보드를 피해서 올라가긴 하지만,  
뭔가 위치도 키보드에 딱 붙었으면 좋겠고,  
키보드가 올라오는 것처럼 애니메이션으로 부드럽게 올라갔으면 좋겠으니까  
전체적으로 쓸만하게 수정해보겠습니다.

### textField가 키보드에 딱 붙게

지금 textField의 bottom constraint inset을 키보드 높이만큼으로 했을 때 공간이 뜨는 이유는  
textField의 bottom이 ```self.view```가 아니라 ```self.view.safeAreaLayoutGuide```로 설정되어있기 때문입니다.  

따라서 ```safeAreaLayoutGuide```의 하단 부분만큼 inset을 줄여주면 textField가 키보드에 정확히 붙도록 할 수 있습니다.

#### safeAreaLayoutGuide 하단 높이

```swift
let window = UIApplication.shared.windows.first
let extra = window!.safeAreaInsets.bottom
```

```swift
RxKeyboard.instance.visibleHeight
    .skip(1)    // 초기 값 버리기
    .drive(onNext: { keyboardVisibleHeight in
        self.textField.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight - extra)
                }
    })
    .disposed(by: disposeBag)
```

<img src="https://user-images.githubusercontent.com/22260098/138900547-77c552ca-6ca7-4a60-ac61-bfbc17bbd00e.png" height=650>

이제 키보드와 textField에 추가적인 공간이 생기는 문제는 해결했으니,
textField의 위치 조정에 애니메이션을 추가해 자연스러운 움직임을 만들겠습니다.

#### UIView.animate

```swift
// 최종코드
let window = UIApplication.shared.windows.first
let extra = window!.safeAreaInsets.bottom

RxKeyboard.instance.visibleHeight
    .skip(1)    // 초기 값 버리기
    .drive(onNext: { keyboardVisibleHeight in
        UIView.animate(withDuration: 0) {
            self.textField.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight - extra)
                    }
        }
        self.view.layoutIfNeeded()
    })
    .disposed(by: disposeBag)
```

### 최종 결과

<img src="https://user-images.githubusercontent.com/22260098/138901154-dfa0fcfe-2554-4834-9a40-48645782cf3b.gif" height=650>

RxKeyboard를 사용해서 view의 위치를 키보드에 맞춰 조정을 하면,
notification을 사용하는 것보다 훨씬 가독성 좋고 간결한 코드로 문제를 해결할 수 있는 것 같습니다.