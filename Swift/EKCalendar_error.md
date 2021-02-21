# EKEvent, EkCalendar 가져올 때 에러 해결

### [EventKit] Error getting shared calendar invitations for entity types 3 from daemon: Error Domain=EKCADErrorDomain Code=1014 "(null)"

EKEvent 객체를 생성하고, calendar를 지정해 줄 때,

```swift
newEvent.calendar = eventStore.calendar(withIdentifier: calendar.calendarIdentifier)
```
이런식으로 다른 캘린더의 Identifier를 이용하여 EkEventStore에서 원하는 캘린더를 불러 오면, 원하는 캘린더를 리턴 받을 수 있기 하지만, 아래와 같은 에러 메시지가 출력된다.

```swift
[EventKit] Error getting shared calendar invitations for entity types 3 from daemon: Error Domain=EKCADErrorDomain Code=1014 "(null)"
```

### 해결

구글링을 해봐도, 정확한 원인을 찾을 수는 없었지만, 적당히 타협하고 해결할 수 있는 방법을 찾았다.
해결 방법은 캘린더를 ``EKEventStore.calendar(withIdentifier:)`` 로 찾는게 아니라 모든 캘린더를 불러온 이후 그 중에서 Identifier가 같은 캘린더를 찾는 방식으로 하는 것이다.

### 코드

```swift
// 모든 캘린더 가져오기
var calendars = eventStore.calendars(for: .event)

// filter를 통해 내가 원하는 조건에 맞는 캘린더 찾기
newEvent.calendar = calendars.filter({(cal: EKCalendar) -> Bool in
            return cal.calendarIdentifier == originalCalendar!.calendarIdentifier
        }).first
```