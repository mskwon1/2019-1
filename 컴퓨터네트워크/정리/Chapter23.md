# Introduction to Transport Layer

- Application / Network Layer 사이에 위치

- 두개의 Application Layer 사이 Process-to-Process Communication 제공

  - Local Host + Remote Host
  - Logical Connection

## Services

### Process-to-Process Communication

- Process : Transport Layer의 서비스를 사용하는 Application Layer Entity(작동하는 프로그램)
- Host to Host : 네트워크 레이어
  - Incomplete Delivery, 메시지가 **올바른 Process**에 정확히 전달돼야 함 -> Transport Layer
- Process-to-Process : Transport 레이어
  - 맞는 Process에게 메시지 전달

![1557194932363](../../typora_images/1557194932363.png)

### Addressing : Port Numbers

- 가장 흔한 Process-to-Process Commucation : Clinet-Server Paradigm
  - Local Host = Client, Remote Host = Server
- Local Host와 Remote Host는 **IP 주소**로 정의
- Local Process와 Remote Process는 **포트 번호**로 정의

- TCP/IP 프로토콜에서 포트 번호는 정수(0~65,535 : 16비트)
- IP 주소가 목적 **호스트**를 선택하고, 그 다음 포트번호가 해당 호스트의 **프로세스**를 선택

#### Ephemeral(수명이 짧은) 포트 번호

- 클라이언트 프로그램이 자기자신을 이 번호로 정의
- 클라이언트의 프로세스는 수명이 짧은 편 => Ephemeral

#### Well-known 포트 번호

- 서버 프로그램의 포트 번호는 랜덤으로 정해질 수 없음
- 이 번호가 랜덤이면 클라이언트의 프로세스가 서버 프로세스에 접근하는 것이 불가능
- 현재의 해결책 : Universal(Well-known) 포트 번호 사용

![1557195572882](../../typora_images/1557195572882.png)

#### ICANN Ranges

- Well-Known Ports : 0 ~ 1023
  - ICANN에 의해 지정 / 통제
- Registered Ports : 1024 ~ 49151
  - ICANN이 지정 / 통제 하지 **않음**
  - ICANN을 이용해 등록 가능(**중복 방지**)
- Dynamic Ports : 49152 ~ 65535
  - 통제되거나 등록되지 않음
  - Temporary / Private 포트 번호로 사용

#### Socket Addresses

- IP 주소와 포트 번호를 합친 것
- Client/Server 소켓 주소는 Client/Server Process를 Unique하게 정의

### Encapsulation and Decapusulation

- 인터넷 Transport Layer에서 패킷들의 이름 : User Datagram, Segments, Packets![1557196365005](../../typora_images/1557196365005.png)

### Multiplexing and Demultiplexing

- Source 측 : Multiplexing	
  - Messages -> Packets 
- Destination 측 : Demultiplexing
  - Packets -> Messages

![1557196499553](../../typora_images/1557196499553.png)

### Flow Control

- Sender가 Recever가 받기 힘들 정도로 너무 빨래 보내지 않도록 확인
  - Rate of **Produced** Frames @Sender > Rate of **Consumed** Frames @Receiver 
    - 대기시간 동안 버퍼에서 대기, Frame이 버려질 수 있음

- Pushing and Pulling

  - Item의 Producer => Consumer 전송방식은 두가지로 나뉨

  - Pushing

    - Consumer의 **요청 전**에 Sender가 item을 생산하는대로 보내는 것
    - Flow Control **필요**

    ![1557197609437](../../typora_images/1557197609437.png)

  - Pulling

    - Consumer의 **요청 후**에 Sender가 item을 그에 맞게 보냄
    - Flow Control **필요 없음**

    ![1557197663773](../../typora_images/1557197663773.png)

- 두 가지 Flow Control로 나뉨

  - Transport Layer **@Sender** => Application Layer **@Sender**
  - Transport Layer **@Receiver** => Transport Layer **@Sender**

### Error Control

- 네트워크 레이어는 신뢰성이 떨어지기 때문에, Transport 레이어가 신뢰성이 있어야 함

- 책임
  - 손상된 패킷을 탐지하고 버리는 것
  - 잃어버린 / 버린 패킷을 추적하고 재송신하는 것
  - 중복 패킷을 인지하고 버리는 것
  - out-of-order 패킷을 나머지 패킷들이 오기 전까지 버퍼링하는 것
- Sequence Number
  - Sender 측 Transport Layer가 어떤 패킷을 재송신 해야하는지 안다
  - Receiver 측 Transport Layer가 어떤 패킷이 중복인지 안다
  - Receiver 측 Tranport Layer가 어떤 패킷이 Out-of-Order인지 안다
    - 패킷에 번호가 있으면 가능함 => Sequence Number
    - Sequence Number에 m개의 비트 사용 => 범위 = 0 ~ 2^m -1
- ACK
  - Receiver 측에서 패킷이 안전하고 믿을만하게 왔다는 것을 Sender에게 보냄
  - 손상된 패킷은 그냥 버리기 가능
  - Sender 측에서는 Timer 시간 내에 ACK가 도착하지 않으면 패킷 재송신

### Combination of Flow and Error Control

