# 관계 데이터 연산

- 관계 데이터 언어 (사용자)
  - 관계 대수 (Relational Algebra) 
    - 절차언어 - How, What
  - 관계 해석 (Relational Calculus)
    - 비절차 언어 - What
    - 튜플 관계 해석
    - 도메인 관계 해석
- 관계 해석과 관계 해석은 표현/기능 면에서 동등
- 상용 관계 데이터 언어
  - 관계 대수와 관계 해석을 기초로 함
  - SQL, QUEL, QBE

## 관계 대수

- 릴레이션 조작을 위한 **연산의 집합**
- 폐쇄 성질 
  - 피연산자와 연산 결과가 모두 릴레이션
  - 중첩된 수식의 표현이 가능함
- 구성
  -  릴레이션 : 튜플의 집합
  - 일반 집합 연산자 : UNION / INTERSECTION / DIFFERENCE / CARTESIAN PRODUCT
  - 순수 관계 연산자 : SELECT / PROJECT / JOIN / DIVISION

### 일반 집합 연산자

- 합집합(UNION)
  - 정의 : R ∪ S = {t | t∈R v t∈S}
  - Cardinality : max {|R|,|S|} <= |R ∪ S| <= |R| + |S|
- 교집합(INTERSECT)
  - 정의 : R ∩ S = {t | t∈R ^ t∈S}
  - Cardinality : 0 <= |R ∩ S| <= min {|R|, |S|}
- 차집합(DIFFERENCE) 
  - 정의 : R - S = {t | t∈R ^ t !∈ S}
  - Cardinality : 0 <= |R - S| <= |R|
- 카티션 프로덕트(CARTESIAN PRODUCT)
  - 정의 : R x S = {r º s | r∈R ^ s∈S} // º는 접속(Concatenation)을 의미
  - Cardinality : |R x S| = |R| * |S|
  - 차수 : R의 차수 + S의 차수 -> 애트리뷰트의 개수를 의미함
- 합병 가능한 릴레이션 : UNION / INTERSECT / DIFFERENCE의 피연산자들은
  - 차수가 같아야 하고
  - 대응 애트리뷰트 별로 도메인이 같아야 함
- 결합적 연산 : UNION / INTERSECT / CARTESIAN PRODUCT
  - 결합법칙이 적용됨 (A ∪ B) ∪ C = A ∪ (B ∪ C)
  - 교환법칙이 적용됨 A ∪ B = B ∪ A 

### 순수관계 연산자

- Symbolic Notations

  - 릴레이션 R : R(X), X= {A1 ~ An} -> R(A1,...,An)
  - R의 튜플 r : r ∈ R, r = <a1,...,an>
  - 튜플 r의 애트리뷰트 Ai의 값 : Ai = r[Ai] = ai

- SELECT(σ)

  - 정의 : A,B가 릴레이션 R(X)의 애트리뷰트일 때
    - σ_AΘv(R) = {r | r∈R ^ r.AΘv}
    - σ_AΘB(R) = {r | r∈R ^ r.AΘr.B}
    - Θ = {<, >, <=. >=, =, !=}, v는 상수
  - 선택 조건을 만족하는 릴레이션의 **수평적** 부분집합
  - (예시) σ 학과 = '컴퓨터' (학생)
    - 학생 릴레이션에서 학과 애트리뷰트가 컴퓨터인 튜플들의 릴레이션
  - (예시) σ 학번 = 300 ^ 과목번호 = 'C312' (등록) 
    - 등록 릴레이션에서 학번이 300 또는 과목번호가 C312인 튜플들의 릴레이션
  - (예시) σ 중간성적 < 기말성적 (등록)
    - 등록 릴레이션에서 중간성적 < 기말성적인 튜플들의 릴레이션
  - 데이터 언어식에서의 표현 : WHERE
  - 교환법칙 성립
  - 선택도 : 조건식에 의해 선택된 튜플들의 비율

- PROJECT(Π)

  - 정의 

    ![1555598288290](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555598288290.png)

  - 학생(학번,이름,학년)에서 Π_이름,학번(학생)

    - 학생 테이블에서 이름,학번 애트리뷰트값만 가져온 릴레이션

  - 릴레이션의 **수직적** 부분집합

  - 생성된 중복 튜플은 제거

  - Π\_y(Π\_x(R))  = Π\_y(R)

  - (예시) 학생 테이블에서 CS학과 3학년의 학번과 이름을 검색

    - Π이름,학번(σ 학과 = 'CS' v 학년 = 3 (학생))
    - SELECT부터 하고 PROJECT 해야 함
      순서가 바뀌면, SELECT의 조건식을 적용 할 수 없음

- JOIN(⋈)

  - 세타 조인

    ![1555598701043](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555598701043.png)

    - 결과 차수 = R의 차수 + S의 차수
    - A와 B는 조인 애트리뷰트, AΘB는 조인 조건식

  - 동일 조인

    ![1555598830726](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555598830726.png)

    - A와 B는 조인 애트리뷰트, A=B는 조인 조건식
    - 결과 차수 = R의 차수 + S의 차수
    - 결과의 Cardinality : 0 <= |R⋈_(A=B)S| <= |R| x |S|
    - (예시) 학생 ⋈_(학번=학번) 등록
      - 학생 릴레이션의 튜플의 학번 = 등록 릴레이션의 튜플의 학번인 애들을 합쳐서 릴레이션 짬뽕

  - 자연 조인(⋈_N)

    ![1555599136766](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555599136766.png)

    - 동일조인의 결과 릴레이션에서 애트리뷰트의 중복을 제거
    - 결과 차수 = R의 차수 + S의 차수 - |X∩Y|
    - Z(=X∩Y)는 조인 애트리뷰트, Z=Z는 조인 조건식

