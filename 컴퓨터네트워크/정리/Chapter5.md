# Digital to Analog Conversion
- 아날로그 시그널의 특징 하나를 바꿔서 디지털 시그널을 표현하는데에 사용 할 수 있음
- Digital Data -> Analog Signal
- Bit rate : bps
- Baud rate : signal elements / S = N * 1/r
  - s = signal rate, N = bit rate, r = log_2 L
  - 디지털 데이터의 아날로그 tx에서 baud rate <= bit rate
- Carrier signal(Carrier Frequency, fc)
  - Transmitted Electromagnetic Pulse or Wave at a steady base frequency of alternation on which information can be imposed
  - 시그널 강도, base frequency 변화, wave phase 변경 등의 수단으로 전달
    - 이 변화가 Modulation
  - 아날로그 sender는 고주파를 보냄(정보 시그널의 base 역할)
    - this base signal is called **fc** (carrier signal / carrier frequency)
  - 디지털 정보는 이 fc의 **characteristics**를 하나 변경해서 변화시킴(Modulation)
    - Amplitude
    - Frequency
    - Phase
  - receiver가 이 Carrier Siganl을 tune함
## Amplitude Shift Keying(ASK)

- 시그널 엘리먼트 생성을 위해 Carrier Signal의 Amplitude를 변화시킴
- 나머지 Frequency와 Phase는 같은 값 계속 유지

![1556084317271](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556084317271.png)

### Binary ASK(BASK)

- 두개의 레벨만 사용해서 구현한 ASK

- On-off Keying(**OOK**)로 불리기도 함
- 낮은 레벨 = 이진수 **0**, 높은 진폭 = 이진수 **1**

![1556084397906](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556085345570.png)

- Bandwidth = (1+d) * S
  - 0 <= d <= 1 (Modulation / Filtering Process에 따라 바뀜), S = Signal Rate
- Bandpass 채널이 가용하면, 해당 Bandpass의 F_c가 선택됨

- Full-Duplex Link를 양방향 통신에 사용하면, Bandwidth를 반으로 갈라서 두개의 Carrier Frequency가 필요하게 됨 -> Data rate가 그만큼 줄어듬
  ![1556084766079](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556084766079.png)

## Frequency Shift Keying(FSK)

- Carrier Signal의 Frequency를 변경해서 데이터를 표현

- 하나의 시그널 엘리먼트 도중에는 **Constant** 하지만, 데이터 엘리먼트가 바뀌면 다음 시그널 엘리먼트때는 변경되도록 함

- 나머지 Amplitude, Phase는 **CONSTANT**

- 두개의 Carrier Frequency 

  - F1 : 0
  - F2 : 1

  ![1556084965457](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556084965457.png)

### Binary FSK (BFSK)

- B = (1+d) * S + 2Δf
  - S : Signal Rate, 0 <= d <= 1, Δf : f1과 f2의 차이

- Coherent(논리정연한) Implementation

  - VCO(Voltage Contolled Oscillator)를 사용
  - Input Signal Frequency를 input voltage에 대응하여 바꿈

  ![1556085419854](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556085419854.png)

## Phase Shift Keying(PSK)

- 두개 이상의 다른 시그널 엘리먼트를 표현하기 위해 Carrier Signal의 Phase를 활용
- Amplitude, Frequency는 **CONSTANT**
- ASK, FSK에 비해 **흔하게 사용됨**
- QAM(Quadrature Amplitude Modulation) : ASK와 PSK를 섞은 개념
  - **가장 많이 쓰임**

### Binary PSK (BPSK)

- bit 1 : Phase 0˚
- bit 0 : Phase 180˚

![1556085969938](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556085969938.png)

- 장점

  -  ASK에 비해 Noise에 덜 민감하다
  - FSK보다 뛰어나다(두개의 Carrier를 필요로 하지 않음)

- 단점 

  - 더 복잡한 하드에어가 필요함(Phase를 구분하기 위해)

- Bandwidth : ASK와 같음 (B = (1+d) * S)

  - BFSK보다 작음(낭비되는 carrier signal이 없다)

  ![1556086111486](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556086111486.png)

### Quadrature PSK (QPSK)

