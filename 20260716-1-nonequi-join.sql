/*
   비등가조인 : non equi join
      조인컬럼의 조건 =가 아닌 경우. 범위값으로 조인함.
      
   inner join : 조건이 맞는 경우만 조회 가능함.
	outer join : 조건이 맞지 않는 경우도 조회가 가능함   
*/
-- 고객테이블 : guest
-- 상품테이블 : pointitem
SELECT * FROM guest -- no : 고객번호, name:고객이름, point:포인트점수
SELECT * FROM pointitem -- no:상품번호, name:상품번호, spoint,epoint:포인트범위

-- 고객이 포인트로 받을 수 있는 상품을 조회하기
-- 고객명,고객포인트, 상품명,포인트범위를 출력하기
-- mariadb 방식
SELECT g.name,g.point, p.name,p.spoint,p.epoint
FROM guest g, pointitem p
WHERE g.point BETWEEN p.spoint AND p.epoint
--ansi 방식
SELECT g.name,g.point, p.name,p.spoint,p.epoint
FROM guest g join pointitem p
on g.point BETWEEN p.spoint AND p.epoint

-- 낮은 포인트의 상품을 선택할 수 있다고 할때
-- 개인별로 가져갈 수 있는 상품의 갯수 출력하기

-- 그룹화하기 전의 데이터 조회
SELECT g.name,g.point, p.name,p.spoint,p.epoint
FROM guest g, pointitem p
WHERE g.point > p.spoint
ORDER BY g.name
-- mariadb 방식
SELECT g.name,COUNT(*)
FROM guest g, pointitem p
WHERE g.point > p.spoint
GROUP BY g.name
ORDER BY COUNT(*) desc
-- ansi 방식
SELECT g.name,COUNT(*)
FROM guest g join pointitem p
on g.point > p.spoint
GROUP BY g.name
ORDER BY COUNT(*) DESC

/*
문제
 낮은포인트의 상품을 선택할 수 있다고 가정할때 외장하드를 선택할 수 있는 고객의
 고객명, 고객포인트, 상품명, 시작포인트,종료포인트 출력하기
*/ 
SELECT g.name 고객명,g.point 고객포인트, p.name 상품명, p.spoint,p.epoint
FROM guest g, pointitem p
WHERE g.point >= p.spoint
 AND p.name = "외장하드"

SELECT g.name 고객명,g.point 고객포인트, p.name 상품명, p.spoint,p.epoint
FROM guest g join pointitem p
on g.point >= p.spoint
where  p.name = "외장하드"

/*
문제
 낮은포인트의 상품을 선택할 수 있다고 가정할때
 상품을 2개이상 선택할 수 있는 고객 이름과 상품갯수를 출력하기
*/ 
SELECT g.name,COUNT(*)
FROM guest g , pointitem p
where g.point >= p.spoint
GROUP BY g.name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) desc

SELECT g.name,COUNT(*)
FROM guest g join pointitem p
on g.point >= p.spoint
GROUP BY g.name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC
-- student : 학생테이블
-- score : 학생점수테이블
-- scorebase : 학점테이블
SELECT * FROM scorebase

-- 학생의 학번,이름,국어,수학,영어,총점,평균,학점 출력하기
-- 학번,이름 : student
-- 국어,수학,영어,총점,평균 :score
-- 학점 : scorebase
SELECT s1.studno, s1.name, s2.kor, s2.math, s2.eng, 
       (kor+math+eng) 총점, (kor+math+eng)/3 평균, 
       s3.grade 학점
FROM student s1, score s2, scorebase s3
WHERE s1.studno = s2.studno
  AND round((kor+math+eng)/3) BETWEEN s3.min_point AND s3.max_point
ORDER BY 학점  

SELECT s1.studno, s1.name, s2.kor, s2.math, s2.eng, 
       (kor+math+eng) 총점, (kor+math+eng)/3 평균, 
       s3.grade 학점
FROM student s1 JOIN  score s2
ON s1.studno = s2.studno join scorebase s3
on round((kor+math+eng)/3) BETWEEN s3.min_point AND s3.max_point
ORDER BY 학점  
/*
   각 학점별 인원수를 출력하기
*/
SELECT s3.grade 학점, COUNT(*)
FROM score s2, scorebase s3
WHERE round((kor+math+eng)/3) BETWEEN s3.min_point AND s3.max_point
GROUP BY s3.grade
ORDER BY 학점  

SELECT s3.grade 학점, COUNT(*)
FROM score s2 join scorebase s3
on round((kor+math+eng)/3) BETWEEN s3.min_point AND s3.max_point
GROUP BY s3.grade
ORDER BY 학점  

/*
  self join : 같은 테이블을 join함.
              테이블내의 2개의 컬럼을 조인컬럼으로 사용함
              반드시 테이블의 별명을 설정해야 함
              반드시 모든 컬럼 조회시 테이블의 별명을 설정해야함
*/
-- 사원테이블(emp)에서 사원이름,사원직급,상사이름,상사직급출력하기
SELECT * FROM emp

SELECT e1.ename 사원이름, e1.job 사원직급 , e2.ename 상사이름 , e2.job 상사직급
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno

SELECT e1.ename 사원이름, e1.job 사원직급 , e2.ename 상사이름 , e2.job 상사직급
FROM emp e1 join emp e2
on e1.mgr = e2.empno

