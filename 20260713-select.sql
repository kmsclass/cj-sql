-- desc 테이블의 구조 조회. 스키마 조회
DESC dept

-- select : 테이블에 저장된 데이터 조회
/* 
SELECT 컬럼명 || *
FROM  테이블명
[ where 조건문 ] => 레코드 선택 기준 조건
*/
-- emp테이블의 모든 데이터를 조회하기
SELECT * FROM emp 
-- emp 테이블에서 empno(사원번호),ename(사원명),deptno(부서코드) 조회하기
SELECT empno,ename,deptno
FROM emp

-- 상수 컬럼 사용하기
SELECT NAME, "학생",grade,"학년"
FROM student

-- 1. 교수테이블(professor)의 구조 조회하기
DESC professor
-- 2. 교수테이블(professor) 중 교수번호(no),교수이름(name)을 조회하기
--    교수이름뒤에 교수컬럼을 출력하기
SELECT NO,name,"교수" 
FROM professor   

-- 컬럼에 별명 출력하기
-- 교수테이블의 no 교수번호, name 교수이름 출력하기
SELECT NO "교수번호", NAME "교수이름"
FROM professor

-- 컬럼에 연산자 (+,-, *, /) 사용하기
-- emp(사원번호)테이블에서 사원이름(ename),현재급여(salary),
-- 10%인상급여 출력하기
SELECT ename,salary,salary*1.1 "10% 인상급여"
FROM emp

-- 1. alias 주기
SELECT ename '사원번호' ,salary 현재급여 ,salary*1.1 "10% 인상급여"
FROM emp
-- 2. alias 주기
SELECT ename AS '사원번호' ,salary AS 현재급여 ,salary*1.1 AS "10% 인상급여"
FROM emp

-- distinct : 중복제거. 한번만 사용가능
-- 교수(professor)가 속한 부서코드(deptno) 조회하기
SELECT distinct deptno FROM professor

-- 교수(professor)가 속한 부서코드(deptno)별 직급(position)  조회하기
SELECT distinct deptno, distinct position FROM professor -- 오류 발생
SELECT distinct deptno,  position FROM professor

/*
   select 컬럼명 | 상수(리터널)컬럼 | 별명 | 연산된컬럼 | distinct
   from 테이블명
*/
-- where 조건문 : 레코드 선택 조건
--                없으면 : 모든 레코드 선택
--                있으면 : 조건문이 참인 레코드만 선택

-- 학생테이블(student)에서 1학년 학생의 모든 정보 출력하기
SELECT *
FROM student
WHERE grade = 1  -- grade(학년)컬럼의 값이 1인 레코드만 선택

-- 문제 : 학생테이블에서 2학년학생의 학번(studno), 
--        이름(name), 키(height),몸무게(weight) 출력하기
SELECT studno,NAME, height, weight
FROM student
WHERE grade = 2

/*
사원테이블(emp)에서 부서코드(deptno)가 10인 사원의 이름(ename) 급여(salary),
부서코드(deptno) 출력하기
*/

SELECT ename,salary, deptno
FROM emp
WHERE deptno = 10
/*
사원테이블(emp)에서 급여가 800보다 큰 사람의 이름(ename)과 
급여(salary)를 출력하기
*/
SELECT ename, salary
FROM emp
WHERE salary > 800

/*
  where 조건문에 사용되는 연산자
*/
-- 사원(emp)테이블에서 모든 사원의 급여를 10%인상예정인경우
-- 인상예정 급여가 1000 이상인 사원의 이름(ename),현재급여(salary),
-- 인상예정급여(salary * 1.1), 부서코드(deptno) 조회하기
SELECT ename, salary,salary * 1.1, deptno
FROM emp
WHERE salary * 1.1 >= 1000

-- between : 범위지정
-- emp 테이블에서 사원의 급여(salary)가 800 이상 1000 이하인 사원의 
-- 이름(ename),급여(salary),부서코드(deptno)를 출력하기
SELECT ename, salary, deptno
FROM emp
WHERE salary >= 800 AND salary <= 1000

