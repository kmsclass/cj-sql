/*
1. 전공테이블(major)에서 공과대학(deptno=10)에 소속된  학과이름을 출력하기
*/
SELECT code,NAME,part FROM major
WHERE part IN 
(SELECT m1.CODE FROM major m1, major m2 WHERE m1.part = m2.CODE
                and m2.name='공과대학')

SELECT m1.code,m1.NAME,m1.part 
FROM major m1,major m2, major m3
WHERE m1.part = m2.code
 AND m2.part = m3.code
 AND m3.name='공과대학'

/*
2. 공과대학에 소속된 모든 학생의 학번,이름, 학과번호, 학과명 출력하기
*/

SELECT s.studno,s.NAME,s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
 AND s.major1 IN 
 ( SELECT m1.code
FROM major m1,major m2, major m3
WHERE m1.part = m2.code
 AND m2.part = m3.code
 AND m3.name='공과대학'
)

SELECT s.studno,s.NAME,s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
 AND s.major1 IN 
(SELECT code FROM major
WHERE part IN 
(SELECT m1.CODE FROM major m1, major m2 WHERE m1.part = m2.CODE
                and m2.name='공과대학'))

/*
3. 자신의 학과 학생들의 평균 몸무게 보다 몸무게가 
   적은 학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
*/ 
SELECT studno,NAME, major1, weight
FROM student s1
WHERE weight < 
 (SELECT AVG(weight) FROM student s2 WHERE s2.major1 = s1.major1)


/*
4. 학번이 961115학생과 학년이 같고 키는  970111 학생보다  
   큰 학생의 이름, 학년, 키를 출력하기
*/
SELECT studno,NAME, grade, height
FROM student
WHERE grade = (SELECT grade FROM student WHERE studno=961115)
 AND height > (SELECT height FROM student where studno = 970111)

SELECT NAME,height FROM student WHERE grade = 3
/*
5. 4학년학생 중 키가 제일 작은 학생보다  키가 큰 학생의 학번,이름,키를 출력하기
*/
SELECT studno, NAME, height FROM student
WHERE height > (SELECT MIN(height) FROM student WHERE grade = 4)

SELECT studno, NAME, height FROM student
WHERE height >ANY (SELECT height FROM student WHERE grade = 4)

/*
6. 학생 중에서 생년월일이 가장 빠른 학생의  학번, 이름, 생년월일을 출력하기
*/
SELECT studno, NAME, birthday FROM student
WHERE birthday = (SELECT MIN(birthday) FROM student)

/*
7. 학년별  생년월일이 가장 빠른 학생의 학번, 이름, 생년월일,학과명을 출력하기
*/
SELECT s.studno,s.NAME,s.birthday, m.NAME 
FROM student s, major m
WHERE s.major1 = m.code
AND (s.grade,s.birthday) IN (SELECT grade , MIN(birthday) FROM student GROUP BY grade)
GROUP BY birthday desc

/*
8. 학과별 입사일 가장 오래된 교수의 교수번호,이름,입사일,학과명 조회하기
*/
SELECT p.no,p.name, p.hiredate,m.name FROM professor p, major m
WHERE p.deptno = m.code
AND (p.deptno,p.hiredate) IN (SELECT deptno, MIN(hiredate) FROM professor GROUP BY deptno)


/*
9. 학년별로 평균키가 가장 적은 학년의  학년과 평균키를 출력하기
*/
SELECT * FROM (SELECT grade, AVG(height) AVG FROM student GROUP BY grade) a
WHERE AVG = (SELECT MIN(AVG) FROM (SELECT grade, AVG(height) AVG FROM student GROUP BY grade) a)

SELECT grade, avg(height) FROM student GROUP BY grade
HAVING avg(height) <=ALL 
(SELECT avg(height) FROM student GROUP BY grade)

/*
10. 학생의 학번,이름,학년,키,몸무게,해당 학년의 최대키, 최대몸무게 조회하기
*/
SELECT s.studno,s.name,s.grade, s.height,s.weight,
 (SELECT MAX(height) FROM student s2 WHERE s.grade = s2.grade) 최대키,
 (SELECT MAX(weight) FROM student s2 WHERE s.grade = s2.grade) 최대몸무게
FROM student s

SELECT s.studno,s.name,s.grade, s.height,s.weight,
  a.height 최대키, a.weight 최대몸무게
FROM student s, 
 (SELECT grade, MAX(height) height ,MAX(weight) weight FROM student GROUP BY grade) a
WHERE s.grade = a.grade 


/*
11. 교수번호,이름,부서코드,부서명,자기부서의 평균급여, 평균보너스 조회하기
  보너스가 없으면 0으로 처리한다.
*/
SELECT p.no,p.name, p.deptno,m.name, 
  (SELECT AVG(salary) FROM professor p2 WHERE p2.deptno = p.deptno) 평균급여,
  (SELECT AVG(IFNULL(bonus,0)) FROM professor p2 WHERE p2.deptno = p.deptno) 평균보너스
FROM professor p , major m
where p.deptno = m.code 

SELECT p.no,p.name, p.deptno,
  (SELECT NAME FROM major m WHERE m.code = p.deptno) 부서명,
  (SELECT AVG(salary) FROM professor p2 WHERE p2.deptno = p.deptno) 평균급여,
  (SELECT AVG(IFNULL(bonus,0)) FROM professor p2 WHERE p2.deptno = p.deptno) 평균보너스
FROM professor p

