# Data communications
- Communicate : to share information
- can be local or remote
## Telecommunication
- includes telephone, telegraph, television
- communication at **disatnce**
## Data communication
- exchange of data between two devices via some form of transmission media
- regardless of distance

# Components
- Message : the information to be communicated
- Sender : the device sending the message (= source, host, station)
- Receiver : the device receiving the message (= destination, target)
- Transmission media : physical **path** by which a message travels from sender to receiver
  (= link, channel, path, medium)
- Protocol : **a set of rules** governing data communication, 소통을 위한 rule

# Data flow
## Simplex
- unidirectional communication(단방향)
- uses entire capacity of the channel
- ex) CCTV, Keyboard
## Half-Duplex
- each station can be tx(Trasmission / sender) and rx(Receiver) **but not at the same time**
- uses entire capacity of the channel for each direction
- ex) 워키토키, PTT(push to talk) 무전기
## Full-Duplex
- both station can be both tx and rx **at the same time(simultaneously)**
- the capacity of the channel is divided between two directions
- ex) telephone network

# Networks
- definition : 통신 가능한 장치끼리의 의사소통
- "DEVICE" : host(computer, desktop, laptop, phone, security system),
  connecting device(router, modem)
- 하나의 device를 거친다 = 1 hop,
  device를 거치는 작업을 몇번 하는가 = hop count,
  두번 이상 = multi hop
## Network criteria
- 짧은 시간에 많은 데이터를 주고 받는 것이 목표
- Performance : transit time(체류시간), response time(응답시간), throughput(처리량), delay(지연)
- Reliability : frequency of failure(실패비율), time link to recover from failure(회복률)
- Security
## Physical Structures
### Type of connections
- Point to Point : End to End(디바이스 두개가 서로 통신)
- Multipoint(= Multidrop) : time shared connection, Mainframe에서 링크를 통해 여러개의 device에 연결
### Physical Topology
#### Mesh
- point-to-point
- 각각의 장치가 서로간에 전용선(해당 링크가 두 장치간의 traffic만 carry)이 있음
- traffic problem이 없음
- 하나의 링크가 고장나도 나머지 링크는 정상(privacy, security)
- 케이블이 많이 필요하고 모든 장치에 입출력 포트가 있어야함
- 비싸다
#### Star
- mesh보다 가격이 덜 함
- 각각의 장치는 하나의 링크/포트만 있으면 됨
- 하나의 링크가 고장나도 다른 링크에 영향 없음
- 전체 topology가 하나의 포인트(Hub)에 의존성이 있음
- ex) LAN
#### Bus
- Node들이 각각 bus cable에 drop lines/taps로 연결 됨
- 케이블을 가장 효율적인 경로로 설치하고, drop line의 길이는 각각 다양한 길이로 연결 가능
- mesh나 star보다 적은 케이블 사용
- 재연결/고립 상황 발생 시 힘듬
- 새로운 장치 추가가 어려움(최대한 최적화 돼 있어서)
- 신호 반사, 신호 저하 발생 가능성이 높음
- 어느 곳에서나 한번 멈추면 다 멈춤
- ex) 옛날 LAN
#### Ring
- 설치/조정이 쉬움
- 단방향으로 통신이 이루어짐(시계/반시계)
- 링이 끊어지면 모든 네트워크가 멈춤
## Network Types
- Size(규모), Geographical Coverage(지리적 범위), Ownership(소유권)으로 구분
### LAN
- 사무실, 빌딩, 캠퍼스 등의 호스트를 연결, 개인 소유
- PC-Printer연결의 규모에서부터 회사전체를 아우르는 규모까지 가능함(필요에 따라)
- 각각의 호스트는 Identifier, Address를 지님(Unique)
- 호스트가 보내는 패킷에는 source/dest address가 둘 다 있음
### WAN
- LAN보다 범위가 넓음(마을, 주, 나라, 세계)
- LAN은 host를 상호연결하고, WAN은 connecting device들을 상호연결함
- 해당 네트워크를 운영하는 회사가 소유, 단체는 이를 빌려 쓰는 것
- Point-to-point WAN : 두 개의 연결장치를 유/무선으로 연결
- Switched WAN : 2개 이상의 end를 가진 네트워크. point-to-point WAN들의 조합, 전세계적 통신의 근간 역할
### Switching
- internet : 스위치가 두개 이상의 링크를 연결하는 교환망
- switch는 한 네트워크의 데이터를 다른 네트워크쪽으로 forward해야함
- Circuit-switched Network : Only Forwarding, 모든 호스트가 통신중일때를 기준으로 선 capacity를 정해야하므로 대부분 비효율적임
- Packet-Switched Network : Storing + Forwarding, 스위치가 저장 기능을 가지고 있어, 딜레이는 있을 수 있지만 큐를활용해 효율적인 의사소통이 가능
### Internet
- 가장 주목할만한 internet, 1000여개의 상호연결된 네트워크로 이루어짐
- 중추 : KT, SKT, LG등의 큰 네트워크들
- Peering points : 중추가 되는 네트워크들이 연결 된 복잡한 교환망
- Provider network : 중추 / 다른 provider network에 연결 된 네트워크
- Edge network : 고객의 네트워크, 인터넷 사용을 위해 돈을 내는 실제 사용자
- 인터넷 사용을 위해서는 물리적으로 ISP와 연결이 돼 있어야 함(보통 point-to-point WAN으로 연결)
- 접속네트워크의 종류 : 전화선연결(Modem, DSL), 케이블네트워크(TV선), 무선네트워크(무선 WAN), 인터넷 직접 연결(단체에서 빌린 속도가 빠른 WAN)
