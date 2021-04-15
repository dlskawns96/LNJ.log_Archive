# Swift Initialization 초기화

Initialization - 초기화는 class, structure, enumeration 과 같은 named type의 stored property의 값을 초기화 하는 것 입니다.

예시를 들기 위해 하나의 structure ```Pet```을 정의 하겠습니다.
```swift
struct Pet {

}
```

## Default Initializer
```swift
let myPet = Pet()
```
```Pet```에는 아직 initializer가 정의되어 있지 않지만, 자동으로 default initializer가 사용됩니다.
만약 사용하고자 하는 타입이 stored property가 없거나, 모든 stored property가 default 값이 있다면 default initializer를 사용할 수 있습니다.


struct ```Pet```에 정의 부분에 몇가지 stored properties를 추가 해보겠습니다.
```swift
struct Pet {
    let name: String = "Joy"
    let isDog: Bool = true
}
```
두 개의 stored properties가 추가 되었지만, 여전히 default initializer는 작동을 합니다.
그 이유는 ```name```, ```isDog``` 모두 default 값을 가지고 있기 때문입니다.

optional stored property가 추가되면 어떻게 될까요?
```swift
struct Pet {
    let name: String = "Joy"
    let isDog: Bool = true
    var age: Int?
}
```
여전히 ```age```의 값이 ```nil```로 초기화 되면서 default initializer가 작동하는 것을 알 수 있습니다.
하지만 ```age```가 constant라면 ```nil```로 초기화 되지 않기 때문에 ```nil```이라는 초기 값을 지정해줘야 합니다.
```swift
struct Pet {
    let name: String = "Joy"
    let isDog: Bool = true
    let age: Int? = nil
}
```

## Memberwise Initializer - 멤버별 초기화

타입의 모든 stored properties의 값을 초기화 하거나, 상수로 사용하지 않는 경우가 많기 때문에, 타입의 각 멤버별로 초기화 하는 방법을 알아보겠습니다.

```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int
}
```
위에서 사용한 동일한 예시이지만 이번에는 모두 default 값이 없고, 정의되어 있는 initializer 역시 없습니다.

```swift
let myPet = Pet(name: "Joy", isDog: true, age: 10)
```
하지만 이처럼 Swift structure는 자동으로 Memberwise Initializer를 만들어 주기 때문에, 각 멤버별 초기값을 지정해 줄 수 있습니다.

```swift
struct Pet {
    let name: String
    let isDog: Bool = true
    let age: Int
}
```
하지만, 만약 이처럼 default 값이 있는 멤버가 있다면, Memberwise Initializer는 그 멤버의 값을 파라미터로 받지 않습니다. 
```swift
let myPet = Pet(name: "Joy", age: 10)
```

이번에는 custom initializer를 추가 해보겠습니다.
```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
        self.isDog = true
    }
}
```
이렇게 struct 정의 중괄호 안에 initializer를 정의하게 되면 더 이상 Memberwise Initializer는 자동으로 생성되지 않습니다!

만약 custom initializer와 Memberwise Initializer를 둘다 사용하고 싶다면, 
```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int
}

extension Pet {
    init(name: String, age: Int) {
        self.name = name
        self.age = age
        self.isDog = true
    }
}
```
이처럼 custom initializer를 extension으로 밖으로 빼주면 됩니다.

>정리: 
>struct 타입은 자동으로 default 값이 없는 멤버를 초기화 시킬 수 있는
>Memberwise Initializer를 만들어준다.
>Custom Initializer가 있다면 Memberwise Initializer를 사용할 수 없지만, extension으로 분리하면 사용 가능하다.

## Implementing a Custom Initializer - 커스텀 init 구현

```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int

    init(name: String = "Joy", isDog: Bool = true, age: Int = 10) {
        self.name = name
        self.isDog = isDog
        self.age = age
    }
}
```

named type의 Initializer는 default 값이 없는 모든 stored properties를 초기화할 수 있어야 합니다.
위의 Initializer는 값을 받아서 멤버를 초기화 하는 동시에, default 값을 가지고 있어서

```swift
let myPet = Pet()
```
이처럼 Default Initializer가 동작하듯이 동작할 수 있습니다.

## Initializer delegation

named type의 stored properties가 단순히 파라미터 값을 그대로 저장하는게 아니라, 변환 (제곱미터->평) 등 여러 연산이 필요한 경우, Custom Initializer가 계속 늘어날 수 있습니다.

위에서 예를 들었던 상태에서 ```isDog```을 ```Bool```타입이 아니라, ```String```타입으로 "Dog", "Cat" 등의 파라미터가 들어오는 것으로 초기화를 하고 싶다면,

```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int

    init(name: String = "Joy", isDog: Bool = true, age: Int = 10) {
        self.name = name
        self.isDog = isDog
        self.age = age
    }

    init(name: String = "Joy", isDog: String = "Dog", age: Int = 10) {
        self.name = name
        self.age = age
        self.isDog = (isDog == "Dog")
    }
}
```

