# [Swift] 간단한 날씨 앱 만들어보기 01 (Swift OpenWeatherMap)

이번에는 API 호출을 통해 정보를 받아오고 처리하는 것을 익히기 위해,
간단한 날씨 앱을 만들어 볼 예정입니다.

## 프로젝트 생성

<img width="600" alt="Creating Project" src="https://user-images.githubusercontent.com/22260098/119263554-78fdc280-bc1a-11eb-818e-5e6b568633a9.png">

먼저 Xcode를 실행하고 SampleWeatherApp이라는 이름의 프로젝트를 하나 생성합니다.
이렇게 생성된 프로젝트에서 API를 통해 날씨 정보를 받아오고, UI를 통해 표시할 예정입니다.

## OpenWeatherMap

> [OpenWeatherMap](https://openweathermap.org)

날씨 정보를 리턴해주는 API는 여러 종류가 있지만, 아이콘과 함께 다양한 날씨 정보를 얻을 수 있는 OpenWeatherMap을 사용하도록 하겠습니다.

OpenWeatherMap API를 사용하는 방법은

### 1. OpenWeatherMap 가입, API Key 발급 받기

위의 링크를 통해 접속한 후, 회원가입을 하고 로그인을 하면,

<img alt="API" src="https://user-images.githubusercontent.com/22260098/119265167-b6fde500-bc20-11eb-8e3e-d43d25dcbf1e.png">

우측 상단에 본인 아이디를 클릭하고, My API Keys를 확인하면 발급된 key를 확인할 수 있습니다.

### 2. 사용할 API 선택하기

OpenWeatherMap은 여러종류의 API를 통해 여러종류의 정보를 제공합니다.

<img alt="API" src="https://user-images.githubusercontent.com/22260098/119265250-f6c4cc80-bc20-11eb-810b-89e48ff85295.png">

위 처럼 다양한 API들은 문서를 통해 사용법, 정보를 확인할 수 있고,
이번 프로젝트에서는 Current Weather data를 사용하겠습니다.

### 3. API 호출하기

Current Weather data API를 사용한다고 해서 호출 방법이 하나만 있는게 아니라,
도시 이름으로, 도시 ID로, 위, 경도로, ZIP code로 등 다양한 방법으로 API를 호출하는 방법이 있습니다.

> 참고: [Current Weather data 문서](https://openweathermap.org/current)

저희는 서울의 날씨를 받아오기 위해 도시 이름으로 호출하는 방법을 사용하겠습니다.
```
api.openweathermap.org/data/2.5/weather?q=seoul&appid={API key}
```
{API Key}에는 본인의 API Key를 넣으면 되고, 다른 도시의 날씨를 얻고 싶으면 seoul 대신 다른 도시의 이름을 넣으면 됩니다.

그럼 API call이 제대로 되는지 확인하기 위해 브라우져에 위의 url을 입력해보겠습니다.

![](https://user-images.githubusercontent.com/22260098/119265920-9b480e00-bc23-11eb-8fe7-e7c626427571.png)

그럼 위같은 결과를 받아볼 수 있고, 더 가독성이 좋게 보기위해 [PostMan](https://www.postman.com)을 통한 결과를 보겠습니다.

![스크린샷 2021-05-24 오전 12 05 42](https://user-images.githubusercontent.com/22260098/119265955-c92d5280-bc23-11eb-9bb0-1d8564f9175c.png)

Postman에 해당 url을 넣고 GET을 보낸 결과입니다.
이처럼 API call을 통해, 좌표, 현재 날씨, 날씨 이름, 아이콘, 체감 온도 등을 받아올 수 있었습니다.

## API Key 숨기기

API Key를 공개된 곳에 노출하면 다른 사람들이 악의적인 목적으로 이용할 수도 있기 때문에,
깃허브같은 저장소나 드라이브에 노출하면 안되는 것은 물론, 컴파일 후 바이너리 파일로 바뀌더라도 충분히 디컴파일 하려는 시도가 있을 수 있기 때문에 Key보안에 신경을 써야합니다.

먼저 생성해둔 Xcode 프로젝트를 열고, Key를 저장할 .plist파일을 하나 만들겠습니다.

1. ```File -> New -> File```
2. property 검색후 Property List 파일 생성 (이름은 자유)
![](https://user-images.githubusercontent.com/22260098/119300875-78a60b80-bc9c-11eb-9e45-a5ed967bf95d.png)
3. String 타입의 값을 하나 만들고, Key에 원하는 값, Value에 API Key 값을 넣음
![](https://user-images.githubusercontent.com/22260098/119301066-d89cb200-bc9c-11eb-9a59-61a634aa3c08.png)
4. ViewController.swift에 Key에 접근하는 코드 추가
```swift
private var apiKey: String {
    get {
        // 생성한 .plist 파일 경로 불러오기
        guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
            fatalError("Couldn't find file 'KeyList.plist'.")
        }
        
        // .plist를 딕셔너리로 받아오기
        let plist = NSDictionary(contentsOfFile: filePath)
        
        // 딕셔너리에서 값 찾기
        guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
            fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.")
        }
        return value
    }
}
```
5. git에 Key를 노출하지 않기 위해, gitignore에 생성한 .plist 추가하기

이렇게 함으로써, Key를 노출하지 않고 접근할 수 있게 되었습니다.

## 다음에 계속

이번 포스팅에서는 OpenWeatherMap API를 통해 날씨 정보를 불러오고,
Xcode에서 해당 Key를 숨기는 방법을 알아보았습니다.

다음 포스팅에서는 날씨 앱을 위한 UI를 세팅하고, 받아온 날씨 정보를 표시하는 방법을 알아보겠습니다.