- DIVIDE(÷)

  - 정의

    ![1555599482902](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555599482902.png)

    - 나눠지는 애가 가지고 있는 애트리뷰트 값들을 보유하고 있는 튜플들
    - 차수는 X-Y가 됨

- RENAME(ρ)

  - 중간결과 릴레이션에 이름을 붙이거나 애트리뷰트 이름을 변경할 때 사용
  -  (예시)  ρ_s(E) : 관계 대수식 E의 결과 릴레이션의 이름을 s로 지
  -  (예시)  ρ_s(B\_1,...B\_m)(E) : 
    관계 대수식 E의 결과 릴레이션의 이름을 S로 하면서 애트리뷰트의 이름을 B1 ~ Bm으로 지정

### 근원연산과 복합 연산

- 근원연산 : UNION, DIFFERENCE, CARTESIAN PRODUCT, SELECT, PROJECT

- 복합연산 : INTERSECT, JOIN, DIVISION

- 복합연산은 근원연산으로 표현 가능함

  ![1555599991486](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555599991486.png)

### 관계대수의 확장

- SEMIJOIN(⋉,⋊)

  - 정의 

    ![1555600075187](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555600075187.png)

    - S와 자연조인을 할 수 있는 R의 튜플(기호가 뒤집히면 반대)

  - 특징

    - 사용자가 쓸일은 없음

    ![1555600123027](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555600123027.png)

  - 분산환경(R = 서울, S = 부산)

    ![1555600197169](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555600197169.png)

- OUTERJOIN(⋈+)
  - 정의 : 조인시 한 릴레이션에 있는 튜플이 조인할 상대 릴레이션에 **대응되는 튜플이 없을 경우**, 상대를 **NULL 튜플로 만들어** 결과 릴레이션에 포함

  - 두 조인 릴레이션의 모든 튜플들이 결과 릴레이션에 포함됨
  - Left Outer Join : R기준, Right Outer Join : S 기준, Full Outer Join : 둘다 포함시킴

- OUTER-UNION(∪+)

  - 정의 : 합병가능하지 않은(부분적으로만 가능한) 두 릴레이션을 차수를 확장시켜 합집합으로 만듬

**<u>~중간범위</u>**

------

- 집단연산
  - 수학적 집단 연산 : SUM, AVG, MAX, MIN, COUNT
  - 중복값이 있더라도 제외하지 않고 그대로 적용
  - NULL값의 처리에 주의

- 그룹연산

  - Group 연산
    - 주어진 기준 애트리뷰트의 값이 같은 튜플들끼리 그루핑
    - 내부적으로는 애트리뷰트 값을 기준으로 **정렬한** 것과 같은 효과
  - GROUP_학년(학생) : 학생 릴레이션을 학년 기준으로 그룹 -> 정렬

- 일반형식

  ![1555600651763](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1555600651763.png)

  - 각각의 그룹에 대해서 관계 대수식 수행

### 관계대수의 질의문 표현

1. 관련된 테이블과 속성을 파악
2. SELECT 연산을 적용
   - 조인 연산에 사용될 피연산자의 **크기를 최대한 줄임**
3. JOIN 연산을 적용
   - DIVIDE 연산은 실제로 사용 X
4. PROJECT 연산을 적용

![1556583768182](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556583768182.png)

- 삽입
  - 학번이 600, 이름이 김명호, 학년이 4, 학과가 컴퓨터인 학생을 학생 테이블에 삽입하라
    - 합집합 이용 **<> 표시** 해주는거 잊지말기
    - 학생 ∪ {<600, '김 명호', 4, ‘컴퓨터’>}

- 삭제

  - 과목 테이블에서 Database 과목을 삭제하라

    - 차집합 이용

    - – 과목 - ( σ과목명=‘Database' (과목) )

- 검색

  - 학과가 컴퓨터이고 학년이 3학년인 학생의 학번과 이름을 검색
    - ![1556583981090](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556583981090.png)
  - 학수 번호가 100인 과목을 등록하여 성적A를 받은 학생의 이름을 검색
    - ![1556584135276](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556584135276.png)
    - JOIN 하기전 **SELECT**를 하고 JOIN하는 것이 좋다
    - Query Optimization : DBMS가 알아서 내부적으로 질의문을 최적화 함
  - Database 과목을 등록한 학생의 이름을 검색
    - ![1556584665139](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556584665139.png)

  
  - Database 과목을 등록하여 성적 A를 받은 학생의 이름을 검색
    - ![1556584839817](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556584839817.png)

  - Database와 화일처리 과목을 같이 수강한 학생의 학번을 검색
    - ![1556584949813](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556584949813.png)

  - 컴퓨터 학과의 3학년 학생들 중 Database와 화일처리를 같이 수강한 학생의 학번을 검색
    - ![1556585479180](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556585479180.png)
  - 학수번호가 100인 과목을 등록하지 않은 학생의 이름은?
    - ![1556585609371](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556585609371.png)
  - Database 과목의 기말시험 평균은?
    - ![1556585705743](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556585705743.png)
    - 키가 있어야 중복이 제거됨
  - Kim 교수가 가르치는 각 과목의 기말시험 평균은?
    - ![1556585812859](C:\Users\user\AppData\Roaming\Typora\typora-user-images\1556585812859.png)

## 관계 해석

