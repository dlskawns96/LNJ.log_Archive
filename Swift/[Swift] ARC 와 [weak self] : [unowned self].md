# [Swift] ARC 와 [weak self] / [unowned self].md

RxSwift를 계속해서 사용하면서 map, bind 등에서 [weak self]를 사용하는 이유와
꼭 사용해야 하는지에 대한 궁금증이 생겼는데 계속 넘어가다가 메모리 관리와 ARC와 관련지어 공부한 내용을 정리해 보려 합니다.

# ARC - Auto Reference Counting

ARC는 Swift의 메모리 관리 방법으로,  
어떤 class instance의 strong reference의 갯수를 count 하고, 0이 되면 자동으로 메모리를 해제하는 방법입니다.

예를 들어, 
```swift
var ref1: SomeClass?
var ref2: SomeClass?
var ref3: SomeClass?
```

```SomeClass?``` 타입의 변수가 3개 있을 때,
```swift
ref1 = SomeClass() // reference count == 1
ref2 = ref1        // reference count == 2
ref3 = ref1        // reference count == 3
```
이렇게 하나의 변수에 새로운 instance를 할당하고, 나머지 두개의 변수가 해당 instance를 참조하면 하나의 ```SomeClass``` instance에 3개의 strong reference가 생기게 되고, 그 instance의 reference count는 3이 됩니다.

```swift
ref1 = nil  // reference count == 2
ref2 = nil  // reference count == 1
ref3 = nil  // reference count == 0 -> 메모리 할당 해제
```
그리고 위처럼 각 변수마다 ```nil```을 대입하여 strong reference를 해제하면,  
reference count가 하나씩 감소하고, 0이 되었을 때 instance의 메모리 할당이 해제됩니다.

## How ?

위의 예시에서는 ARC가 instance 하나하나를 관찰하면서, 런타임에 동적으로 reference count를 더하고, 빼면서 유지하는 것처럼 보이지만,  
ARC는 컴파일 단계에서 코드의 적절한 부분에 ```retain```(count +1) / ```release``` (count -1)을 삽입하는 방식으로 메모리를 관리합니다.
> Objectivce - C에서는 수동으로 retain / release를 코드에 삽입해줬습니다. (MRC)

# ARC가 책임져주지 않는 문제

ARC는 자동으로 메모리 관리를 해주는 만능 열쇠인 것 같지만, 몇 가지 신경써야할 문제가 있습니다.

## Strong Reference Cycle

```swift
// init 생략

class Student {
    var name: String
    var classroom: Classroom?
}

class Classroom {
    var number: Int
    var student: Student?
}
```

다른 class type property를 가지는 두 class가 있다고 가정합니다.

```swift
var josh = Student("josh") // RC(josh) == 1
var room1 = Classroom(1)   // RC(room1) == 1

josh.classroom = room1     // RC(room1) == 2
room1.student = josh       // RC(josh) == 2
```

위 코드에서 처럼 각 변수에 instance를 할당하고, property에 instance를 넣었을 때 Reference count는 위와 같이 증가합니다.

이 때, ```josh```, ```room1``` 객체를 해제하고 싶어서,
```swift
josh = nil
room1 = nil
```
을 해주면 ARC가 알아서 메모리 할당을 해제할 것 같지만, 

```swift
josh = nil   // RC(josh) == 1
room1 = nil  // RC(room1) == 1

// josh.classroom // RC(room1) == 1
// room1.student // RC(josh) == 1
```

각 객체안의 참조가 계속 살아있기 때문에 Reference count가 0이 되지 못해서, 메모리가 해제되지 않습니다.

### 약한 reference

Strong Reference Cycle 문제를 해결하기 위해서는 약한 reference (weak or unowned)를 사용하면 됩니다.

```swift
// init 생략

class Student {
    var name: String
    var classroom: Classroom?
}

class Classroom {
    var number: Int
    weak var student: Student? // 더 먼저 할당이 해제될 수 있는 경우에 weak 
}
```

위 처럼 ```Classroom```의 ```student```를 weak로 선언하면, 참조를 하더라도 Reference count를 증가 시키지 않기 때문에  
```josh = nil``` 이 되는 순간 메모리 할당이 해제 됩니다.

## Closure 안 에서 self 사용

RxSwift를 사용하다 보면 operator 혹은 subscription에서 closure를 빈번하게 사용하고,  
closure 안에서 해당 ViewController의 property에 접근하기 위해서 self를 사용하는 경우가 많습니다.

처음 RxSwift를 공부할 때는 인터넷의 많은 예제가
```swift
someButton.rx.tap
    .bind { [weak self] in 
        self?.view.layer.shadowColor = UIColor.black.cgColor
        self?.view.layer.shadowOpacity = 1
        ...
    }
```
위처럼 ```[weak self]```를 사용하는 경우를 많이 볼 수 있었지만, 그냥 ```[weak self]```를 제거하고, self 만 사용해도 에러가 없기 때문에 넘어간 경우가 많았습니다.

그런데 ARC에 대해 다시 공부를 하면서, closure 내에서 self를 사용하는 건 self에 대한 Strong reference를 증가 시키기 때문에 문제가 생길 수 있다는 것을 알고 다시 관심을 가지고 짚어보려고 합닏다.

```swift
let changeColorToRed = DispatchWorkItem { 
    self.view.backgroundColor = .red
}
```

잠깐 이야기가 다른데로 갔지만, 다시 closure 내에서 self를 사용했을 때 생기는 문제는  
위 처럼 property에 저장되는 closure에서 self를 사용하거나, 다른 closure로 전달될 수 있는 escaping closure에서 self를 사용할 때 발생할 수 있습니다.

```swift
let changeColorToRed = DispatchWorkItem { 
    self.view.backgroundColor = .red
}
```

그 이유는 위에 코드에서 ```changeColorToRed``` closure가 self를 참조하고, self는 closure를 참조하고 있기 때문에, self가 해제 되더라도, closure안의 self가 해제되지 않아서 문제가 생기기 때문입니다.

이 문제를 해결하기 위해선 closure안에서 self를 사용할 때 [weak self]를 명시하면 됩니다.

```swift
let changeColorToRed = DispatchWorkItem { [weak self] in
    self?.view.backgroundColor = .red
}
```
이렇게 하면 closure 내부의 self가 Reference count를 증가시키지 않기 때문에, self가 해제되는 순간 메모리 할당 역시 자동으로 해제되게 됩니다.

closure에서 [weak self]를 사용하는 경우에서는 더 이야기할게 많지만, 포스트가 너무 길어지기 때문에 다음 포스트에서 RxSwift와 [weak self]에 대해 이야기 해보겠습니다.

> 참고:   
> https://medium.com/flawless-app-stories/you-dont-always-need-weak-self-a778bec505ef  
> https://sujinnaljin.medium.com/ios-arc-뿌시기-9b3e5dc23814