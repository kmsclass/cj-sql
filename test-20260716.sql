-- 1. 지도 교수가 지도하는 학생의 인원수를 출력하기.
--    지도 학생이 없는 교수 목록도 조회
-- OUTER join
SELECT p.name, COUNT(s.name) -- s.name 컬럼의 값이 null인 경우 포함안됨
FROM professor p LEFT join student s
on p.`no` = s.profno
GROUP by p.name

-- inner join : 지도 학생이 없는 교수 조회 안됨
SELECT p.name, COUNT(s.name)
FROM professor p join student s
on p.`no` = s.profno
GROUP by p.name

-- 2. 지도 교수가 지도하는  학생의 인원수가 2명이상인 지도교수 이름를 
-- 출력하기.
SELECT p.no,p.name, COUNT(*)
FROM professor p, student s
WHERE p.no = s.profno
GROUP BY p.no
HAVING COUNT(*) >= 2

SELECT p.no,p.name, COUNT(*)
FROM professor p join student s
on p.no = s.profno
GROUP BY p.no
HAVING COUNT(*) >= 2


-- 3. 지도 교수가 지도하는  학생의 인원수가 2명이상인 
-- 지도교수 번호,이름,학과코드,학과명 출력하기.

SELECT p.no,p.name,p.deptno,m.name ,COUNT(*)
FROM professor p, student s, major m
WHERE p.no = s.profno
  AND p.deptno = m.code
GROUP BY p.no
HAVING COUNT(*) >= 2

SELECT p.no,p.name,p.deptno,m.name ,COUNT(*)
FROM professor p join student s
on p.no = s.profno join major m
on p.deptno = m.code
GROUP BY p.no
HAVING COUNT(*) >= 2


-- 4. 학생의 이름과 지도교수 이름 조회하기. 
--    지도 교수가 없는 학생과 지도 학생이  없는 교수도 조회하기
--    단 지도교수가 없는 학생의 지도교수는  '0000' 으로 출력하고
--    지도 학생이 없는 교수의 지도학생은 '****' 로 출력하기

select s.name 학생이름 ,ifnull(p.name,'0000') 교수이름 
from student s  left join professor p
on s.profno = p.no
union
select ifnull(s.name,'****'),p.name 
from student s  right join professor p
on s.profno = p.no


-- 5. 지도 교수가 지도하는 학생의 인원수를 출력하기.
--    단 지도학생이 없는 교수의 인원수 0으로 출력하기
--    지도교수번호, 지도교수이름, 지도학생인원수를 출력하기

select p.no, p.name, count(s.profno)
from student s right join professor p
on s.profno = p.no
group by p.name

select p.no, p.name, count(s.name)
from student s right join professor p
on s.profno = p.no
group by p.name


-- 6.교수 중 지도학생이 없는 교수의 번호,이름, 학과번호, 학과명 출력하기
select p.no, p.name,p.deptno, m.name
from student s right join professor p
on s.profno = p.no JOIN major m
ON p.deptno = m.code
WHERE s.profno IS null

select p.no, p.name,p.deptno, m.name, count(s.profno)
from student s right join professor p
on s.profno = p.no JOIN major m
ON p.deptno = m.code
group by p.no
HAVING count(s.profno) = 0

-- 7. emp 테이블에서 사원번호, 사원명,직급,  상사이름, 상사직급 출력하기
--   모든 사원이 출력되어야 한다.
--    상사가 없는 사원은 상사이름을 '상사없음'으로  출력하기
select e1.empno, e1.ename, e1.job,
     ifnull(e2.ename,'상사없음'), ifnull(e2.job,' ')
from emp e1 left join emp e2
on e1.mgr = e2.empno

-- 8.교수 테이블에서 송승환교수보다 나중에 입사한 
-- 교수의 이름, 입사일,학과코드,학과명을 출력하기 
SELECT p.name,p.hiredate, p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
AND hiredate > (SELECT hiredate FROM professor WHERE NAME='송승환')

-- 9.학생 중 2학년 학생의 최대 체중보다 
-- 체중이 큰 1학년 학생의 이름, 몸무게, 키를 출력하기
SELECT NAME,weight, height FROM student
WHERE grade = 1
  AND weight > (SELECT MAX(weight) FROM student WHERE grade = 2)

-- 10.학생테이블에서 전공학과가 101번인 학과의 평균몸무게보다
--   몸무게가 많은 학생들의 이름과 몸무게, 학과명 출력
SELECT s.NAME, s.weight, m.name
FROM student s, major m
WHERE s.major1 = m.code
 AND s.weight > 
 (SELECT AVG(weight) FROM student WHERE major1 = 101)

-- 11.이상미 교수와 같은 입사일에 입사한 교수 중 이영택교수 보다 
--   월급을 적게받는 교수의 이름, 급여, 입사일 출력하기
SELECT NAME, salary, hiredate
FROM professor
WHERE hiredate = (SELECT hiredate FROM professor WHERE NAME = '이상미')
  AND salary < (SELECT salary FROM professor WHERE NAME = '이영택')

-- 12. 101번 학과 학생들의 평균 몸무게 보다  
--   몸무게가 적은 학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
SELECT studno,NAME, major1, weight
FROM student 
WHERE weight < (SELECT AVG(weight) FROM student WHERE major1 = 101)

-- 13. score 테이블과, scorebase 테이블을 이용하여 학점별 인원수,학점별
-- 평균값의 평균  조회하기
SELECT s2.grade,COUNT(*),AVG((s1.kor+s1.math+s1.eng)/3) 
FROM score s1, scorebase s2
WHERE round((s1.kor+s1.math+s1.eng)/3) BETWEEN s2.min_point AND s2.max_point
GROUP BY s2.grade


-- 14. 고객의 포인트로 상품을 받을 수 있을때 필요한 상품의 갯수를 조회하기
SELECT p.`name` , COUNT(*)
FROM guest g, pointitem p
WHERE g.point BETWEEN p.spoint AND p.epoint
GROUP BY p.name

-- 15. 교수번호,이름,입사일, 입사일이 늦은 사람의 인원수 조회하기
--  입사일이 늦은 순으로 정렬하여 출력하기
-- inner join 입사일이 가장 늦은 사람은 조회 안됨
SELECT p1.no,p1.name,p1.hiredate,COUNT(p2.no)
FROM professor p1  JOIN professor p2
ON p1.hiredate < p2.hiredate
GROUP BY p1.no
ORDER BY p1.hiredate desc

SELECT p1.no,p1.name,p1.hiredate,COUNT(p2.no)
FROM professor p1 left JOIN professor p2
ON p1.hiredate < p2.hiredate
GROUP BY p1.no
ORDER BY p1.hiredate desc


-- 16.  major 테이블에서 학과코드, 학과명, 상위학과코드, 상위학과명 조회하기
-- 모든 학과가 조회됨. => 상위학과가 없는 학과도 조회됨.
SELECT m1.code, m1.name, m2.code,m2.name
FROM major m1 LEFT join major m2 
ON m1.part = m2.code

