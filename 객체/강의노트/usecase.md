# Use Case
- 요구사항을 찾고, 기록하는 과정
- 시스템이 뭘할지 기술, 발견과 정의
- Actor가 목적달성을 위해 시스템을 사용하는 **Text** Story
- Actor가 시스템을 사용하는 과정에서 관련된 성공/실패 시나리오의 집합
## Use Case 찾기
- System Boundary 선택
- Primary Actor 식별
- Primary Goal 식별 (Actor-Goal list 생성)
- Use Case 정의(Use Case 이름의 첫 단어는 동사로 할 것)
## Use case Diagram
- Use case의 이름, Actors, 그들의 관계를 illustrate 한 것
## Use Case Model : 모든 use case의 집합, 시스템의 기능과 환경에 대한 모델
- Requirement artifact in the UP
- Supplementary specification
- Glossary
- Vision
- Business rules
- All useful for Requirement analysis

# Actor
- something with a behavior (ex) person, computer system, organization, software
- Scenario(= Use case instance) : a specific sequence of actions and interactions between actors and the system
## Kinds
- Prmary Actor : SuD(System under Discussion)의 서비스를 사용함으로써 목표를 달성하는 사용자
- Supporting Actor : SuD에게 서비스를 제공
- Offstage Actor : Use Case들의 behavior에 관심을 가지고 있음

# UML
- 소프트웨어 개발 주기 전체 지원
- 다양한 diagram 지원
- 요구사항 분석 단계에서 use case diagram을 많이 사용
- domain concept model/software design을 기술할 때 Class diagram을 많이 사용
## Use Case
- 시스템을 사용하는 사용자의 입장이 핵심
- 공통적인 사용자 목표에 의해 묶인 시나리오들의 집합
- 내용 전달이 잘 되어야 함
- 시스템 Use case : 소프트웨어 시스템과의 상호작용 표현
- 비즈니스 Use case : 비즈니스와 고객 또는 이벤트와의 상호작용 표현
- Flow of Events : 사용자와 시스템 간의 상호작용을 서술하는 일련의 스텝들
  -> 발생가능한 Sequence에 대해, Use Case를 시작시킨 행위자는 왼쪽, 결과를 받는 행위자는 오른쪽에 표현
## Actor
- 여러사람 -> 하나의 액터, 하나의 사람 -> 여러 액터로 매핑 가능
- Use Case를 시작시키고, 끝나면 결과를 받음
- Primary Actor : 주 목적을 가지고 주도적으로 접근
- Secondary Actor : Use Case를 실행하기 위해 시스템이 필요로 하는 지원 액터
## Use Case Diagram
- 시스템의 설계도
- Use Case들의 목차의 그래픽적인 테이블 표현
- Actor / Use Case / 이들의 관계로 구성
- 시스템의 사용에 대한 시나리오의 집합
- 사용자의 관점에서 시스템을 모델링(사용자가 시스템에 바라는 바)
- System : Use Case를 둘러싸는 사각형으로 표현(행위자는 시스템 외부에, Use Case는 내부에)
- Extend의 : 하나의 Use Case가 다른 Use Case를 Extend하는 관계
  -> Extension Point : Extend할 Use Case로 가는 행동타입, Condition : Extend할 Use Case로 가는 트리거
- Include : Use Case가 다른 Use Case에 include됨(공통점이 있을 때 발생)