/*
  e1                      e2 
  empno  ename       mgr  empno  ename       mgr
  1000   이승엽     null
  1001   김유태     1000  1000   이승엽     null
  1002   주승재     1000  1000   이승엽     null
  1003   송승환     1000  1000   이승엽     null
  1004   주재희     1002  1002   주승재     1000
  
  e2
  empno  ename       mgr
  1000   이승엽     null
  1001   김유태     1000
  1002   주승재     1000
  1003   송승환     1000
  1004   주재희     1002
*/

SELECT * FROM major  -- code : 학과코드 name:학과명 part : 상위대학/학부

-- 문제
-- major 테이블에서 학과코드,학과명, 상위학과코드,상위학과명 출력하기
/*
  m1                                   m2
  code    name                part     code    name                part
   10     공과대학            null
   100    컴퓨터정보학부      10        10     공과대학            null
   101    컴퓨터공학과        100      100    컴퓨터정보학부      10
   102    멀티미디어공학과    100      100    컴퓨터정보학부      10
   200    전기전자학부        10        10     공과대학            null
   201    전자공학과          200      200    전기전자학부        10

  m2
  code    name                part 
   10     공과대학            null
   100    컴퓨터정보학부      10
   101    컴퓨터공학과        100
   102    멀티미디어공학과    100
   200    전기전자학부        10
   201    전자공학과          200
 */
 SELECT m1.code,m1.name, m2.code, m2.name 
 FROM major m1, major m2
 WHERE m1.part = m2.code

 SELECT m1.code,m1.name, m2.code, m2.name 
 FROM major m1 join major m2
 on m1.part = m2.code

SELECT * FROM professor
/*
   교수번호,이름,입사일,입사일이 빠른사람의 이름 조회하기
*/

SELECT p1.no, p1.name, p1.hiredate, p2.name,p2.hiredate
FROM professor p1, professor p2
WHERE p1.hiredate > p2.hiredate
ORDER BY p1.name
/*
  문제
  교수번호,이름,입사일,입사일이 같은사람의 이름 조회하기
*/
SELECT p1.no, p1.name, p1.hiredate, p2.name,p2.hiredate
FROM professor p1, professor p2
WHERE p1.hiredate = p2.hiredate
  AND p1.no != p2.no
ORDER BY p1.hiredate
/*
 문제
 교수번호,이름, 학과명, 입사일이 빠른 사람의 인원수 조회하기
*/
SELECT p1.no, p1.name, m.name , COUNT(*) 인원수
FROM professor p1, professor p2, major m
WHERE p1.hiredate > p2.hiredate
  AND p1.deptno = m.code
GROUP by p1.name
ORDER BY 인원수

--  교수번호,이름, 학과명, 입사일이 같은 사람의 인원수 조회하기
SELECT p1.no, p1.name, m.name , COUNT(*) 인원수
FROM professor p1, professor p2, major m
WHERE p1.hiredate = p2.hiredate
  AND p1.deptno = m.code
GROUP by p1.name
ORDER BY 인원수

/*
  inner join : 조인컬럼의 조건에 맞는 레코드만 조회
    등가조인(equi join) : 조건이 =인 경우
    비등가조인(not equi join) : 조건이 범위인 경우
    self 조인 (self join) : 같은 테이블을 join하는 경우

   outer join : 조인컬럼의 조건이 맞지 않아도 한쪽 또는 양쪽의 레코드를 조회
     left outer join : 왼쪽 테이블의 모든 레코드 조회
     right outer join : 오른쪽 테이블의 모든 레코드 조회
     full outer join : 양쪽 테이블의 모든 레코드 조회. mariadb에서 사용안됨. 
*/
-- 오라클 학생의 이름과 지도교수이름을 출력하기
SELECT s.name, p.name
FROM student s, professor p
WHERE s.profno = p.no(+) -- 오라클인 경우 left outer join 방식 


-- 학생의 이름과 지도교수이름을 출력하기
SELECT s.name, p.name
FROM student s, professor p
WHERE s.profno = p.no  -- 지도교수가 없는 학생이 조회안됨

-- 학생의 이름과 지도교수이름을 출력하기. 단 지도교수가 없는 학생도 조회하기
SELECT s.name, p.name
FROM student s LEFT OUTER join professor p
on s.profno = p.no

-- 학생의 이름과 지도교수이름을 출력하기. 단 지도학생이 없는 교수도 조회하기
SELECT s.name, p.name
FROM student s right OUTER join professor p
on s.profno = p.no

-- 학생의 이름과 지도교수이름을 출력하기. 
-- 단 지도학생이 없는 교수 와, 지도교수가 없는 학생도 조회하기
SELECT s.name, p.name
FROM student s left OUTER join professor p
on s.profno = p.no
union
SELECT s.name, p.name
FROM student s right OUTER join professor p
on s.profno = p.no

-- 학생의 학번,이름,지도교수번호,지도교수이름 출력하기
-- 지도교수가 없는 학생도 조회되도록 하고, 지도교수없음으로 출력하기
SELECT s.studno, s.name, ifnull(s.profno,""), ifnull(p.name,"지도교수없음")
FROM student s LEFT OUTER join professor p
on s.profno = p.no

-- 학생의 학번,이름,지도교수번호,지도교수이름 출력하기
-- 지도교수가 없는 학생도 조회되도록 하고, 지도교수없음으로
-- 지도학생이 없는 교수도 조회되도록하고, 지도학생없음으로 출력하기

SELECT s.studno, s.name, ifnull(s.profno,""), ifnull(p.name,"지도교수없음")
FROM student s LEFT  join professor p
on s.profno = p.no
union
SELECT ifnull(s.studno,""), ifnull(s.name,"지도학생없음"), 
       ifnull(s.profno,""), p.name
FROM student s right  join professor p
on s.profno = p.no

