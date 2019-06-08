-- Queries for kleague Sample Database
-- Version 1.0

USE kleague;

DESCRIBE PLAYER;
DESCRIBE TEAM;
DESCRIBE STADIUM;
DESCRIBE SCHEDULE;


-------------------------------------------
-- 1. Subquery (SELECT 문의 WHERE 절)
-------------------------------------------

-------------------------------------------
-- 1.1 Single Row Subquery (단일행 서브쿼리)
-------------------------------------------

USE kleague;

-- Q1: '정남일' 선수가 소속된 팀의 선수들에 대한 정보를 검색 (비연관 서브쿼리)

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버 
FROM 	PLAYER 
WHERE 	TEAM_ID = (	SELECT	TEAM_ID 
					FROM	PLAYER 
					WHERE	PLAYER_NAME = '정남일' ) 
ORDER 	BY PLAYER_NAME;

-- Q2: 서브쿼리에 집단함수를 사용 (비연관 서브쿼리)

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버 
FROM 	PLAYER 
WHERE 	HEIGHT <= (	SELECT	AVG(HEIGHT) 
					FROM	PLAYER ) 
ORDER 	BY PLAYER_NAME; 


-------------------------------------------
-- 1.2 Multi-Row Subquery (다중행 서브쿼리)
-------------------------------------------

-- Q3: ‘정현수’ 선수가 소속되어 있는 팀 정보를 검색 (비연관 서브쿼리)

-- 에러: 결과가 2개 이상
SELECT 	REGION_NAME 연고지명, TEAM_NAME 팀명, E_TEAM_NAME 영문팀명 
FROM 	TEAM 
WHERE 	TEAM_ID = (	SELECT	TEAM_ID 
					FROM	PLAYER 
					WHERE	PLAYER_NAME = '정현수') 
ORDER 	BY TEAM_NAME;

SELECT 	REGION_NAME 연고지명, TEAM_NAME 팀명, E_TEAM_NAME 영문팀명 
FROM 	TEAM 
WHERE 	TEAM_ID IN (SELECT	TEAM_ID 
					FROM	PLAYER 
					WHERE	PLAYER_NAME = '정현수') 
ORDER 	BY TEAM_NAME;


-- Q4: 소속팀별 키가 가장 작은 사람들의 정보를 검색 (연관 서브쿼리)

SELECT	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	(TEAM_ID, HEIGHT) IN (	SELECT	TEAM_ID, MIN(HEIGHT) 
								FROM	PLAYER 
								GROUP	BY TEAM_ID	) 
ORDER 	BY TEAM_ID, PLAYER_NAME;


-------------------------------------------
-- 1.3 Correlated Subquery (연관 서브쿼리)
-------------------------------------------

-- Q5: 선수 자신이 속한 팀의 평균 키보다 작은 선수들의 정보를 검색.

SELECT	T.TEAM_NAME 팀명, P.PLAYER_NAME 선수명, P.POSITION 포지션, P.BACK_NO 백넘버, P.HEIGHT 키 
FROM	PLAYER P, TEAM T 
WHERE	P.TEAM_ID = T.TEAM_ID AND 
		P.HEIGHT < (	SELECT	AVG(PP.HEIGHT) 
						FROM	PLAYER PP
						WHERE	PP.TEAM_ID = P.TEAM_ID	)
ORDER	BY 팀명, 선수명;

-- Q6: 20120501부터 20120502 사이에 경기가 있는 경기장을 조회.

SELECT	STADIUM_ID ID, STADIUM_NAME 경기장명 
FROM	STADIUM A 
WHERE	EXISTS (	SELECT 	*
					FROM 	SCHEDULE X 
					WHERE	X.STADIUM_ID = A.STADIUM_ID AND 
							X.SCHE_DATE BETWEEN '20120501' AND '20120502' );

/* 위의 질의와 같은 결과 */
SELECT	STADIUM_ID ID, STADIUM_NAME 경기장명 
FROM	STADIUM A 
WHERE	EXISTS (	SELECT 	1				/* 무슨 갑시 오더라도 결과에 영향을 주지 못 함 */
					FROM 	SCHEDULE X 
					WHERE	X.STADIUM_ID = A.STADIUM_ID AND 
							X.SCHE_DATE BETWEEN '20120501' AND '20120502' );


-------------------------------------------
-- 2. Subquery (SELECT 문의 WHERE 절 이외의 위치)
-------------------------------------------

-------------------------------------------
-- 2.1 Subquery : SELECT 문의 FROM 절 (inline view, 혹은 dynamic view라 함)
-------------------------------------------

-- Q7: 팀번호 K09의 선수 이름, 포지션, 백넘버를 검색

SELECT	PLAYER_NAME, POSITION, BACK_NO
FROM	(
			SELECT	TEAM_ID, PLAYER_ID, PLAYER_NAME, POSITION, BACK_NO
			FROM	PLAYER
			ORDER 	BY PLAYER_ID ASC
		) AS TEMP						/* In MySQL, every derived table must have its own alias. */
WHERE	TEAM_ID = 'K09';

SELECT * FROM TEMP;
DESCRIBE TEMP;