- 각각의 Signal Element에 2개의 비트를 사용
- 두개의 다른 BPSK Modulation을 사용함
  - 하나는 in-phase
  - 다른 하나는 out-of-phase(= Quadrature)
- 들어오는 비트들은 먼저 Serial-to-Parallel Conversion을 거침
  - 하나는 Modulator로, 다음 비트는 다른 Modulator로
- 결과로 만들어진 2개의 복합시그널은 같은 Frequency를 가진 Sine Wave지만 **Phase가 다름**
- 이 2개의 복합시그널을 합치면 또다른 Sine Wave가 됨
  - 4개의 가능한 Phase : 45 / -45 / 135 / -135
  - 4개의 Output Signal(L = 4), 따라서 하나의 시그널 엘리먼트에 2개의 비트를 보낼 수 있음

![1556086353085](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556086353085.png)

## Constellation Diagram

- Signal Components modulated by a digital modulation scheme의 그래픽 표현
  - 시그널은 2차원 스캐터 다이어그램으로 표현 
  - Signal Element Type을 Dot(X,Y)으로 표현

![1556086582207](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556086582207.png)

## Quadrature Amplitude Modulation(QAM)

- PSK : Limited by the ability of the equipment to **distinguish small differences** in phase
- ASK와 PSK를 합쳐서 quadrature와 Amplitude Level을 동시에 사용한다면?

- 4-QAM : Signal Element Type이 4개
- 16-QAM : Signal Element Type이 16개

![1556086841350](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556086841350.png)

# Analog-To-Analog Conversion

- Analog 정보를 Analog 시그널로 표현하는 법
- Modulation이 필요할 때
  - The medium is bandpass in nature
  - Only bandpass channel us available to us

## Amplitude Modulation(AM)

- Carrier Signal is modulated so that its amplitude varies with the changing amplitudes of the modulating signal
- Frequency와 Phase는 **CONSTANT**
- 주로 하나의 Multiplier를 사용해 구현(Amplitude가 Modulating Signal에 대응되게 바껴야되기 때문)

![1556087111705](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556087111705.png)

- B_AM = 2 B
  - B = Bandwidth of the modulating (audio) signal

- AM Radio의 경우 : Audio 시그널의 B = 5 KHz, 각 라디오 스테이션 별로 10KHz씩 할당
  - 총 AM Band = 530 ~ 1700 KHz
  - Guard Band(최소 10KHz)가 필요함(Signal 혼잡을 막기 위해)

## Frequency Modulation (FM)

- Modulating Signal의 Voltage Level(Amplitude) 변화를 따라가기 위해 Carrier Signal의 Frequency를 Modulate
- Amplitude, Phase는 **CONSTANT**
- Modulating Signal의 **Amplitude**가 바뀌면, Carrier의 **Frequency**가 대응되게 변화함
  - VCO가 진폭에 따라서 Modulated Signal 생산

![1556087773785](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556087773785.png)

- B_FM = 2(1 + β) B
  - β = factor depending on modulation technique(주로 **4**), B = modulating signal의 Bandwidth

- FM Radio의 경우 : Stereo service를 위해 15KHz Bandwidth 필요
  - 각 FM Station에 200KHz 허용
  - 최소 200KHz의 Guard Band가 필요함(Signal 혼잡을 막기 위해)
    - β 값 때문에 **더 많은 Guard Band**가 필요함
  - 총 FM Band = 88 ~ 108 MHz
  - 잠재적으로 100개의 FM bandwidth존재
  - Alternate Bandwidth만 할당에 사용, 나머지는 Guard Band를 위해 사용 안함
  - 50개가 한번에 동작 가능

## Phase Modulation (PM)

- Modulating Signal의 Voltage Level(Amplitude) 변화를 따라가기 위해 Carrier Signal의 Phase를 Modulate
- Amplitude, Frequency는 **CONSTANT**
- Amplitude에 대응되도록 Carrier Signal의 Phase가 변화

![1556088103442](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556088103442.png)

- B_PM = 2(1 + β) B
  - β = factor depending on modulation technique, B = Modulating Signal의 Bandwidth
  - β값은 경험적으로 얻어짐
  - FM과 같지만, β값이 narrowband에서 **1**, wideband에서 **3**임

![1556088312390](C:\Users\mskwon\AppData\Roaming\Typora\typora-user-images\1556088312390.png)

