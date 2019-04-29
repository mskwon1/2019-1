# Thread & Lock

- Thread : 하나의 실행흐름
- Lock : 접근 못하도록 하는 것

## Concurrency

### Thread

- Code, Data, Heap, Files를 공유하는 실행흐름들(즉, Address Space를 공유함)

![1556525668669](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556525668669.png)

- 스레드 별로 Ready / Running / Blocked 상태가 각각 있음
  - 리스트 형태로 스레드들의 상태 표현
  - 리스트의 노드는 TCB(Thread Control Block) / 레지스터,스택 포함
    - 프로세스 리스트의 PCB(Process Control Block)과 비슷한 개념
  - 스레드 차원에서의 Context Switch가 일어남
    - T1 -> T2 : T1의 레지스터를 저장하고, T2의 레지스터를 불러옴(Address Space는 유지)
  
  ![1556533046522](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556533046522.png)
- 스레드끼리 소통하는 법
  - 공유 자원인 전역변수로 소통
  - 프로세스끼리는 파일로 소통해야됨(느림)

#### 장점

- 생성이 빠름
  - 프로세스 하나 : 무거움, 스레드 하나 : 가벼움
- I/O로 넘어갈 것 같을 때, 즉 Blocked 상태가 될 것 같을 때 다른 스레드로 넘기도록 할 수 있음

#### 스레드 생성

- 스레드를 언제 생성할지는 코딩 단계에서 표현
  - 특정 함수 시작시 스레드 시작하도록 코딩

![1556527381301](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556527381301.png)

