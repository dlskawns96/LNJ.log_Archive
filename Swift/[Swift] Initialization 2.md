# Swift Class Initialization

## Designated Initializers

default 값이 없는 모든 non-optional stored property를 초기화 시키는 initializer

```swift
// 회원 정보 클래스
class Member {
    let name: String
    let id: String
    let isPaid: Bool
    
    // Designated Initializer
    init(name: String, id: String, isPaid: Bool) {
        self.name = name
        self.id = id
        self.isPaid = isPaid
    }
}

let member1 = Member(name: "Kim", id: "123", isPaid: true)
```

## Convenience Initializer

stored property 중 몇개만 값을 받아서 초기화 해주고, 다머지는 default 값을 이용해서 초기화
내부에서 다른 initializer를 호출해서 동작합니다

```swift
convenience init(name: String, id: String) {
    // Designated init 호출
    self.init(name: name, id: id, isPaid: true)
}

let member2 = Member(name: "Park", id: "456")
```

## Failing and Throwing

초기화 과정에서 property 값에 특정한 조건이 있어서 (ex id는 반드시 3글자이다)
조건에 맞지 않는 값이 파라미터로 들어오면 nil을 리턴해주고 싶을 때 사용합니다

```swift
// Designated init
init?(name: String, id: String, isPaid: Bool) {
    if id.count != 3 {
        return nil
    }
    self.name = name
    self.id = id
    self.isPaid = isPaid
}

let member = Member(name: "Lee", id: "111", isPaid: true)
let nonmember = Member(name: "Jay", id: "1212", isPaid: true) // nil
```

```swift
// init을 위한 파라미터가 가공이 필요한 형태로 들어오면,
// Convenience init에서 다 처리를 해주고, Designated init에서는 세팅만 해주는 편이 좋다

// Designated Initializer
init(name: String, id: String, isPaid: Bool) {
    self.name = name
    self.id = id
    self.isPaid = isPaid
}

convenience init?(info: String) {
    let components = info.components(separatedBy: "-")

    if components[1].count != 3 {
        return nil
    }
    self.init(name: components[0], id: components[1], isPaid: Bool(components[2])!)
}

let member1 = Member(info: "Kim-123-true")
```

## 클래스의 상속에서의 init

만약 Member를 상속하는 새로운 클래스가 있다면, 그 subclass의 init을 다시 정의해야 합니다

```swift
// 문제: isWorking에 대한 init이 없기 때문에 compile error
class Worker: Member {
    let isWorking: Bool
}

// 해결1: isWorking의 기본 값 세팅
class Worker: Member {
    let isWorking = false
}

// 해결2: Designated init 
class Worker: Member {
    let isWorking: Bool
    
    init(isWorking: Bool, name: String, id: String, isPaid: Bool) {
        self.isWorking = isWorking
        // super class의 property는 반드시 super.init()로 delegating
        super.init(name: name, id: id, isPaid: isPaid)
    }
}
```

## Subclass init에서 고려해야할 점

```swift
// #1
class Worker: Member {
    let isWorking: Bool
    
    // Compile Error!
    init(isWorking: Bool, name: String, id: String, isPaid: Bool) {
        super.init(name: name, id: id, isPaid: isPaid)
        self.isWorking = isWorking
        // subclass의 property를 모두 init 하기 전에 super.init()을 호출 하면 error
    }
}

// #2
class Worker: Member {
    let isWorking: Bool
    
    // Compile Error!
    init(isWorking: Bool, name: String, id: String, isPaid: Bool) {
        self.isWorking = self.isPaid
        super.init(name: name, id: id, isPaid: isPaid)
        // super.init()을 수행하기 전에 superclass의 property에 접근 하면 error
    }
}
```

## Class init Hierarchy

<img src="https://user-images.githubusercontent.com/22260098/118345524-06347d80-b570-11eb-8744-e6c55172717f.png">

위에 그림에서 볼 수 있는 것처럼 
subclass에서 superclass에 delegating을 하기 위해서는,

반드시 subclass의 designated init에서 superclass의 designated init을 호출해야 합니다


<img src="https://user-images.githubusercontent.com/22260098/118345582-77743080-b570-11eb-9b37-faee94628544.png"> <img src="https://user-images.githubusercontent.com/22260098/118345592-85c24c80-b570-11eb-80b9-878d8f5bf4b4.png">

즉 위와 같은 호출 관계는 성립되지 않습니다

>이 포스트는 https://www.raywenderlich.com/1219-swift-tutorial-initialization-in-depth-part-2-2#toc-anchor-012 을 참고해 작성하였습니다.