이런식으로 ```isDog```을 ```String```타입으로 받는 새로운 ```init```을 정의할 수 있습니다.
하지만 본능적으로 두 ```init```의 중복되는 코드를 제거하고 싶다는 생각이 누구나 들 것입니다.

그렇다면, 아래와 같은식으로 코드를 변경할 수 있습니다.
```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int

    init(name: String = "Joy", isDog: Bool = true, age: Int = 10) {
        self.name = name
        self.isDog = isDog
        self.age = age
    }

    // delegating initializer
    init(name: String = "Joy", isDog: String = "Dog", age: Int = 10) {
        self.init(name: name, isDog: (isDog == "Dog"), age: age)
    }
}
```
이처럼 다른 initializer에게 초기화를 위임(delegate)하기 때문에 delegating initializer가 됩니다.

## Initialization Phase

<img height="300" src="https://user-images.githubusercontent.com/22260098/114896410-46a6bb80-9e4b-11eb-8b7f-c4810e382dbc.png">

이 이미지에서 볼 수 있는 것처럼 Phase 1은 초기화의 시작부분에서 시작되고, 
모든 stored properties가 초기화 된 이후에 종료되고, 
나머지 초기화 작업은 Phase 2에서 진행됩니다.

Phase 1에서는 지금 초기화 하는 대상 instance를 사용할 수 없지만, Phase 2에서는 사용가능 하다는 차이가 있습니다.

Phase의 진행을 코드에 표시하면 다음과 같습니다:
```swift
struct Pet {
    let name: String
    let isDog: Bool
    let age: Int

    init(name: String = "Joy", isDog: Bool = true, age: Int = 10) {
        // Phase 1 init
        self.name = name
        self.isDog = isDog
        self.age = age
        // Phase 2 init
    }

    // delegating initializer
    init(name: String = "Joy", isDog: String = "Dog", age: Int = 10) {
        // Phase 1 Delegating init
        self.init(name: name, isDog: (isDog == "Dog"), age: age)
        // Phase 2 Delegating init
    }
}
```

## Failure Handling

지금까지 봤던 예시 코드는 애완동물의 이름, 개 여부, 나이를 초기화 하고 있습니다.
하지만 파라미터에 대한 검사가 전혀 없어, 초기화 할 때 나이 값을 음수로 넘겨도 아무런 방어를 하지 못합니다.

### Failable(Optional) Initializer

이상한 값이 들어왔을 때는 인스턴스를 만들지 않고 nil을 반환한다면 불필요한 에러를 제거할 수 있습니다.

```swift
init?(name: String, isDog: Bool, age: Int) {
    if age < 0 {
        return nil
    }
    self.name = name
    self.isDog = isDog
    self.age = age
}
```
이처럼 ```init```에 ?를 붙이고, 이상한 값이 들어왔을 때 ```nil```을 리턴하는 initializer를 Failable(Optional) Initializer라고 합니다.

```swift
guard let myPet = Pet(name: "Joy", isDog: true, age: -1) {
    print("Success")
} else {
    print("Error!")
}
```
이렇게 Failable(Optional) Initializer를 만들고, 인스턴스를 생성하는 단계해서 optional binding을 해주면 에러를 방지할 수 있습니다.

### Error Throwing

Failable(Optional) Initializer를 통해 에러를 감지할 수 있었지만, 검사해야 하는 property가 여러개고, 어디서 어떤 에러가 발생 했는지 알기 위해서는 Error Throwing이 효과적 입니다.

만약 ```Pet```의 이름이 비어있으면 안되고, 나이가 음수면 안된다는 조건이 있다면

```swift
enum InvalidPetDataError: Error {
    case EmptyName
    case InvalidAge
}
```
이처럼 ```enum```으로 에러를 정의해두고,

```swift
init(name: String, isDog: Bool, age: Int) throws {
    if name.isEmpty {
        throw InvalidPetDataError.EmptyName
    }
    if age < 0 {
        throw InvalidPetDataError.InvalidAge
    }

    self.name = name
    self.isDog = isDog
    self.age = age
}
```
Initialzer에서 ```throw```를 해주면 됩니다.

이 Initializer를 이용해 인스턴스를 생성하려면,
```swift
let myPet = try? Pet(name: "Joy", isDog: true, age: -1) // nil
let myPet = try? Pet(name: "Joy", isDog: true, age: 10) // 정상
```
이런식으로 생성을 하거나, ```do-catch```문을 사용하면 됩니다.

이번 포스트에서는 Swift의 struct의 Initialization에 대해 알아봤습니다.
다음 포스트에서는 class Initialization에 대해 알아보도록 하겠습니다.

>이 포스트는 https://www.raywenderlich.com/1220-swift-tutorial-initialization-in-depth-part-1-2 을 참고해 작성하였습니다.