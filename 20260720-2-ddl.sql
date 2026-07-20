/*
  DDL : Data Definition Language (데이터 정의어)
        객체(table, view, index, 제약조건)를 생성, 수정, 삭제하는 명령어
        
    create : 객체 생성
	 alter  : 객체 변경
	 drop   : 객체 제거
	 truncate : 테이블에서 데이터를 제거
	 
	 트랜젝션(transaction) 처리 불가   
*/
/*
   create : table 생성 명령어
*/
-- 정수형컬럼 no, 문자형 name, 날짜 : birth 컬럼을 가진 테이블 test1 생성
CREATE TABLE test1 (
  NO INT,
  NAME VARCHAR(20),
  birth datetime
)
SELECT * FROM test1
DESC test1
/*
  기본키 : 중복불가, null 불가. (unique + not null)
*/
-- 정수형컬럼 no, 문자형 name, 날짜 : birth 컬럼을 가진 테이블 test2 생성
-- no 컬럼을 기본키로 설정
CREATE TABLE test2 (
  NO INT PRIMARY KEY,  -- 컬럼 한개만 기본키로 설정
  NAME VARCHAR(20),
  birth datetime
)
DESC test2

-- 정수형컬럼 no,정수형컬럼 seq, 문자형 name, 날짜 : birth 컬럼을 
-- 가진 테이블 test3 생성
-- no,seq 컬럼을 기본키로 설정
CREATE TABLE test3 (
  NO INT,
  seq INT,
  NAME VARCHAR(20),
  birth DATETIME,
  PRIMARY KEY(NO,seq) -- 컬럼 여러개를 기본키로 설정
)
DESC test3
/*
  test2
  no name     birth
   1  홍길동  1990-01-01
   2  김삿갓  1990-01-01
   1  이몽룡  1990-01-01  => 입력불가. 기본키는 중복 불가

  test3
  no    seq     name    birth
   1    1     홍길동  1990-01-01
   2    1     김삿갓  1990-01-01
   1    2     이몽룡  1990-01-01 => 입력 가능. 
   1    null                     => 입력불가. 기본키는 null 불가
   null 1                     => 입력불가. 기본키는 null 불가
*/

/*
  default 제약조건 : 값이 null인 경우 기본값으로 설정
*/

-- 정수형컬럼 no,문자형 name, 날짜 : birth 컬럼을 
-- 가진 테이블 test4 생성.
-- name 값이 없으면 홍길동으로 저장
CREATE TABLE test4 (
   NO INT,
   NAME VARCHAR(20) DEFAULT "홍길동",
   birth datetime
)
DESC test4
-- 정수형컬럼 no,문자형 name, 날짜 : birth 컬럼을 
-- 가진 테이블 test5 생성.
-- no 기본키로, 자동으로 1씩 증가 
CREATE TABLE test5 (
   NO INT PRIMARY KEY auto_increment,
   NAME VARCHAR(20) DEFAULT "홍길동",
   birth datetime
)
/*
  auto_increment : 자동으로 1씩 증가. 기본키에서만 사용 가능
                   오라클에서는 사용 불가: 시퀀스(sequence) 객체 사용
*/
DESC test5
INSERT INTO test5 (NAME,birth) VALUES ('김삿갓','1990-01-01');
SELECT * FROM test5
INSERT INTO test5 (birth) VALUES ('1990-01-01')
SELECT * FROM test5

/*
   기존 테이블을 이용하여 새로운 테이블 생성하기
   제약조건은 복사안됨. 컬럼과 데이터는 복사됨
*/
-- dept 테이블과 같은 구조의 테이블 depttest1 생성하기
-- dept 테이블의 데이터도 함께 생성하기
CREATE TABLE depttest1 AS SELECT * FROM dept
SELECT * FROM depttest1
DESC dept
DESC depttest1

-- dept 테이블과 같은 구조의 테이블 depttest2 생성하기
-- dept 테이블 중 지역이 서울인 데이터만 저장
CREATE TABLE depttest2 AS SELECT * FROM dept WHERE loc="서울"
SELECT * FROM depttest2

-- dept 테이블 중 deptno,dname을 컬럼으로 가지는 테이블 depttest3 생성하기
CREATE TABLE depttest3 AS SELECT deptno,dname FROM dept
SELECT * FROM depttest3

-- dept 테이블 중 deptno,dname을 컬럼으로 가지는 테이블 depttest4 생성하기
-- 레코드는 복사하지 않는다
CREATE TABLE depttest4 AS SELECT deptno,dname FROM dept WHERE 1 = 2
SELECT * FROM depttest4

/*
 문제 1
 교수테이블에서 101학과 교수들만 테이터로 가지고 있는 테이블 professor_101
 테이블 생성하기
 필요한 컬럼은 교수번호(no),교수이름(name),학과코드(deptno),
 직급(position),학과명(major.name) 으로 한다
*/
CREATE TABLE professor_101
AS
SELECT p.no,p.name,p.deptno,p.position, m.name mname
FROM professor p, major m
WHERE p.deptno = m.code
 AND p.deptno = 101
 
DESC professor_101 
SELECT * FROM professor_101
/*
 문제 2
  학생테이블에서 1학년 학생들만 student_1 테이블로 생성하기
  필요한컬럼 : 학번,이름,전공1학과,국어,수학,영어,총점
*/