## Class Diagram
- 설계 시 가장 많이 사용
- 객체의 타입인 Class를 표현하는 Diagram
- Name / Attributes / Operations
- 정적인 관계, 관계에 대한 제약 표
- Name // Name + Attributes // Name + Attributes + Operations // Name + Operations
- Visibility : +(public), #(protected), -(private), ~(package)
- 변수 기술 : name : type
- 함수 기술 : name(parameters):returnType, <constructor> <misc>등으로 분류
- 관련 클래스들의 적절한 분류를 패키지를 통해서 표현 가능
### Boundary Class
- 사용자, 외부 시스템, 장비 등과 상호 작용하는 클래스
- 초기에는 액터/유스케이스 한 쌍당 하나의 바운더리 클래스도 OK(이후 여러개로 분할)
### Entity Class
- 시스템 관점에서의 추상 개념
- 유즈 케이스 기술서의 사건흐름으로부터 파악, 주요 추상 개념을 참조
- 주로 명사
- Wrapper라는 스테레오타입을 정의해 DB연동에 사용
### Control Class
- 유즈 케이스의 행위를 조정하는 클래스
- 하나의 유즈 케이스 - 하나의 컨트롤
### Attributes
- [visibility] [/] name [:type] [multiplicity] [=default] [{property-string}]
- 밑줄 친 Attribute는 Static Attribute(Class의 모든 객체가 공유)
### Associations
- Source / Target의 연결
- 속성의 이름은 역할으로 표현
- 연관관계의 양끝에 개수 표현
### Operations
- [visibility] name ([parameter-list]) : [return-result] [{properties}]
- visibility는 private / public
- Static Operation은 밑줄
### Relationships
- 의존 관계 : 한 요소의 변화가 다른 요소에 영향을 미칠 경우
  -> 가리키고 있는 클래스가 없으면 해당 클래스는 컴파일 불 가능
- 연관 관계 : 상대 객체와의 관계 표현, Has관계 등
- 집합 관계 : Part-of 관계, 해당 객체쪽에 다이아몬드 그림, owns manages 등
- 구성 관계 : 전체-부분 관계(has a, contains, is part of) 분리되어 생각 될 수 없음(무조건 있어야 하는 것)
  -> 계층 구조를 가질 수 있으며, multiplicity를 가질 수 있음, Diagram 상으로 꽉찬 다이아몬드로 표현
- 상속 관계 : superclass와 subclass 간의 논리적 추상화 제공(is a, is a kind of)
  -> subclass는 일반화된 suprclass의 모든 특성을 상속, 속이 빈 화살표로 표현(가리키는 쪽이 super)
### 추상 클래스
- 직접 인스턴스를 생성 할 수 없는 Class(하나 이상의 추상 오퍼레이션 보유)
  -> 유사품 추상 오퍼레이션 : 구현 없이 순수한 정의만을 가진 오퍼레이션
- Italic체로 표현
### 인터페이스
- 어떤 구현도 가지지 않는 클래스
- 모든 특성이 abstract
- 키워드 <<interface>>를 사용하여 표현
- 구현의 변경이 용이하고, 유지보수를 쉽게 함
- UML1 : 롤리팝으로 표현, 의존관계 사용
- UML2 : 의존관계 표현을 소켓 표기법으로 대체, class가 interface를 치환 가능
### 제약 조건
- Invariants (항상 true인 상수, class 속성에서 정의)
- Preconditions (메소드가 수행되기 전 만족하여야 하는 제약조건, 입력값의 유효성 검증에 사용)
- Postconditions (메소드가 수행 된 후 만족하여야 하는 제약조건, 출력값의 검증에 사용)

# Star UML
- Model : 소프트웨어 모델에 관한 정보를 담고 있는 요소
- View : 모델이 담고 있는 정보를 시각적으로 표현
- Diagram : 뷰 요소들의 집합으써 사용자의 일정한 생각을 표현
## Project
- 가장 기본이 되는 단위
- 하나 혹은 그 이상의 소프트웨어 모델들을 관리
- 최상위 패키지
- 하나의 프로젝트 -> 하나의 파일에 저장
- XML형태로 저장되며 확장면은 .UML
## Unit
- 프로젝트를 여러명이 작업하거나 하는 등의 이유로 여러 개의 파일로 나누어서 다루어야 할 경우
- 계층적으로 구성 가능
- .UNT파일에 저장, 다른 프로젝트/유닛 파일에서 참조됨
## Profile
- Stereotype : 의미를 명확하게 하고 확장속성을 부여해 정확한 모델링이 가능하도록 함
- Tag Definition : UML 요소가 가지고 있는 프로퍼티만으로는 정확한 모델링이 어려울 경우 부가적인 정보를 요소에 기록 할 수 있도록 함
- Data Type : 기본적으로 포함하는 데이터 타입들을 나타냄
- Diagram Type : 새로운 다이아그램을 정의 할 수 있도록 도와줌
- Element Prototype : 기존에 정의된 요소에 속성들을 미리 설정하여 하나의 견본을 정의 할 수 있도록 함
- Model Prototype : 요소가 아닌 모델 프로토타입
- Palette : 추가적인 팔레트를 구성 할 수 있게 해줌
