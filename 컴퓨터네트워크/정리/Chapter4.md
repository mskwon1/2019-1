# Digital Transmission
## Digital-To-Digital Conversion
- 신호는 디지털일수도 아날로그일수도있음
- 디지털 데이터를 디지털신호로 보내는법
### Line Coding(항상 필요함)
- 데이터가 비트들로 구성됐다고 가정
- 이 비트들을 디지털 신호로 변환
- Sender(bit) -> 변환 -> 신호 -> receiver -> 변환 -> bit
- Built-in error detection 필요
- 노이즈와 방해에 면역
- 복잡할수록 구현하기 어려움
#### Signal Elements vs Data Elements
- Data Elemetns - Bit : 정보를 표현하는 가장 작은 단위 - carried by signal
- Signal Elements : data elements를 가지고 있는 **디지털 신호중** 가장 작은 단위 - carries data elements
- **r** : 각각의 신호가 데이터를 carry 하는 비율 = (data elem/signal elem)
#### Data Rate vs Signal Rate
- Data Rate(bit rate) : 1초에 보내는 **데이터(bit) 수** - bps
- Signal Rate(pulse rate, modulation rate, baud rate) : **1초에 보내는 시그널 수** - **baud**
- 데이터레이트는 높이고, 시그널 레이트는 낮추는걸(bandwidth 요구량이 낮아짐) 목표
- S(baud) = N(data rate)/r
- S_ave(평균 baud rate) = c(case factor) * N(bps) * (1/r) = c * (N/r)
#### Bandwidth
- 디지털 신호의 bandwidth는 무한하지만, 실제로 효력이 있는 bandwith는 유한하다
- B_min = c * N * (1/r), B_max = (1/c) * B(Bandwidth) * r
#### Baseline Wandering(방황)
- baseline : 받은 신호의 running average power -> receiver가 측정
  -> 이를 활용해 받은 값이 1인지 0인지 판단
- 받은 신호의 값이 오래동안 변하지 않으면, baseline이 바뀜(baseline wandering) -> 정확한 값 판단 불가능
#### DC(Direct Current) Components
- 전압 레벨이 일정시간동안 유지되면, 아주 낮은 주파수를 만듬
- x(t) = A + Bsin(2파이ft)
- 0 근처의 이 주파수들은 낮은 주파수를 보낼 수 없는 시스템에 문제 발생
  -> 왜곡 발생, 오류 발생
- 저주파가 통과 못하는 시스템에서는 왜곡이 일어남
- 이 Component는 쓸모없음
#### Self-Synchronization
- receiver와 sender의 bit interval(clock)을 맞춰줘야 함
- 타이머가 다르면 신호를 서로 다르게 해석 할 수 있음
- 데이터를 보낼 때 시간 관련 정보도 같이 보냄
#### Unipolar schemes
- 모든 신호 레벨이 시간 축의 한쪽에 몰려있음  (위 또는 아래)
- 양수전압 : 1, 0 전압 : 0
- NRZ(Non return to Zero) : 비트 **중간에** 0으로 return 하지 않음
- 매우 비싸고, 잘 안쓰임 1 비트를 보낼려면 polar NRZ의 두배 power가 필요
#### Polar schemes
- 전압이 양쪽 사이드에 퍼짐
- 양수 전압 : 0, 음수 전압 : 1
- NRZ-L(Level) : 전압의 레벨이 bit의 값 결정
- NRZ-I(Inverter) : 전압의 레벨이 변화/변화하지않는것이 비트의 값 결정
  -> 0일 때 변화 X, 1일 때 변화
- Baseline Wandering이 일어날 가능성 높음(특히 NRZ-L)
- Synchronization 문제 (특히 NRZ-L)
- Signal Rate : N/2 Baud
- Bandwidth : 둘다 DC Component문제가 있음
- RZ(Return to Zero) : NRZ의 synchronization문제 해결, receiver가 한 비트가 언제 끝나는지 언제 시작하는지 모름
  -> +(1),-(0),zero 사용
  -> 신호가 비트와 비트 사이가 아니라 비트 중간에 바뀜
  -> 다음 비트가 시작되기 전까지 신호값이 0으로 고정
  -> bit encoding을 위해 2개의 신호가 필요함(더 많은 bandwidth), 더 복잡하고, DC Component가 없음
      -> 더 복잡하지만, DC Component가 없음, 현재는 많이 사용 안함
- **Biphase : Manchester, Differential Manchester**
  -> Manchester : RZ + NRZ-L
      비트의 지속시간이 둘로 나눠짐, 전반부에는 한 레벨에 머물러있고, 후반부에 다른 레벨로 이동함
      NRZ-L의 한계 극복
  -> Differential Manchester : RZ + NRZ-I
      비트의 값이 초반부에 정해짐, 다음값이 0이면 inversion, 1이면 아무것도 안함
      NRZ-I의 한계 극복
  -> baseline wandering, dc components가 없음, 낮은 signal rate(NRZ의 두배수준)
#### Bipolar schemes(Multi-level binary)
- 3개의 voltage level (-,0,+)
- 하나의 데이터 엘리먼트는 0에, 나머지 하나는 +/-중에 하나에 있음
- AMI(Alternative Mark Inversion) : Mark = 1(telegraph)
  -> 0 : netral 0 voltage, 1 : postitive/negative voltage
- Pseudoternary
  -> 1 : 0 voltage, 0 : postitive/negative voltage
- NRZ와 같은 signal rate
- DC components가 없음(+,- 왔다갔다 하거나, 0(dc components가 없는 값))
- AMI는 긴 거리 comms에 사용 -> Synchronization 문제 발생 -> scrambling으로 해결
#### Multi-level schemes
- m개의 data elem을 n개의 signal elem으로 encoding 해서 bits per baud를 늘림 : (mB) 데이터 (nL) 시그널
  -> m : binary pattern의 길이, B : binary data, n : signal pattern의 길이, L : signaling의 레벨의 수
- L의 값 -> B = 2, T = 3, Q = 4
- 2B1Q : Two binary, One Quarternary m = 2, n = 1, L = 4 -> 2bits = 4 data patterns (DSL에서 사용)
- 8B6T : 8 binary, Six Tenary : m = 8, n = 6, L = 3 -> 8 bits
          = 256 data patterns, 3^6 signal patterns (100BASE-4T에서 사용)
- 4D-PAM5 : 4차원 5레벨 Pulse Amplitude Modulation
  -> 4차원 : 데이터가 4개의 와이어를 통해 한번에 전달
  -> 5레벨 : 5개의 전압 레벨 (-2, -1, 0, 1, 2)
    => 4개의 신호 요소가 하나의 그룹으로 4개의 와이어를 통해 전달됨
    => Gigabit LAN에 사용 됨
- MLT-3 : Multiline Transmission, 3-levels
  -> 2레벨 이상의 signal이 있을 경우, 2개 이상의 transition 규칙을 따르는 differential encoding scheme을 쓸 수 있음
  -> +V, 0, -V(3 voltage level, 3 transition rules)
  1. 다음 비트가 0이면, 변화 X
  2. 다음 비트가 1이고 현재 레벨이 0이 아니면, 다음 레벨은 0
  3. 다음 비트가 1이고 현재 레벨이 0이면, 다음 레벨은 제일 최근의 nonzero level의 반대
  -> '1'비트가 시작 될 때 다른 레벨로 변화, '0'비트가 시작 될 때는 변화 X
