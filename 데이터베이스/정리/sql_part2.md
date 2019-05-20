# DML

## DATA UPDATE

### INSERT

- Syntax 1
  ![1557796115365](../../typora_images/1557796115365.png)
  - 컬럼명과 컬럼값은 순서대로 1:1 매핑
  - 컬럼값의 표현
    - 컬럼의 데이터유형이 문자 : ''으로 값을 표현
    - 컬럼의 데이터유형이 숫자 : ''를 **사용안함**

- Syntax 2
  ![1557796173573](../../typora_images/1557796173573.png)
  ![1557796230724](../../typora_images/1557796230724.png)

### DELETE 

- Syntax
  ![1557796271641](../../typora_images/1557796271641.png)
  - WHERE절이 없으면 전체 테이블 데이터 삭제
- 전체 테이블을 삭제하는 경우, 시스템 부하가 적은 **TRUNCATE TABLE** 권장
- DDL과 DML의 차이
  - DDL : 하드디스크에서 테이블에 직접 적용, 즉시 완료
  - DML : 테이블을 메모리 버퍼에 올려놓고 작업, 실시간 영향 X, COMMIT 명령어로 트랜잭션 종료해야 반영
  - SQL Server에서는 DML도 즉시완료, COMMIT 필요없음

### UPDATE

- Syntax
  ![1557796424251](../../typora_images/1557796424251.png)
  ![1557796487388](../../typora_images/1557796487388.png)

## QUERY

### SELECT

