/*
   insert : 데이터 추가
   insert into 테이블명 (컬럼목록) values(값목록)
   insert into 테이블명 (컬럼목록) values
	   (값목록),(값목록),(값목록) ...
	insert into 테이블명 select 구문  
	
	update : 데이터 변경
	 update 테이블명 set 컬럼1=값1, 컬럼2=값2,...
	 where 조건문  
*/
-- autocommit 상태 확인
SHOW VARIABLES LIKE 'autocommit%' 
SET autocommit=FALSE

-- 보너스가 없는 시간강사의 보너스를 조교수의 평균 보너스의 50%로변경하기
SELECT AVG(ifnull(bonus,0)) FROM professor WHERE POSITION='조교수'
SELECT bonus FROM professor WHERE POSITION="시간강사"
UPDATE professor SET bonus=50 WHERE POSITION="시간강사"
ROLLBACK

-- subquery 이용
UPDATE professor 
 SET bonus = (SELECT AVG(bonus) * 0.5 FROM professor WHERE POSITION="조교수")
 WHERE POSITION='시간강사'
 
SELECT bonus FROM professor WHERE POSITION="시간강사"
rollback
-- 문제
-- 지도교수가 없는 학생의 지도교수를 이용학생의 지도교수로 변경하기
SELECT * FROM student WHERE profno IS NULL
SELECT * FROM student WHERE grade = 1
SELECT profno FROM student WHERE NAME='이용'

UPDATE student SET profno = (SELECT profno FROM student WHERE NAME='이용')
WHERE profno IS NULL


-- 교수 중 김옥남교수와 같은 직급의 교수 급여를 101번학과의 평균급여로 변경하기
SELECT * FROM professor WHERE NAME="김옥남"
SELECT * FROM professor WHERE POSITION='시간강사'
SELECT AVG(salary) FROM professor WHERE deptno=101

UPDATE professor
 SET salary=(SELECT AVG(salary) FROM professor WHERE deptno=101)
 WHERE POSITION = '시간강사'

DESC professor
ROLLBACK

UPDATE professor
 SET salary=(SELECT AVG(salary) FROM professor WHERE deptno=101)
 WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME="김옥남")

SELECT * FROM professor WHERE POSITION='시간강사'

/*
  delete : 레코드 삭제
  
  delete from 테이블명
  where 조건문 => 조건문의 결과가 참인 경우 레코드 삭제 
*/
-- depetest1 테이블의 모든 데이터를 삭제하기
DELETE FROM depttest1
SELECT * FROM depttest1
ROLLBACK

-- depttest2 테이블에서 기술부 영업부 데이터를 삭제하기
SELECT * FROM depttest2
DELETE FROM depttest2 
WHERE dname IN ("기술부","영업부")
ROLLBACK

-- 문제
-- depttest2 테이블에서 부서명에 '기' 문자가 있는 부서 정보를 삭제하기
SELECT * FROM depttest2 WHERE dname LIKE '%기%'
delete FROM depttest2 WHERE dname LIKE '%기%'
ROLLBACK

-- 학생의 학번,이름,학년, 키, 몸무게, 본인 학년의 평균키, 본인 학년의 평균몸무게
-- 출력하기

-- SELECT 구문 분석하기
-- explain : 실행방법을 미리 조회하기
explain SELECT studno,NAME, grade,height,weight,
(SELECT AVG(height) FROM student s2 WHERE s2.grade = s1.grade) 평균키,
(SELECT AVG(weight) FROM student s2 WHERE s2.grade = s1.grade) 평균몸무게
FROM student s1

-- type : all => 전체 레코드를 순회함. 성능이 안좋음

explain SELECT studno,NAME,s.grade, height,weight, avg_height,avg_weight
FROM student s,
  (SELECT grade, AVG(height) avg_height, AVG(weight) avg_weight 
    FROM student GROUP BY grade ) a
WHERE s.grade = a.grade    

/*
  index 테이블
   테이블을 조회하기 위한 색인테이블
   index 테이블에 설정된 컬럼명으로 조회시 성능 향상이 가능함
   index 테이블에 설정된 컬럼이 변경(추가,수정,삭제)시 성능이 안좋을 수 있음
   
   create index 인덱스테이블명
*/

-- student 테이블에 grade컬럼으로 인덱스테이블 생성하기
CREATE INDEX idx_stu_grade ON student(grade) -- 중복가능인덱스

explain SELECT studno,NAME, grade,height,weight,
(SELECT AVG(height) FROM student s2 WHERE s2.grade = s1.grade) 평균키,
(SELECT AVG(weight) FROM student s2 WHERE s2.grade = s1.grade) 평균몸무게
FROM student s1

-- student 테이블에 id컬럼으로 unique 하게 인덱스테이블 생성하기
CREATE unique INDEX idx_stu_id ON student(id)

-- index 제거하기
DROP INDEX idx_stu_id ON student

-- 사용자 생성하기
CREATE USER hkd
-- 비밀번호 설정
SET PASSWORD FOR 'hkd'=PASSWORD("1234")

-- 데이터베이스 생성 : 권한 필요
CREATE DATABASE testdb

CREATE TABLE test1(id INT)

-- 권한주기
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE, ALTER, DROP
ON testdb.* TO 'hkd'@'%' 

-- 권한회수
REVOKE ALL PRIVILEGES ON testdb.* FROM hkd@'%'