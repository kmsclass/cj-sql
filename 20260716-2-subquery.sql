/*
 subquery : sql 구문내부에 select 구문이 존재함.
            주로 where 조건문에서 많이 사용됨.
            
   subquery 가능 영역
	  - where 조건문 : subquery
	  - from  : inline view (인라인 뷰)
	  - 컬럼영역 : 스칼라 subquery
	  - having : subquery    
	  
	종류
	- 단일행 subqury : 서브쿼리의 결과가 한개 행인 경우
	        사용연산자 : 관계연산자(=, >, <, <=,....)
	- 다중행 subqury : 서브쿼리의 결과가 여러개 행인 경우
	        사용연산자 : in, >all, <any
*/
-- emp 테이블에서 김민용 직원보다 많은 급여를 받는 직원의 정보 출력하기
-- 1. 김민용 직원의 급여
SELECT salary FROM emp WHERE ename='김민용'
-- 2. 550보다 많은 급여를 받는 직원의 정보
SELECT * FROM emp WHERE salary > 550
-- 1,2 동시에 처리
SELECT * FROM emp 
WHERE salary > (SELECT salary FROM emp WHERE ename='김민용')

-- 김종연학생보다 윗학년의 이름,학년,전공1학과번호,학과명 출력하기
SELECT s.name, s.grade, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
 AND grade > (SELECT grade FROM student WHERE NAME="김종연")
 
/*
  문제
  emp 테이블에서 사원직급의 평균 급여보다 적게 받는 직원의 사원번호,이름,직급,급여
  출력하기
*/ 
SELECT empno, ename, job,salary
FROM emp
WHERE salary < (SELECT AVG(salary) FROM emp WHERE job="사원")
/*
  문제
   교수테이블에서 이상미 교수와 같이 입사한 교수의 이름,급여,학과코드,학과명을
   출력하기
*/ 
SELECT p.name, p.salary, p.deptno, m.name
FROM professor p, major m
where p.deptno = m.code
 AND p.hiredate = (SELECT hiredate FROM professor WHERE NAME="이상미")

/*
  다중행 서브쿼리 : 서브쿼리의 결과가 여러행인 경우
  연산자 : in, any, all
    - in : or 
	 - any 
	    >any : 서브쿼리의 결과 중 한개보다 큰값인 경우
	    <any : 서브쿼리의 결과 중 한개보다 작은값인 경우
	 - all            
	    >all : 서브쿼리의 결과의 모든 값보다 큰값인 경우
	    <all : 서브쿼리의 결과의 모든 값보다 작은값인 경우
*/
-- dept,emp에서 근무지역이 서울인 사원의 사원번호,이름,부서코드,부서명 출력하기
SELECT * FROM dept

SELECT e.empno, e.ename,e.deptno,d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno in (SELECT deptno FROM dept WHERE loc = '서울')

SELECT e.empno, e.ename,e.deptno,d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno IN (10,20,30,40)

/*
  문제
  1학년 학생과 같은 키를 가지고 있는 2학년 학생의 이름,키, 학년 조회하기
*/
SELECT NAME,height,grade
FROM student
WHERE grade = 2
 AND height in (SELECT height FROM student WHERE grade = 1)

-- emp 테이블에서 사원직급의 최대 급여보다 급여가 높은 직원의
-- 이름, 직급,급여 출력하기
SELECT ename,job,salary FROM emp
WHERE salary > (SELECT MAX(salary) FROM emp WHERE job="사원")

SELECT ename,job,salary FROM emp
WHERE salary >all (SELECT salary FROM emp WHERE job="사원")

-- emp 테이블에서 과장직급의 최소 급여보다 급여가 적은 직원의
-- 이름, 직급,급여 출력하기
SELECT ename,job,salary FROM emp
WHERE salary < (SELECT min(salary) FROM emp WHERE job="과장")

SELECT ename,job,salary FROM emp
WHERE salary <any (SELECT salary FROM emp WHERE job="과장")

/*
 문제
 major 테이블에서 컴퓨터정보학부에 소속된 학생의
 학번,이름,학과번호1, 학과명 출력하기
*/
SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
  AND m.part IN (SELECT CODE FROM major WHERE NAME="컴퓨터정보학부")

SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
  AND s.major1 IN 
  (SELECT CODE FROM major WHERE part =
   (SELECT CODE FROM major WHERE NAME="컴퓨터정보학부"))

SELECT s.studno, s.name, s.major1, m1.name
FROM student s, major m1,major m2
WHERE s.major1 = m1.code
  AND m1.part = m2.code  AND m2.name = "컴퓨터정보학부"
  
/*
  다중 컬럼 서브쿼리 : 비교 대상이 되는 컬럼이 2개 이상인 경우
*/  
-- 학년 별로 최대키를 가진 학생의 학번,이름,학년,키를 조회하기
SELECT studno,NAME,grade,height,MAX(height)
FROM student
GROUP BY grade

SELECT studno,NAME,grade,height
FROM student
WHERE grade = 1
  AND height = (SELECT MAX(height) FROM student WHERE grade = 1)
union  
SELECT studno,NAME,grade,height
FROM student
WHERE grade = 2
  AND height = (SELECT MAX(height) FROM student WHERE grade = 2)  
UNION
SELECT studno,NAME,grade,height
FROM student
WHERE grade = 3
  AND height = (SELECT MAX(height) FROM student WHERE grade = 3)    
union
SELECT studno,NAME,grade,height
FROM student
WHERE grade = 4
  AND height = (SELECT MAX(height) FROM student WHERE grade = 4)      

-- 다중컬럼 서브쿼리로 구현
SELECT studno,NAME,grade,height
FROM student
WHERE (grade,height) IN 
(SELECT grade,MAX(height) FROM student GROUP BY grade) 
ORDER BY grade

/*
  emp 테이블에서 직급(job)별 해당직급에서 최대 급여를 받는 직원의
  정보 조회하기
*/
SELECT * FROM emp
WHERE (job,salary) IN (SELECT job,MAX(salary) FROM emp GROUP BY job)
/*
  professor 테이블에서 학과(deptno)별 입사일이 가장 오래된 교수의
  교수번호, 이름,입사일,학과코드,학과명 조회하기
*/
SELECT p.no, p.name, p.hiredate, p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
 AND (deptno,hiredate) IN
  (SELECT deptno,MIN(hiredate) FROM professor GROUP BY deptno)
  
/*
  상호연관 서브쿼리 : 외부쿼리의 컬럼이 subquery에 영향을 주는 쿼리
*/  
-- emp 테이블에서 직원의 직급의 평균급여 이상의 급여를 받는 직원의 정보
-- 출력하기

SELECT DISTINCT job FROM emp
SELECT * FROM emp 
WHERE job="과장"
 and salary >= (SELECT AVG(salary) FROM emp WHERE job="과장")

SELECT * FROM emp 
WHERE job="사원"
 and salary >= (SELECT AVG(salary) FROM emp WHERE job="사원") 

SELECT * FROM emp e1
WHERE salary >= (SELECT AVG(salary) FROM emp e2 WHERE e2.job = e1.job) 
ORDER BY job

-- 문제
-- 교수테이블에서 교수 본인 직급(position)의 
-- 평균급여 이상을 받는 교수의 이름,직급,급여 조회하기
SELECT NAME,POSITION,salary
FROM professor p1
WHERE salary >= 
 (SELECT AVG(salary) FROM professor p2 WHERE p2.position = p1.position)