CREATE TABLE student_1
AS
SELECT s1.studno,NAME,major1, kor, math, eng, (kor+math+eng) total
FROM student s1, score s2
WHERE s1.studno = s2.studno
  AND grade = 1

SELECT * FROM student_1

/*
  alter : 테이블의 구조를 변경 명령어
*/
DESC depttest3
-- depttest3 테이블에 loc 컬럼 추가하기
ALTER TABLE depttest3 ADD loc VARCHAR(100)
DESC depttest3

-- depttest3 테이블에 상위부서코드를 저장할 컬럼 part 컬럼 추가하기
ALTER TABLE depttest3 add part INT(2)
DESC depttest3

-- depttest3 의 부서코드를 int(3)로 변경하기
ALTER TABLE depttest3 MODIFY deptno INT(3)
DESC depttest3
-- depttest3 의 상위부서코드를 int(3)로 변경하기
ALTER TABLE depttest3 MODIFY part INT(3)
DESC depttest3

-- depttest3의 loc 컬럼의 이름을 area 이름으로 변경하기
ALTER TABLE depttest3 CHANGE loc AREA VARCHAR(100)
DESC depttest3

-- depttest3의 part 컬럼을 제거하기
ALTER TABLE depttest3 DROP part
DESC depttest3

/*
 컬럼 관련 테이블 구조 수정
  추가 : add [column] 컬럼명 자료형
  크기변경 : modify [column] 컬러명 변경후크기
  이름변경 : change [column] 기존컬럼명 변경컬럼명 변경후자료형
         오라클 : rename 
   제거 : drop 컬럼명      
*/
/*
  제약조건(constraint)의 변경
*/
-- depttest3 테이블의 deptno 컬럼을 기본키로 설정하기
ALTER TABLE depttest3 ADD constraint PRIMARY KEY(deptno)
DESC depttest3
-- depttest3 테이블의 기본키로 제거하기
ALTER TABLE depttest3 DROP CONSTRAINT PRIMARY KEY
DESC depttest3

-- 외래키 : foreign key 
DESC professor
-- professor 테이블의 deptno 컬럼이  major 테이블의 code 컬럼을 참조하도록
-- 외래키 설정하기
ALTER TABLE professor ADD CONSTRAINT FOREIGN KEY (deptno)
REFERENCES major(CODE)
DESC professor

DESC professor_101

/*
  문제 1
  professor_101 테이블의 no 컬럼을 기본키로 설정하기
*/
DESC professor_101
SELECT * FROM professor_101
ALTER TABLE professor_101 ADD CONSTRAINT PRIMARY KEY(no)
/*
  문제 2
  student 테이블의 major1, major2 컬럼을 major 테이블의 code 값을 참조하도록
  외래키로 설정하기
*/
ALTER TABLE student ADD CONSTRAINT foreign KEY (major1) REFERENCES major (CODE)
ALTER TABLE student ADD CONSTRAINT foreign KEY (major2) REFERENCES major (CODE)

-- 등록된 제약조건을 조회하기
USE information_schema -- information_schema 선택
SELECT * FROM information_schema.table_constraints
WHERE TABLE_NAME = 'student'
USE cjdb
-- student 테이블의 major1,major2 등록된 외래키 제거하기
-- 외래키의 이름이 숫자인 경우 백틱을 사용함
-- 객체의 이름은 백틱을 사용함
ALTER TABLE student DROP foreign KEY `1`
ALTER TABLE student DROP foreign KEY `2`

SELECT * FROM information_schema.table_constraints
WHERE TABLE_NAME = 'student'
/*
   테이블을 제거하기
*/
DROP TABLE test5
DESC test5
-- v_emp 뷰를 제거하기
DROP VIEW v_emp
DESC v_emp

/*
  truncate : 테이블을 데이터를 분리
   dml delete와 비교
   
   truncate : 테이블의 데이터를 모두 제거
             DDL 이므로 transaction 처리가 안됨
             대용량 데이터 삭제시 속도가 빠르다.
             
   delete : 테이블의 데이터를 제거 명령어
             DML 이므로 transaction 처리가 가능함
             where 조건문으로 레코드 선택 가능
             
   transaction 이란
	  - 업무단위. All or Nothing
	    계좌이체 :
		    출금계좌에 거래내역 추가
		    출금계좌에 잔액 수정    
		    BS 변경                 
		    입금계좌에 거래내역 추가
		    입금계좌에 잔액 수정
		    BS 변경
		    ...
	  - commit(실행완성), rollback(실행취소)
*/
SELECT * FROM professor_101
TRUNCATE TABLE professor_101
SELECT * FROM professor_101

SELECT @autocommit
SHOW VARIABLES LIKE 'autocommit' -- on : 자동으로 commit
                             -- off : 사용자가 commit,rollback 실행
-- autocommit 환경을 off 상태로 변경
SET autocommit = FALSE
SHOW VARIABLES LIKE 'autocommit'
SELECT * FROM depttest1
DELETE FROM depttest1 -- 모든 레코드를 삭제
SELECT * FROM depttest1
ROLLBACK -- 실행 취소
SELECT * FROM depttest1

TRUNCATE TABLE depttest1
SELECT * FROM depttest1
ROLLBACK
SELECT * FROM depttest1