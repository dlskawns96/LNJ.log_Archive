# SwiftUI Tutorial 1

## 프로젝트 생성

먼저 SwiftUI를 사용해 볼 Project를 생성하겠습니다.

<p align="center">
    <img width="650" src="https://user-images.githubusercontent.com/22260098/118575728-1774c880-b7c2-11eb-8daa-83bf3645ad87.png" alt="project create">
</p>

이름을 지정하고, Interface와 Life Cycle을 SwiftUI로 지정을 하고,
프로젝트를 생성하면...

<p align="center">
    <img width="400" src="https://user-images.githubusercontent.com/22260098/118580162-5eff5280-b7ca-11eb-9b8f-50a45ead31d2.png">
</p>

Main.storyboard도 없고, ViewController.swift도 없는 낯선 모습의 프로젝트가 생성됩니다.

## 프로젝트 살펴보기

대신 ProductNameApp.swift (FirstSwiftUIAppApp.swift)와 ContentView.swift가 생성됐습니다.

아직 이 파일들이 어떤 역할을 하는지는 모르지만 일단 한 번 살펴보겠습니다.

```swift
//
//  FirstSwiftUIAppApp.swift
//  FirstSwiftUIApp
//
//  Created by Lee Nam Jun on 2021/05/18.
//

import SwiftUI

@main
struct FirstSwiftUIAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

body 안에 Scene이 있고, 또 WindowGroup안에 ContentView()가 있습니다.

무슨 뜻인지는 모르겠지만 대충 struct안에 계층적으로 UI가 구성되는 것처럼 보입니다.

```swift
//
//  ContentView.swift
//  FirstSwiftUIApp
//
//  Created by Lee Nam Jun on 2021/05/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

여기도 2개의 struct로 구성이 되어있습니다...

첫번째 struct는 text view를 가지고 있는 body 같고, 두번째 struct는 preview를 위한 것 같습니다.

아직 무슨 내용인지는 모르겠지만 벌써 storyboard로 생성한 프로젝트 보다 훨씬 적은 코드가 있는 것을 알 수 있었습니다.

## 코드의 동작

이 두개의 swift 파일로 어떻게 preview가 동작할까요??

```swift
@main
struct YourProjectName: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

App을 상속하는 YourProjectName은 어플리케이션이 보여지는 방법을 담당합니다.

위 코드는 ```ContentView``` instance를 생성하고, ```WindowGroup``` 안에 배치 함으로써 우리의 스크린에서 보여지도록 합니다.

### ContentView.siwft

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

1. ContentView는 UIKit 프로젝트에서 ViewController와 비슷한 역할을 합니다. 
하지만 위 코드처럼 class가 아닌 struct 형태로 되어있기 때문에 더 적은 코드로 간단하게 구현할 수 있게 되어있습니다.

2. SwiftUI에서 스크린에 보여주고 싶은 모든 요소는 View protocol을 채택해야 합니다. 그래서 ContentView 자체가 View를 채택하고, some View를 리턴하는 body가 필요합니다.

3. body의 리턴 타입이 some View ??? <br>
some 키워드는 Swift 5.1에서 추가된 키워드로 리턴 타입이 some View라는 것은 View를 채택하는 어떤 것을 리턴하겠다는 뜻입니다.

4. body 프로퍼티 안에 "Hello, World!"라는 텍스트를 표시하는 Text가 있습니다.

5. .padding()은 Text view안에 패딩이 있는 형태의 Text view를 리턴합니다.

6. ContentView_Previews는 실제 앱 동작이 아니라 XCode내 preview기능을 위해 존재합니다.

여기까지 SwiftUI의 기본적인 템플릿에 대해 알아봤습니다.