SELECT ename, salary, deptno
FROM emp
WHERE salary BETWEEN 800 AND 1000 
/*
  1학년 학생 중 몸무게가 70 이상 80 이하인 학생의 
  이름(name),학년(grade),몸무게(weight), 전공1학과(major1)
  조회하기
*/
SELECT NAME,grade,weight, major1
FROM student
WHERE grade = 1 AND weight >= 70 AND weight <= 80

SELECT NAME,grade,weight, major1
FROM student
WHERE grade = 1 AND weight BETWEEN 70 AND 80

/*
  where 조건문에 사용되는 연산자 : in
*/
-- 학생테이블에서 전공1학과(major1)가 101,201인 학과에 속한
-- 학생의 모든 정보를 조회하기
SELECT *
FROM student
WHERE major1 = 101 OR major1 = 201

SELECT *
FROM student
WHERE major1 IN (101,201)

-- 교수테이블(professor)에서 학과코드(deptno)가 101,201 학과에 속한
-- 교수의 교수이름(name),학과코드(deptno),입사일(hiredate)조회하기
SELECT NAME, deptno,hiredate
FROM professor
WHERE deptno IN (101,201)

SELECT NAME, deptno,hiredate
FROM professor
WHERE deptno = 101 or deptno = 201

-- 교수테이블(professor)에서 학과코드(deptno)가 101,201 학과가 아닌 
-- 부서에  속한
-- 교수의 교수이름(name),학과코드(deptno),입사일(hiredate)조회하기
SELECT NAME, deptno,hiredate
FROM professor
WHERE deptno not IN (101,201)

-- 전공1학과(major1)가 101,201 학과에 속하지 않는 학생 중 키가 170이상인
-- 학생의 학번(studno),이름(name),몸무게(weight),키(height),학과코드(major1)
-- 조회하기
SELECT studno,NAME,weight,height, major1 
FROM student
WHERE major1 NOT IN (101,201) AND height >= 170

/*
  where 조건문에서 사용되는 연산자 : like
    % : 0개이상 임의의 문자
    _ : 1개의 임의의 문자
*/
-- 학생 중 성이 김씨인 학생의 학번(studno),이름(name),전공학과1(major1)
-- 조회하기
SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '김%'
-- 학생 중 이름에 진을 가진 학생의 학번(studno),이름(name),전공학과1(major1)
-- 조회하기
SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '%진%'

-- 학생 중 이름이 2자인 학생의 학번,이름,전공학과1 조회하기
SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '__'

/*
문제 : 학생 중 이름의 끝자가 훈인 학생의 학번,이름,전공학과1을 조회하기
*/
SELECT studno,NAME,major1
FROM student
WHERE NAME LIKE '%훈'
/*
문제 : 학생 중 전화번호(tel)가 서울지역인(02)인 학생의 학번,이름,전화번호 
      조회하기
*/
SELECT studno,NAME,tel
FROM student
WHERE tel LIKE '02%'
/*
문제 : 교수테이블(professor)에서 id컬럼의 값에 k 문자를 가진 교수의
     이름(name),id,직급(position) 조회하기
*/
SELECT NAME,id,POSITION
FROM professor
WHERE id LIKE '%k%'
-- 대문자 검색 : 대소문자 구분안함. 오라클은 대소문자 구분
SELECT NAME,id,POSITION
FROM professor
WHERE id LIKE '%K%'
-- 대소문자 구분하기 : binary 예약어 사용
SELECT NAME,id,POSITION
FROM professor
WHERE id LIKE BINARY '%K%'

SELECT NAME,id,POSITION
FROM professor
WHERE id LIKE BINARY '%k%'

-- not like 
-- 학생 중 성이 이씨가 아닌 학생의 학번,이름,전공1학과 조회하기
SELECT studno,NAME,major1
FROM student
WHERE NAME not LIKE '이%'

