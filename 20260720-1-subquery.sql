/*
  스칼라 서브쿼리 : 컬럼부분에 사용되는 subquery
                    권장하지 않음
*/
-- emp 테이블과 dept 테이블을 이용하여 
-- 사원의 이름,직급, 부서코드, 부서명 출력하기
-- join 방식
SELECT e.ename, e.job,e.deptno,d.dname
FROM emp e , dept d
WHERE e.deptno = d.deptno
-- subquery 방식
SELECT e.ename, e.job,e.deptno,
       (SELECT dname FROM dept d WHERE d.deptno=e.deptno) 부서명
FROM emp e 

/*
  inline view : from 구문에 사용되는 subquery
                반드시 별명을 설정해야 함
    view : 가상테이블
*/
-- 학년별 평균체중이 가장 적은 학년의 학년과 평균체중 출력하기
SELECT grade,AVG(weight) FROM student
GROUP BY grade

SELECT * FROM (SELECT grade,AVG(weight) avg FROM student
GROUP BY grade) a
WHERE AVG = (SELECT MIN(AVG) 
  FROM (SELECT grade,AVG(weight) avg FROM student GROUP BY grade) b)
/*
  from : SELECT grade,AVG(weight) avg FROM student GROUP BY grade
         결과가 a view
         컬럼 : grade, avg
  where     
     SELECT MIN(AVG) 
    FROM (SELECT grade,AVG(weight) avg FROM student GROUP BY grade) b   
*/  

SELECT grade,AVG(weight) avg FROM student
GROUP BY grade ORDER BY AVG LIMIT 0,1

-- 교수테이블에서 부서별 가장 작은 급여평균을 가진 부서와 급여평균
-- 출력하기
SELECT * 
FROM (SELECT deptno, AVG(salary) AVG FROM professor GROUP BY deptno) a
WHERE AVG = (SELECT min(AVG) 
            FROM (SELECT deptno, AVG(salary) AVG 
				      FROM professor GROUP BY deptno) a )

-- 학년별 평균체중이  적은 2개 학년의 학년과 평균체중 출력하기
-- 학년 순으로 정렬하기
SELECT * FROM
(SELECT grade, AVG(weight) FROM student GROUP by grade 
ORDER BY AVG(weight) LIMIT 0,2 ) a
ORDER BY grade
/*
  mariadb 사용가능. 오라클 사용 불가
    limit 시작인덱스(0부터), 갯수

  오라클에서는 rownum 예약어를 사용해야함.
  rownum 은 컬럼에 제공되는 예약어. 조회되는 레코드 순서를제공
  select name, rownum from 테이블명 where rownum = 1 으로 사용됨
  정렬전의 순서
  rownum은 첫번째 레코드가 조회되어야 2번째 레코드가 조회됨
  select name, rownum from 테이블명 where rownum > 3 으로 사용시
  조회된 레코드가 없음
  
  select name, rownum from 테이블명 where rownum < 3 으로 사용 가능  
*/
/*
  view : 가상 테이블. 논리적인 테이블. 
*/
-- 사원테이블에서 사원번호,이름,직책만 가지고 있는 v_emp 뷰 생성하기
CREATE OR REPLACE VIEW v_emp
AS SELECT empno, ename, job FROM emp

SELECT * FROM v_emp
DESC v_emp

-- v_emp 테이블의 모든 내용과 dept 테이블에서 부서명을
-- 조회하기
SELECT v.*,d.dname 
FROM v_emp v , dept d,emp e
WHERE v.empno = e.empno 
  AND e.deptno = d.deptno
  
-- v_emp 테이브을 inline 뷰로 처리하기
SELECT v.*,d.dname 
FROM (SELECT empno,ename,job FROM emp) v , dept d,emp e
WHERE v.empno = e.empno 
  AND e.deptno = d.deptno
  
/*
   서브쿼리 : sql 구문내에 사용되는 select 구문
   서브쿼리 사용 위치
     - where 조건문
     - 컬럼위치 : 스칼라 서브쿼리. 
     - from위치 : inline view
     - having 위치
*/  
-----------------------------------
  
  