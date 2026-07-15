/*
  Join : 2개 이상의 테이블을 연결하여 조회하기
  
  cross join : 조인컬럼이 없이 2개의 테이블을 연결하여 조회함
           레코드의 갯수가 많아짐
*/
SELECT * FROM emp
SELECT * FROM dept
-- cross join 하기
SELECT * FROM emp, dept  -- mariadb 방식
SELECT * FROM emp CROSS join dept -- ansi 방식

/*
  등가조인 : Equi join
       join 컬럼의 조건인 = 인 join을 의미함.
       가장 많이 사용되는 join 방식
*/
-- 학생테이블의 모든 정보 조회하기
SELECT * FROM student
-- 학과테이블(major)의 모든 정보 조회하기
SELECT * FROM major

-- 학생이름,전공학과번호,전공학과명 출력하기
-- maridb 방식
SELECT s.NAME,major1,m.code,m.NAME
FROM student s, major m
WHERE s.major1 = m.code

-- ansi 방식
SELECT s.NAME,major1,m.code,m.NAME
FROM student s join major m
on s.major1 = m.code

-- 문제
-- 학생의 이름, 지도교수번호, 지도교수이름 출력하기
SELECT s.name 학생이름, s.profno 교수번호,
       p.name 지도교수이름
FROM student s, professor p
WHERE s.profno = p.no

SELECT s.name 학생이름, s.profno 교수번호,
       p.name 지도교수이름
FROM student s join professor p
on s.profno = p.no

-- 1학년 학생의 학번,이름,국어,영어,수학,총점을 출력하기
-- mariadb 방식
SELECT s1.studno, s1.name, s2.kor,s2.eng,s2.math,
       (s2.kor + s2.eng + s2.math) 총점
FROM student s1, score s2
WHERE s1.studno = s2.studno
  AND s1.grade = 1
-- ansi 방식
SELECT s1.studno, s1.name, s2.kor,s2.eng,s2.math,
       (s2.kor + s2.eng + s2.math) 총점
FROM student s1 join score s2
on s1.studno = s2.studno
where s1.grade = 1

-- 2개테이블에 같은이름의 컬럼은 반드시 
-- 테이블이름(테이블 별명)을 붙여야함
-- 2개 테이블 중 유일한 컬럼명은 테이블이름 생략 가능
-- 테이블의 이름(별명)을 붙이는것이 가독성에 좋다(권장사항)
SELECT s1.studno, name, kor,eng,math,
       (kor + eng + math) 총점
FROM student s1 join score s2
on s1.studno = s2.studno
where grade = 1

-- 학생의 이름,학과이름,지도교수이름 출력하기
-- mariadb 방식
SELECT s.name 학생이름, m.name 학과이름, p.name 지도교수이름
FROM student s, major m, professor p
WHERE s.major1 = m.code
 AND s.profno = p.no 

-- ansi 방식
SELECT s.name 학생이름, m.name 학과이름, p.name 지도교수이름
FROM student s join major m
ON s.major1 = m.code join professor p
on s.profno = p.no 

SELECT * FROM p_grade
SELECT distinct job FROM emp
-- emp 테이블과 p_grade 테이블에서 
-- 사원이름(ename),직급(job),현재연봉,
-- 해당직급의연봉하한(s_pay), 연봉상한(e_pay) 출력하기
-- 연봉 : (급여*12 + 보너스) * 10000
-- 보너스가 없으면 0으로 처리하기
-- mariadb 방식
SELECT e.ename, e.job, 
   (e.salary*12+ifnull(bonus,0)) * 10000 현재연봉,
    p.s_pay, p.e_pay
FROM emp e, p_grade p
WHERE e.job = p.position
-- ansi 방식
SELECT e.ename, e.job, 
   (e.salary*12+ifnull(bonus,0)) * 10000 현재연봉,
    p.s_pay, p.e_pay
FROM emp e join p_grade p
on e.job = p.position

/*
  문제 1
  장성태 학생의 학번,이름,전공1학과코드, 학과명, 학과위치,
  국어,영어,수학점수 출력하기
  student, major, score
*/
SELECT s1.studno , s1.name, s1.major1, m.name, m.build, 
       s2.kor, s2.eng,s2.math
FROM student s1, major m, score s2
WHERE s1.major1 = m.code
 AND s1.studno = s2.studno
 AND s1.name = "장성태"

SELECT s1.studno , s1.name, s1.major1, m.name, m.build, 
       s2.kor, s2.eng,s2.math
FROM student s1 join major m
ON s1.major1 = m.code join score s2
ON s1.studno = s2.studno
WHERE s1.name = "장성태"

/*
  문제 2
  몸무게가 80키로 이상인 학생의 학번,이름,체중,학과명,학과위치
  출력하기
  student, major
*/
SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code
  AND s.weight >= 80

SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s join major m
on s.major1 = m.code
where s.weight >= 80

-- inner join : join 컬럼의 조건에 맞는 데이터만 조회됨.
--              기본 join 방식임 
-- outer join : join 컬럼의 조건에 맞지 않는 데이터도 조회가능
  
