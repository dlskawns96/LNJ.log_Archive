## 앱이 실행될 때

<img width="600" alt="launch screen" src="https://www.iosapptemplates.com/wp-content/uploads/2019/02/Screen-Shot-2019-02-18-at-3.38.56-PM.png">

> 출처: https://www.iosapptemplates.com/blog/ios-programming/ios-launch-screen

홈 화면에서 앱 아이콘을 터치해 앱을 실행시키면 먼저 launch storyboard가 실행됩니다. <br>
launch storyboard는 앱이 초기화되고, UI를 표시할 준비가 될 때까지 시간을 끌어주는 역할을 합니다.

**실행단계에서 초기화**

앱을 실핼하는 단계에서 초기화를 하는 코드를 작성하고 싶다면

- ```application(_:willFinishLaunchingWithOptions:)```
- ```application(_:didFinishLaunchingWithOptions:)```
  
함수를 사용하면 됩니다.

UIKit은 이 메소드들은 앱의 실행 단계의 시작에서 호출합니다.<br>
이 함수를 통해 아래와 같은 작업을 할 수 있습니다.

- 앱의 data structures 초기화
- 앱이 실행해야하는 리소스 확인
- 앱을 처음 실행했을 때 해야하는 작업 수행 ex) 템플릿 설치, 디렉토리에 파일저장
- APNs 등 필요한 서비스와 연결
- 앱이 실행된 이유에 반응하기 ex) 알림을 통해 실행, 위치 관련 작업 수행을 위해 실행

### 오래걸리는 작업은 다른 Thread로

위 메소드를 통해 앱의 실행 단계에서 여러 작업을 수행할 수 있지만, <br>
```application(_:willFinishLaunchingWithOptions:)```가 리턴되기 전까지 유저는 앱의 UI를 볼 수 없기 때문에, 작업이 길어지면 유저 입장에서 앱의 실행이 너무 느리고 답답하다고 느낄 수 있습니다.

그래서 앱의 초기상태에서 당장 필요가 없거나 너무 오래 걸리는 작업은 main thread가 아니라 global dispatch queue에서 비동기 처리를 하는 것이 좋습니다.

### 앱의 실행 이유에 따라 반응하기

```application(_:willFinishLaunchingWithOptions:)```
```application(_:didFinishLaunchingWithOptions:)```

이 두 메소드는 파라미터로 ```UIApplication.LaunchOptionsKey``` 을 받습니다.

이 파라미터는 앱이 실행된 이유를 가지고 있고, 이걸 이용해서 앱 실행시 필요한 작업을 해줄 수 있습니다.

예시:
```swift
// location event에 반응하기
class AppDelegate: UIResponder, UIApplicationDelegate, 
               CLLocationManagerDelegate {
    
   let locationManager = CLLocationManager()
   func application(_ application: UIApplication,
              didFinishLaunchingWithOptions launchOptions:
              [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
      // If launched because of new location data,
      //  start the visits service right away.
      if let keys = launchOptions?.keys {
         if keys.contains(.location) {
            locationManager.delegate = self
            locationManager.startMonitoringVisits()
         }
      }
       
      return true
   }
   // other methods…
}
```