-- Q8: 포지션이 MF인 선수들의 소속팀명 및 선수 정보를 검색

SELECT	T.TEAM_NAME 팀명, P.PLAYER_NAME 선수명, P.BACK_NO 백넘버 
FROM	(
			SELECT	TEAM_ID, PLAYER_NAME, BACK_NO 
			FROM	PLAYER 
			WHERE	POSITION = 'MF'
		) P, TEAM T 
WHERE	P.TEAM_ID = T.TEAM_ID 
ORDER	BY 팀명, 선수명; 


-- Q9: 키가 제일 큰 5명 선수들의 정보를 검색 (top-N query)

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버,
		HEIGHT 키 
FROM 	(
			SELECT 	PLAYER_NAME, POSITION, BACK_NO, HEIGHT 
			FROM 	PLAYER 
			WHERE 	HEIGHT IS NOT NULL 
			ORDER 	BY HEIGHT DESC
		) AS TEMP
LIMIT	5;


-------------------------------------------
-- 2.2 Subquery : SELECT 문의 SELECT 절 (Scalar Subquery)
-------------------------------------------

-- Q10: 선수 정보와 해당 선수가 속한 팀의 평균 키를 함께 검색.

SELECT 	TEAM_ID, PLAYER_NAME 선수명, HEIGHT 키, 
		(
			SELECT	ROUND(AVG(HEIGHT),2) 
			FROM	PLAYER X 
			WHERE	X.TEAM_ID = P.TEAM_ID
		) 팀평균키 
FROM	PLAYER P
ORDER	BY TEAM_ID;


-------------------------------------------
-- 2.3 Subquery : SELECT 문의 HAVING 절
-------------------------------------------

-- Q11: 평균키가 K02 (삼성 블루윙즈) 팀의 평균키보다 작은 팀의 이름과 해당 팀의 평균키를 검색

SELECT	P.TEAM_ID 팀코드, T.TEAM_NAME 팀명, AVG(P.HEIGHT) 평균키 
FROM	PLAYER P JOIN TEAM T ON P.TEAM_ID = T.TEAM_ID 
GROUP	BY P.TEAM_ID
HAVING	AVG(P.HEIGHT) < (	SELECT	AVG(HEIGHT) 
							FROM	PLAYER 
							WHERE	TEAM_ID ='K02' 
						);


-------------------------------------------
-- 2.4 Subquery : UPDATE 문
-------------------------------------------

ALTER	TABLE	TEAM
ADD		COLUMN	STADIUM_NAME VARCHAR(40);

UPDATE	TEAM T 
SET		T.STADIUM_NAME = (	SELECT	S.STADIUM_NAME 
							FROM	STADIUM S 
							WHERE	S.STADIUM_ID = T.STADIUM_ID); 


-------------------------------------------
-- 2.5 Subquery : INSERT 문
-------------------------------------------

/* 에러: @@optimizer_switch의 derived_merge와 관련이 있음. */
INSERT	INTO	PLAYER (PLAYER_ID, PLAYER_NAME, TEAM_ID) 
VALUES	(
			(SELECT	MAX(PLAYER_ID) + 1 
			FROM 	PLAYER), 
		'홍길동', 'K06'); 


-------------------------------------------
-- 3. View
-------------------------------------------

-- DDL: 뷰 생성
 
CREATE 	VIEW V_PLAYER_TEAM AS 
SELECT 	P.PLAYER_NAME, P.POSITION, P.BACK_NO, P.TEAM_ID, T.TEAM_NAME 
FROM 	PLAYER P, TEAM T 
WHERE 	P.TEAM_ID = T.TEAM_ID; 

CREATE 	VIEW V_PLAYER_TEAM_FILTER AS 
SELECT 	PLAYER_NAME, POSITION, BACK_NO, TEAM_NAME 
FROM 	V_PLAYER_TEAM 
WHERE 	POSITION IN ('GK', 'MF'); 


-- Q12: 뷰에 대한 질의와 변환된 질의

SELECT 	PLAYER_NAME, POSITION, BACK_NO, TEAM_ID, TEAM_NAME 
FROM 	V_PLAYER_TEAM 
WHERE 	PLAYER_NAME LIKE '황%';

SELECT 	P.PLAYER_NAME, P.POSITION, P.BACK_NO, P.TEAM_ID, T.TEAM_NAME
FROM 	PLAYER P, TEAM T
WHERE 	P.TEAM_ID = T.TEAM_ID AND P.PLAYER_NAME LIKE '황%';


-- Q13: 뷰에 대한 질의와 변환된 질의

SELECT 	PLAYER_NAME, POSITION, BACK_NO, TEAM_NAME 
FROM 	V_PLAYER_TEAM_FILTER 
WHERE 	PLAYER_NAME LIKE '황%';

SELECT 	P.PLAYER_NAME, P.POSITION, P.BACK_NO, T.TEAM_NAME
FROM 	PLAYER P, TEAM T
WHERE 	P.TEAM_ID = T.TEAM_ID AND POSITION IN ('GK', 'MF') AND 
		P.PLAYER_NAME LIKE '황%';

