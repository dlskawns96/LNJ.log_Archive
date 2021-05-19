# iOS App Life Cycle - iOS 앱의 생애주기

어떤 앱이 foreground일 때와 background일 때 앱이 할 수 있는 일과 해야하는 일이 달라집니다.

foreground인 앱은 시스템 자원의 높은 우선 순위를 가지고, <br>
background인 앱은 최대한 적은 일(가능하면 아무것도 안하기)을 해야합니다.

사용자들은 누구나 그렇듯이 앱을 사용할 때,<br>
이 앱 저 앱을 왔다갔다 하거나, 잠깐 다른 앱을 보고 오거나 하기 때문에 <br>
앱의 상태 변화에 따라 반응을 해줄 필요가 있습니다.

내 앱의 상태가 변화했는지 어떻게 알 수 있을까요?<br>
iOS 13 이상에서는 ```UISceneDelegate``` object를 통해 Scene-based 앱의 life cycle에 대응하고,<br>
그 이전 버젼에서는 ```UIApplicationDelegate``` object를 통해 대응합니다.

## App-Based Life-Cycle Events (iOS 12 이하)

iOS 12 이하는 Scene을 지원하지 않습니다.<br>
그래서 ```UIKit``` 은 모든 life-cycle events를 ```UIApplicationDelegate``` object에 전달합니다.

App delegate는 앱의 모든 window를 관리하고, app state의 전환은 앱의 전체 UI에 영향을 미칩니다.

<img width="600" alt="state" src="https://user-images.githubusercontent.com/22260098/118744238-e7dfc200-b88e-11eb-9c22-13c5d97285ba.png">

위 그림은 앱의 state 변화를 나타내고 있습니다.<br>
Not Running 상태의 앱을 실행하면 Inactive를 거쳐 Active 상태가 되고, <br>
앱의 UI가 화면에 표시가 되냐 안되냐로 자동으로 Inactive 혹은 Background 상태가 됩니다. 

앱이 한번 실행이 되면 앱이 종료되기 전까지 앱의 상태는 <br>
Active <-> Inactive <-> Background 에서 변화합니다.

## Scene-Based Life-Cycle Events (iOS 13 이상)

우리의 앱이 scenes을 지원한다면, UIKit은 각 scene마다 life-cycle을 전달합니다.

scene은 실행되고 있는 앱의 UI의 한 인스턴스에 해당합니다.<br>
유저는 하나의 앱에 여러개의 scene을 만들 수 있고, 각각 숨기거나 보여지게 할 수 있습니다.<br>
각 scene마다 다른 life-cycle을 가지고 있기 때문에 각기 다른 state를 가질 수도 있습니다.

<img width="600" alt="scene state" src="https://user-images.githubusercontent.com/22260098/118748799-4dd04780-b897-11eb-9247-49cf039cb9ab.png">

위 그림은 scene의 state 변화를 나타내고 있습니다.<br>
유저 혹은 시스템이 새로운 scene을 요청하면, UIKit은 scene을 생성해 Unattached state에 넣습니다. <br>
유저가 요청한 scene은 빠르게 foreground로 이동하고, <br>
시스템이 요청한 scene은 어떤 이벤트를 처리하기 위해 background로 이동하는 경우가 많습니다.

> 참고: https://developer.apple.com/documentation/uikit/app_and_environment/managing_your_app_s_life_cycle