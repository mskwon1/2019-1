# Digital to Analog Conversion
- 아날로그 시그널의 특징 하나를 바꿔서 디지털 시그널을 표현하는데에 사용 할 수 있음
## Modulating
- Bit rate : bps / s
- Baud rate : signal elements / s : S = N(bit rate) * 1/r(log_2 L)
  -> 디지털 데이터의 아날로그 tx에서 baud rate <= bit rate
- Carrier signal(Carrier Frequency, fc) : 정보 시그널의 배이스가 되는 sender가 만들어내는 고주파 시그널
  -> 디지털 정보가 캐리어 시그널의 특징중 하나를 변화시켜서 modulation(shift keying)
### Amplitude Shift Keying(ASK)
- 시그널 엘리먼트를 변화시키기 위해 carrier signal의 진폭이 변화됨, 변화하는동안 frequency, phase는 고정
### Binary ASK(BASK) = On Off Keying(OOK)
- 2레벨을 사용해 구현된 ASK
- 낮은 레벨은 0, 높은 진폭은 1을 의미
- Bandwidth = (1+d) * S(signal rate)
  -> 0 <= d <= 1
- bandpass channel이 가용하면, bandpass의 carrier signal이 정해짐
### Frequency Shift Keying(FSK)
- carrier signal의 frequency가 데이터를 표현하기 위해 변함
- 데이터 엘리먼트가 변하면 
