/*
  DML : Data Manupulation Language : 데이터 조작(처리)어
        데이터를 추가,변경,삭제,조회 언어들
        CRUD : Create, Read, Update, Delete
        C : 데이터 추가 => insert
        R : 데이터 조회 => select
        U : 데이터 변경 => update
        D : 데이터 삭제 => Delete
        Transaction 처리 가능 
   TCL : Transaction Control Language : commit, rollback     
*/
SHOW VARIABLES LIKE 'autocommit' -- autocommit이 아닌 상태인지 확인
SET autocommit =TRUE -- autocommit 상태로 변경
SET autocommit =FALSE -- autocommit 이 아닌 상태로 변경. 
-- student_1 테이블 조회하기
SELECT * FROM student_1 
-- 전공1학과코드가 202번 학생 정보를 삭제하기
DELETE FROM student_1 WHERE major1 = 202
-- student_1 테이블 조회하기
SELECT * FROM student_1 
COMMIT

/*
  insert : 데이터 추가 명령어
  
  기본구문
  insert into 테이블명 [(컬럼명1, 컬럼명2,...)] values (값1,값2,....)
  => 컬럼명의 갯수와 값의 갯수가 같아야함.
*/
SELECT * FROM depttest1
-- 90번 특판팀 추가하기
INSERT INTO depttest1 (deptno,dname) VALUES (90,"특판팀")
SELECT * FROM depttest1
ROLLBACK -- insert 구문의 실행을 취소함. 
SELECT * FROM depttest1

-- 91번 특판1팀 추가하기
INSERT INTO depttest1 VALUES (91,"특판1팀",NULL)
SELECT * FROM depttest1
COMMIT
/*
   - 컬럼명 부분을 구현하지 않으면 스키마에 정의된 모든 컬럼의 순서대로 값을
     입력해야함
   - 컬럼명을 구현해야 하는 경우
     1. 모든 컬럼의 값을 입력하지 않는 경우
     2. 스키마 등록된 컬럼의 순서를 모를때 
     3. db의 구조가 자주 변경되는 경우 컬럼명을 기술하는 것이 안전함
*/
DESC depttest1

SELECT * FROM depttest2
-- depttest2 테이블에 여러개의 레코드를 추가하기
-- 91 특판1팀
-- 50 운용팀 울산
-- 70 총무팀 서울
-- 80 인사팀 울산

INSERT INTO depttest2 (deptno,dname, loc)
  VALUES (91, "특판1팀",NULL),
		   (50, "운용팀","울산"),
		   (70, "총무팀","서울"),		   
		   (80, "인사팀","울산")
SELECT * FROM depttest2	
	   
-- 기존테이블을 이용하여 데이터 추가하기
SELECT * FROM depttest3
TRUNCATE TABLE depttest3 -- depttest3 테이블의 모든 데이터 제거하기
SELECT * FROM depttest3
-- depttest2의 내용을 depttest3테이블에 저장하기
SELECT * FROM depttest2
/*
  depttest2에서 조회된 컬럼의 갯수와
  depttest3의 컬럼의 갯수가 동일해야함
*/
INSERT INTO depttest3 SELECT * FROM depttest2
SELECT * FROM depttest3
-- depttest2의 내용을 depttest4테이블에 저장하기
SELECT * FROM depttest4
INSERT INTO depttest4 SELECT deptno,dname FROM depttest2
SELECT * FROM depttest4
-- depttest5테이블을 depttest2와 같은 컬럼을 가진 테이블로 생성하기
-- 데이터는 저장하지 않는다.
CREATE TABLE depttest5 AS SELECT * FROM depttest2 WHERE 1 = 2
SELECT * FROM depttest5
-- depttest5에 depttest4의 데이터를 저장하기
INSERT INTO depttest5 (deptno,dname) SELECT * FROM depttest4
SELECT * FROM depttest5
-- depttest5데이터를 전부 제거하기
TRUNCATE TABLE depttest5
SELECT * FROM depttest5
-- depttest5 테이블에 depttest4의 데이터를 저장하기. 
-- depttest5 테이블에 loc 컬럼의 값은 서울로 저장하기
INSERT INTO depttest5 SELECT *,'서울' FROM depttest4
SELECT * FROM depttest5

/*
  문제
  test3 테이블에 3학년 학생의 
  no : 학번, seq:1, name:학생이름, birth:생일 을 저장
*/
SELECT * FROM test3
INSERT INTO test3 (NO,seq,NAME,birth)
SELECT studno, 1, NAME, birthday FROM student
WHERE grade = 3
SELECT * FROM test3
COMMIT
/*
  update : 데이터의 내용을 변경 명령어
  
  update 테이블 set 컬럼1=값1, 컬럼2=값2,...
  where 조건문 => 없으면 모든 레코드가 선택
               => 있으면 조건문결과가 참인 레코드만 선택
*/
-- emp 테이블에서 사원 직급의 직원의 보너스를 10만원 인상하기
-- 보너스가 없는 경우는 0으로 처리한다
SELECT * FROM emp WHERE job="사원"
UPDATE emp SET bonus = bonus + 10
WHERE job="사원"
SELECT * FROM emp
rollback
UPDATE emp SET bonus = ifnull(bonus,0) + 10
WHERE job="사원"
SELECT * FROM emp
ROLLBACK
/*
  문제
  이상미 교수와 같은 직급의 교수 중 급여가 350미만인 교수의
  급여를 10% 인상하기
*/
SELECT * FROM professor
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME='이상미')
  AND salary < 350
  
UPDATE professor SET salary = salary* 1.1  
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME='이상미')
  AND salary < 350