-- 교수테이블(professor)에서 101,201학과가 아닌 학과에 속한 교수 중
-- 성이 김씨가 아닌 교수의 이름(name),학과코드(deptno),직급(position)
-- 조회하기
SELECT NAME,deptno,POSITION
FROM professor
WHERE deptno not IN (101,201) AND NAME not LIKE '김%'

/*
   null : 값이 없음. 연산의 대상이 안됨. 
    컬럼  is null : 컬럼의 값이 null 레코드
    컬럼  is not null : 컬럼의 값이 null이 아닌 레코드
*/
-- 교수테이블에서 보너스가 없는 교수의 이름,급여,보너스를 조회하기
SELECT NAME,salary,bonus 
FROM professor
WHERE bonus = NULL => 이런 표현은 안됨. 오류발생 안함. 조회되는 레코드없음

SELECT NAME,salary,bonus 
FROM professor
WHERE bonus IS null
-- 교수테이블에서 보너스가 있는 교수의 이름,급여,보너스를 조회하기
SELECT NAME,salary,bonus 
FROM professor
WHERE bonus IS not NULL

/*
 학생테이블(student)에서 지도교수가 있는 학생의 학번(studno),이름(name),
 전공학과1(major1),학년(grade),지도교수번호(profno)를 조회하기
*/
SELECT studno,NAME,major1,grade,profno 
FROM student
WHERE profno IS NOT null
/*
 학생테이블(student)에서 지도교수가 없는 학생의 학번(studno),이름(name),
 전공학과1(major1),학년(grade),지도교수번호(profno)를 조회하기
*/
SELECT studno,NAME,major1,grade,profno 
FROM student
WHERE profno IS NULL

-- 교수테이블(professor)에서 
-- 교수의 교수번호(no),이름(name),현재급여(salary),
-- 보너스(bonus),통상급여(salary + bonus) 조회하기
SELECT NO,NAME,salary,bonus,salary+bonus 
FROM professor
-- null 과 연산의 결과는 null임
-- 
SELECT NO,NAME,salary,bonus,salary+bonus 
FROM professor
WHERE bonus IS NOT NULL
/*
3.  select 컬럼(*,리터널,별명, distinct)
1.  from 테이블명                                           
2.  where 조건문
    - 연산자, between, (not) in, (not) like, is (not) null
    order by 컬럼명|조회된컬럼의 순서|별명 
	       [asc(오름차순 기본정렬) | desc(내림차순정렬)]
	       
	컬럼명정렬 : 조회된 컬럼이 아니어도 정렬가능
	조회된컬럼의 순서 : 조회된 컬럼만 가능
	별명 : 조회된 컬럼의 별명이 존재하는 컬럼
*/

-- 1학년 학생의 이름(name),키(heigh)를 조회하기. 단 키가 큰순으로 출력하기
-- 컬럼명을 이용한 정렬
SELECT NAME,height
FROM student
WHERE grade = 1
ORDER BY height DESC
-- 조회된 컬럼의 순서로 정렬
SELECT NAME,height
FROM student
WHERE grade = 1
ORDER BY 2 desc

-- 컬럼의 별명으로 정렬
SELECT NAME 학생이름 ,height 키
FROM student
WHERE grade = 1
ORDER BY 키 desc

-- 학생의 이름,학년,키조회하기. 학년순, 키가큰순으로 정렬하기
SELECT NAME,grade,height
FROM student
ORDER BY grade ASC, height DESC 

SELECT NAME,grade,height
FROM student
ORDER BY grade , height DESC 

-- 조회된 컬럼의 순서로 정렬
SELECT NAME,grade,height
FROM student
ORDER BY 2 , 3 DESC 
-- 컬럼의 별명을 이용하여 정렬
SELECT NAME 학생이름,grade 학년,height 키
FROM student
ORDER BY 학년 , 키 DESC 

SELECT NAME 학생이름,grade 학년,height 키
FROM student
ORDER BY 2 , 키 DESC 

/*
  교수테이블(professor)에서 교수번호(no),교수이름(name), 급여(salary), 
  예상급여(10%인상) 조회하기
  학과코드순,예상급여의 내림차순으로 정렬하기
*/