SELECT p.no,p.name, p.deptno,m.name 부서명, a.salary 평균급여, a.bonus 평균보너스
FROM professor p , major m, 
  (SELECT deptno, AVG(salary) salary , AVG(IFNULL(bonus,0)) bonus 
   FROM professor GROUP BY deptno) a
where p.deptno = m.code 
  AND p.deptno = a.deptno


/*
12. 학년별 총점이 가장 큰 학생의 학번, 이름,학과코드,학과명,총점을 출력하기
*/
SELECT s1.studno, s1.name ,s1.major1, kor+math+eng 총점, m.name
from student s1, score s2, major m
WHERE s1.studno = s2.studno
  AND s1.major1 = m.code
  AND (grade,kor+math+eng) IN 
  (SELECT grade, max(kor+math+eng) FROM student s1, score s2 
   WHERE s1.studno = s2.studno GROUP BY s1.grade)
   
/*
13. 학생 테이블에서 1학년 학생들만 student1 테이블로 생성하기
 필요컬럼 : 학번,이름,전공1학과코드, 학과명
*/
CREATE TABLE student1
AS
SELECT s.studno,s.name,s.major1,m.name mname
FROM student s, major m
WHERE s.major1 = m.code
 AND s.grade = 1

SELECT * FROM student1
/*
 14. test11 테이블 생성하기
 컬럼 : seq : 숫자,기본키,자동증가
        name : 문자형 20문자
        birthday : 날짜만

*/
CREATE TABLE test11 (
  seq INT PRIMARY KEY AUTO_INCREMENT,
  NAME VARCHAR(20),
  birthday date
)
DESC test11
/*
15. 테이블 test12를 생성하기. 
    컬럼은 정수형인 no 가 기본키로 
    name 문자형 20자리
    tel 문자형 20 자리
   addr 문자형 100자리로 기본값을 서울시 금천구로 설정하기
*/
​
CREATE TABLE  test12 (
   NO INT PRIMARY KEY,
   NAME VARCHAR(20),
   tel VARCHAR(20),
   addr VARCHAR(100) DEFAULT '서울시 금천구'
)
DESC test12
/*
16. 교수 테이블로 부터 102 학과 교수들의 
 번호, 이름, 학과코드, 급여, 보너스, 직급만을 컬럼으로
 가지는 professor_102 테이블을 생성하기
*/

CREATE TABLE professor_102 
AS 
SELECT NO,NAME,deptno,salary, bonus, POSITION FROM professor
WHERE deptno = 102
DESC professor_102
/*
22.  2학년 학생의 학번,이름, 국어,영어,수학 값을 가지는 score2 테이블 생성하기
*/

CREATE TABLE score2 
AS
SELECT s1.studno, s1.name,s2.kor,s2.eng,s2.math 
FROM student s1, score s2
WHERE s1.studno = s2.studno
  AND s1.grade = 2
  
SELECT * FROM score2  
/*
17.교수번호,교수이름,직급, 학과코드,학과명 컬럼을 가진 테이블 professor_201을 생성하여
     201학과에 속한 교수들의 정보를 저장하기
*/

CREATE TABLE professor_201 
AS
SELECT p.NO,p.NAME,p.POSITION,p.deptno,m.name mname
FROM professor p, major m
WHERE p.deptno = m.code
  AND p.deptno = 201

SELECT * FROM professor_201
/*

create table address (
   id varchar(10),
   addr varchar(100),
   email varchar(100)
);
desc address

18. 주소록테이블에 날짜 타입을 가지는 birth 컬럼을 추가하라
*/
ALTER TABLE address ADD birth DATE
DESC address
/*
19. 주소록 테이블에 문자 타입을 가지는 comments컬럼을 추가하라
단 기본값은 'no Comment'로 설정하라
*/
ALTER TABLE address ADD comments VARCHAR(100) DEFAULT 'no Comment'
DESC address
/*
20. 주소록 테이블에서 comments컬럼을 삭제하라
*/
ALTER TABLE address DROP comments
DESC address

/*
create table member(
  USERID varchar(10),
  USERNAME varchar(10),
  PASSWD varchar(10),
  PHONE varchar(13),
  ADDRESS varchar(20),
  REGDATE datetime);

desc member
21. 회원테이블에 email 컬럼을 추가하라 단 email 컬럼의 타입은 varchar(50) 이다
*/
ALTER TABLE member ADD email VARCHAR(50)
DESC member
/*
22. 회원 테이블에 국적을 나타내는 country 칼럼을 추가하고 기본값은 'Korea'로 지정하여라
*/
ALTER TABLE member ADD country VARCHAR(30) DEFAULT 'Korea'
DESC member
/*
23. 회원 테이블에서 email 칼럼을 삭제하여라
*/
ALTER TABLE member DROP email
DESC member

/*
24. 회원 테이블의 address 칼럼의 데이터 크기를 30으로 증가시켜라
*/
ALTER TABLE member MODIFY COLUMN address  VARCHAR(30)
ALTER TABLE member MODIFY address  VARCHAR(30)
DESC member
/*
25. member 테이블의 userid를 기본키로 등록하기
*/
ALTER TABLE member ADD CONSTRAINT PRIMARY KEY (userid)
DESC member
/*
26. member 테이블의 userid에 등록된 회원만 address 테이블의  
    id 컬럼에 등록되도록 제약 조건을 등록하기
*/
ALTER TABLE address ADD CONSTRAINT FOREIGN KEY (id) REFERENCES member(userid)
DESC address
/*
27. member테이블과 address 에 등록된 제약조건을 조회하기
*/​
USE information_schema
SELECT * FROM table_constraints
WHERE TABLE_NAME IN ('member','address')

