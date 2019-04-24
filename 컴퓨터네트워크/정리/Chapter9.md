# Introduction to Data-Link Layer

- 인터넷은 수많은 연결장치로 연결된 수많은 네트워크의 조합이다
- 패킷이 한 Host에서 다른 Host로 이동하고자 하면, 이 네트워크들을 통과해야함

## Nodes and Links

- Data-Link Layer에서의 의사솥오은 node-to-node(1 hop)로 이루어짐
- 인터넷 안 한 시점에서의 Data Unit이 수많은 네트워크를 통과해야 함(LAN/WAN)
- 이 LAN/WAN들은 Router로 연결되어 있음
- 관습적으로 End Host 두개, Router들을 **Nodes**라고 부르고, 사이의 Network들을 **Links**라고 부름 

![1556088617222](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556088617222.png)

## Services

### Framing

- Data-Link layer에서의 Encapsulation / Decapsulation
- 소스노드에 도착한 Datagram은 Data-Link Layer에서 Frame으로 Encapsulate된다
- 이 프레임은 Intermediate Router로 전송되고 해당 Data-Link Layer에서 Decapsulate된 후, 다시 다른 프레임으로 Encapsulate된다

![1556088745344](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556088745344.png)

- 프레임은 **Header**와 **Tail(Trailer)**를 가질 수 있음
- Data-Link Layer가 다르다면, Framing Format도 달라짐(자연스러운 것)

### Flow Control

- Sender가 Receiver가 받기 힘들정도로 데이터를 너무 빨리 보내지 않도록 확인하는 것
- Sender가 보내는 속도가 Receiver가 받는 속도에 빠르다면, 받는 쪽에서 받아들이기 전에 Buffer되어야 함
- 문제점 : Receiving Part에서 받을 수 있는 버퍼의 크기가 한정적이다
  - 해결법 
    - Discard(버리기) : Buffer가 가득 차는 것을 막기 위해 Frame을 버림
    - Sender의 Data-Link Layer에게 좀 느리게 하거나 멈추라고 Feedback을 보냄
- Transport Layer에서도 다른 Flow Control Mechanism이 있음

### Error Control

- 오류탐지 수단 : CRC, Checksum, Parity Bits
- 오류를 탐지한 후에, Receiver 쪽에서 교정되거나, 버리고 재전송 요청을 해야함

### Congestion Control

- Link가 Frame으로 가득차서 혼잡해질 수 있지만, Data-Link Layer에서는 이를 **컨트롤하지 않음**
- Transport Layer(End-to-End Protocol의 경우) 또는 Network Layer에서 이루어짐

## Two Link Categories

- Data-Link Layer는 **전도체(Medium)이 어떻게 사용되는지**를 컨트롤 하는 역할

### Point to Point Link

- 링크가 두 장치 전용(Dedicated) 회선임

### Broadcast Link

- 링크가 여러 장치의 짝들 사이에서 공유됨
- 여러 장치가 하나의 링크에 연결되어 있어도, 한번에 한쌍만 링크를 사용할 수 있음
  - 이걸 컨트롤 하는 메커니즘이 필요함 : **MAC(Media Access Control)**

## Two Sublayers

- 두개의 Sublayer로 나눠질 수 있음
- Data Link Control(DLC)
- Media Access Control(MAC)

![1556089651373](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556089651373.png)

# Link-Layer Addressing

- 네트워크 레이어에서 **IP 주소**를 identifier로 사용하는 방법 
- 하지만 인터넷 같은 Internetwork에서는, IP 주소만으로는 **Datagram이 목적지를 찾아가게 할 수 없음**

- IP주소는 양 끝의 주소를 뜻하지만, 패킷들이 **어느 링크를 통해 갈 것인지**를 정의 못함

- MAC Address : Link-Layer Address, Link Address, Physical Address

![1556089889086](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556089889086.png)

## Three Types Of Addresses

### Unicast

- 1대1 커뮤니케이션
- 라우터의 각 호스트/인터페이스가 Unicast 주소로 등록됨
- 링크에서 하나의 엔티티만 목적지로 가짐
- LAN/Ethernet에서 48비트 사용12개의 16진수 주소로 사용(2번째 16진수는 **홀수**)
  - ex) A**3**:34:45:11:92:F1

### Multicast

- 1대**다(many)** 커뮤니케이션
- Jurisdiction(관할권)이 링크에서 지역적으로 존재
- LAN/Ethernet에서 48비트 사용12개의 16진수 주소로 사용(2번째 16진수는 **짝수**)
  - ex) A**2**:34:45:11:92:F1

### Broadcast

- 1대**다(ALL)** 커뮤니케이션

- 링크에 있는 모든 엔티티에게 전송됨
- LAN/Ethernet에서 48비트 사용12개의 16진수 주소로 사용
  - ex) FF:FF:FF:FF:FF:FF

### ARP

- 한 노드가 링크에 있는 다른 노드에게 IP **datagram**을 보낼 때, 받는 노드의 IP주소를 갖고 있어야 함
- 하지만 다음 노드의 IP주소는 **frame을 링크를 통해서 보낼 때**는 도움 안됨
  - 다음 노드의 **Link-Layer의 주소**가 필요함

- ARP는 네트워크 레이어 프로토콜에 속함
- IP 주소를 Link-layer Address로 MAP함
  1. IP 프로토콜로부터 IP주소를 받아옴
  2. IP 주소를 대응하는 Link-Layer Address로 MAP함
  3. Map한 주소를 Data-Link Layer로 보냄

![1556090371535](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556090371535.png)

#### Operation

- Sender가 Receiver의 MAC 주소를 모를 때, Receiver의 **IP주소의 Query**를 Broadcast 함
  - Link의 Link-Layer Broadcast Address 이용
- Receiver가 자신의 IP 주소가 맞음을 확인하면, Sender에게 **ARP reply packet**을 보냄
  - 패킷에 자신의 MAC id 포함

#### Packet Format

- Hardware Type : Link-Layer 프로토콜의 Type (Ethernet : 1)
- Protocol Type : 네트워크 레이어 프로토콜 (IPv4 : 0800)

![1556090612712](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556090612712.png)

![1556090799251](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556090799251.png)

