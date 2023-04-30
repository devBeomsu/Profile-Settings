
# 앱 실행 영상
https://user-images.githubusercontent.com/118424182/235335364-4b13650f-b1f7-44e9-866b-4c3ad9580abd.mp4

<br>

# 사용된 라이브러리
- PanModal

<br>

# 사용된 프레임워크
- SafariServices

<br>

# 새로 배운 것들
- SFSafariViewController
- UserDefaults

---

## SFSafariViewController
가장 먼저 웹뷰를 띄우는 방법에는 네 가지가 있다.
1. Safari App
2. UIWebView
3. WKWebView
4. SFSafariViewController

![enter image description here](https://developer.outbrain.com/wp-content/uploads/2015/12/Screen-Shot-2015-12-24-at-10.42.36-AM-1450x685.png)
출처 : https://developer.outbrain.com/ios-best-practices-for-opening-a-web-page-within-an-app/

### Safari App
- 아이폰에 설치되어 있는 Safari 앱을 열어서 웹 페이지를 연다.

### UIWebView
- 더 이상 사용하지 않는다.

### WKWebView
- 앱 내에서 웹을 연다.
- 웹 콘텐츠를 수정하거나 조작해야하는 경우 가장 높은 유연성을 제공한다.

### SFSafariViewController
- 앱 내에서 웹을 연다.
- 자동 완성 기능을 사용할 수 있다.
- 광고 등을 추적하지 못하도록 컨텐츠 차단 옵션을 사용자에게 제공한다.
- URL을 입력하는 필드를 제외하고 사파리의 모든 기능을 사용할 수 있다. 
- Safari와 SFSafariViewController 간에 쿠키가 공유되므로 사용자 세션과 환경 설정이 둘 사이에 유지된다.

<br>

---

<br>

## UserDefaults
- 데이터 저장소이다.
- 사용자 기본 설정과 같은 단일 데이터 값에 적합하다.
- 앱이 삭제되면 UserDefaults 데이터도 함께 삭제되므로 
데이터가 영구히 유지되어야 한다면 UserDefaults는 부적합할 수 있다.

UserDefaults는 기본적으로 메모리 상에서 모든 데이터를 관리한다. 
plist에서 값을 읽은 뒤에 메모리에 저장해두고, 동일한 키의 데이터를 읽으려고 하면 메모리에 있는 값을 전달한다. (메모리 캐싱)
따라서 값을 많이 읽는다고 성능이 저하되거나 그런 일은 없다.

쓰기의 경우에도 synchronize()가 호출된 뒤 파일로 동기화가 되고 그 전까지는 메모리 상에 존재하기 때문에 값을 쓰는 것도 성능 저하를 일으키지 않는다.

단, UserDefaults에 대규모 데이터를 저장한다면 앱을 실행할 때마다 대규모 데이터를 메모리에 올리기 때문에 앱 성능이 나빠질 수 있다.

그래서 대규모 데이터는 UserDefaults보다 Core Data를 사용하는 것이 더 적절하다.

<br>

---

참고 : <br>
https://zeddios.tistory.com/375
<br>
https://jeong9216.tistory.com/520
