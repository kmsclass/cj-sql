/*
   그룹함수 : 여러개의 행의 정보를 이용하여 결과 리턴
3	select 컬럼명 | *
1	from 테이블명 | 뷰명
2	where 조건문      => 레코드 선택 조건	
4	group by 컬러명   => 레코드를 그룹화하기위한 기준컬럼
5	having 조건문     => 그룹함수의 조건
6	order by 정렬컬럼 [asc|desc]

그룹함수는 null값을 포함하지 않음
*/
-- count(*)     : 조회된 전체 레코드의 갯수 리턴
-- count(컬럼명): 컬럼값이 null이 아닌 레코드의 갯수
-- 교수의 전체 인원수와 보너스를 받는 인원수 출력하기
SELECT COUNT(*), COUNT(bonus) FROM professor 

-- 학생의 전체 인원수와 지도교수를 배정받은 
-- 인원수 출력하기
SELECT COUNT(*), COUNT(profno) FROM student
-- 1학년학생의 인원수와 지도교수를 배정받은 인원수 출력
SELECT COUNT(*), COUNT(profno)
FROM student
WHERE grade =1
-- 2학년학생의 인원수와 지도교수를 배정받은 인원수 출력
SELECT COUNT(*), COUNT(profno)
FROM student
WHERE grade =2
-- 학년별 인원수와 지도교수를 배정받은 인원수 출력
SELECT grade, COUNT(*), COUNT(profno)
FROM student
GROUP BY grade

-- 전공1학과별 학생수와, 지도교수를 배정받은 학생수 출력
SELECT major1, COUNT(*), COUNT(profno)
FROM student
GROUP BY major1
/*
 합계 : sum
 평균 : avg
*/
-- 교수들의 급여합계와 보너스합계 출력
select SUM(salary),SUM(bonus)
FROM professor

-- 교수들의 인원수,급여합계와 보너스합계,
-- 급여평균, 보너스평균 출력
-- 보너스평균 : 보너스를 받는 교수들의 평균
SELECT COUNT(*),SUM(salary),SUM(bonus),
       AVG(salary),AVG(bonus)
FROM professor       

-- 교수들의 인원수,급여합계와 보너스합계,
-- 급여평균, 보너스평균 출력
-- 보너스평균 : 전체 교수들의 평균
SELECT COUNT(*),SUM(salary),SUM(bonus),
       AVG(salary),AVG(ifnull(bonus,0))
FROM professor       

/*
  문제 1
  교수의 부서코드, 부서별 인원수, 
  급여합계,보너스합계,급여평균,보너스평균을 출력하기
  단 보너스가 없는 교수도 평균에 포함되도록 하기
*/
SELECT deptno,COUNT(*),SUM(salary),SUM(ifnull(bonus,0)),
       AVG(salary),AVG(ifnull(bonus,0))
FROM professor       
GROUP BY deptno
-- 평균보너스가 50 이하인 정보만 출력하기
SELECT deptno,COUNT(*),SUM(salary),SUM(ifnull(bonus,0)),
       AVG(salary),AVG(ifnull(bonus,0))
FROM professor       
GROUP BY deptno
having AVG(ifnull(bonus,0)) <= 50

/*
  문제 2
  학년별 학생의 인원수, 키와 몸무게의 평균을 출력하기
  학년 순으로 정렬하기
*/
SELECT grade, COUNT(*), AVG(height),AVG(weight)
FROM student
GROUP BY grade
-- 평균 몸무게가 65미만인 학년 정보 출력하기
SELECT grade, COUNT(*), AVG(height),AVG(weight)
FROM student
GROUP BY grade
HAVING AVG(weight) < 65
/*
 최대값,최소값 : max,min
*/
-- 전공1학과별 가장 키가 큰 학생의 큰키값과작은키값을 출력
SELECT major1, MAX(height),MIN(height)
FROM student
GROUP BY major1

-- 중첩 그룹함수 사용 불가 => 오라클에서는 가능함
SELECT min(MAX(height))
FROM student
GROUP BY major1

-- 교수에 직급별 최대급여와, 최소급여, 평균급여를 출력
-- 평균급여는 반올림하여 정수로 출력하기
SELECT POSITION,MAX(salary),MIN(salary),
       round(AVG(salary))
FROM professor
GROUP BY POSITION

-- 전공1학과별 가장 키가 큰학생의 큰키값, 
-- 작은키값을 출력하기
-- 최대키가 180이상인 학과정보만 출력하기
SELECT major1, MAX(height),MIN(height)
FROM student
GROUP BY major1
HAVING MAX(height) >= 180

/*
  표준편차 : stddev
  분산 : variance
*/
-- score 테이블에서 합계,평균,표준편차,분산 출력
SELECT SUM(kor),SUM(math),SUM(eng),
       avg(kor),avg(math),avg(eng),
       stddev(kor),stddev(math),stddev(eng),
       variance(kor),variance(math),variance(eng)
FROM score
-- 문제
-- 교수테이블에서 학과별 평균 급여가 350이상인 부서의 
-- 급여평균, 보너스평균, 급여표준편차를 출력하기
SELECT deptno,AVG(salary),AVG(ifnull(bonus,0)),
       STDDEV(salary)
FROM professor
GROUP BY deptno
HAVING AVG(salary) >= 350

-- 주민번호 기준으로 
-- 남학생,여학생의 최대키,최소키,평균키 출력
SELECT if(SUBSTR(jumin,7,1)=1,"남학생","여학생") 성별,
   MAX(height),MIN(height),AVG(height)
FROM student   
GROUP BY SUBSTR(jumin,7,1)

-- 별명으로 group by 설정 (오라클은 불가능)
SELECT if(SUBSTR(jumin,7,1)=1,"남학생","여학생") 성별,
   MAX(height),MIN(height),AVG(height)
FROM student   
GROUP BY 성별

SELECT if(SUBSTR(jumin,7,1)=1,"남학생","여학생") 성별,
   MAX(height),MIN(height),AVG(height)
FROM student   
GROUP BY if(SUBSTR(jumin,7,1)=1,"남학생","여학생")

-- 학생의 생일(birthday)를 이용하여
-- 월별 인원수 출력하기
SELECT MONTH(birthday) 월별,COUNT(*) 인원수
FROM student
GROUP BY MONTH(birthday)
-- 학생의 생일(jumin)를 이용하여
-- 월별 인원수 출력하기
SELECT substr(jumin,3,2) 월별,COUNT(*) 인원수
FROM student
GROUP BY substr(jumin,3,2)

-- 생일(birthday)의 월별 인원수 출력하기. 가로 출력
SELECT CONCAT(COUNT(*)+"",'명') 전체,
       COUNT(if(MONTH(birthday)=1,1,NULL)) 1월,
       COUNT(if(MONTH(birthday)=2,1,NULL)) 2월,
       COUNT(if(MONTH(birthday)=3,1,NULL)) 3월,
       COUNT(if(MONTH(birthday)=4,1,NULL)) 4월,
       COUNT(if(MONTH(birthday)=5,1,NULL)) 5월,
       COUNT(if(MONTH(birthday)=6,1,NULL)) 6월,
       COUNT(if(MONTH(birthday)=7,1,NULL)) 7월,
       COUNT(if(MONTH(birthday)=8,1,NULL)) 8월,
       COUNT(if(MONTH(birthday)=9,1,NULL)) 9월,
       COUNT(if(MONTH(birthday)=10,1,NULL)) 10월,
       COUNT(if(MONTH(birthday)=11,1,NULL)) 11월,
       COUNT(if(MONTH(birthday)=12,1,NULL)) 12월
FROM student

/*
1994-10-20
1995-01-20
1995-05-21
1995-07-21
.

전체 1월   2월    3월 4월 5월   7월 .10월 . 12월
     null   null                     1     null
     1      null  .
    null                   1       null
                                 1
*/
SELECT NAME,
       (if(MONTH(birthday)=1,1,NULL)) 1월,
       (if(MONTH(birthday)=2,1,NULL)) 2월,
       (if(MONTH(birthday)=3,1,NULL)) 3월,
       (if(MONTH(birthday)=4,1,NULL)) 4월,
       (if(MONTH(birthday)=5,1,NULL)) 5월,
       (if(MONTH(birthday)=6,1,NULL)) 6월,
       (if(MONTH(birthday)=7,1,NULL)) 7월,
       (if(MONTH(birthday)=8,1,NULL)) 8월,
       (if(MONTH(birthday)=9,1,NULL)) 9월,
       (if(MONTH(birthday)=10,1,NULL)) 10월,
       (if(MONTH(birthday)=11,1,NULL)) 11월,
       (if(MONTH(birthday)=12,1,NULL)) 12월
FROM student


-- 생일(jumin)의 월별 인원수 출력하기. 가로 출력
SELECT CONCAT(COUNT(*)+"",'명') 전체,
       sum(if(SUBSTR(jumin,3,2)=1,1,0)) 1월,
       sum(if(SUBSTR(jumin,3,2)=2,1,0)) 2월,
       sum(if(SUBSTR(jumin,3,2)=3,1,0)) 3월,
       sum(if(SUBSTR(jumin,3,2)=4,1,0)) 4월,
       sum(if(SUBSTR(jumin,3,2)=5,1,0)) 5월,
       sum(if(SUBSTR(jumin,3,2)=6,1,0)) 6월,
       sum(if(SUBSTR(jumin,3,2)=7,1,0)) 7월,
       sum(if(SUBSTR(jumin,3,2)=8,1,0)) 8월,
       sum(if(SUBSTR(jumin,3,2)=9,1,0)) 9월,
       sum(if(SUBSTR(jumin,3,2)=10,1,0)) 10월,
       sum(if(SUBSTR(jumin,3,2)=11,1,0)) 11월,
       sum(if(SUBSTR(jumin,3,2)=12,1,0)) 12월
FROM student


SELECT NAME,
       (if(SUBSTR(jumin,3,2)=1,1,0)) 1월,
       (if(SUBSTR(jumin,3,2)=2,1,0)) 2월,
       (if(SUBSTR(jumin,3,2)=3,1,0)) 3월,
       (if(SUBSTR(jumin,3,2)=4,1,0)) 4월,
       (if(SUBSTR(jumin,3,2)=5,1,0)) 5월,
       (if(SUBSTR(jumin,3,2)=6,1,0)) 6월,
       (if(SUBSTR(jumin,3,2)=7,1,0)) 7월,
       (if(SUBSTR(jumin,3,2)=8,1,0)) 8월,
       (if(SUBSTR(jumin,3,2)=9,1,0)) 9월,
       (if(SUBSTR(jumin,3,2)=10,1,0)) 10월,
       (if(SUBSTR(jumin,3,2)=11,1,0)) 11월,
       (if(SUBSTR(jumin,3,2)=12,1,0)) 12월
FROM student

/*
순위지정함수 : RANK() OVER(정렬방식)
*/
-- 교수의 번호,이름,급여,급여순위 출력하기
SELECT NO,NAME,salary, RANK() OVER(ORDER BY salary DESC) 순위
FROM professor
-- 교수의 번호,이름,급여,급여를 적게 받는 순위 출력하기
SELECT NO,NAME,salary, RANK() OVER(ORDER BY salary) 순위
FROM professor

-- score 테이블에서 학번,국어,수학,영어,총점, 총점기준순위
-- 출력하기. 총점이 큰순으로 지정하기
SELECT *,(kor+math+eng) 총점,
  RANK() OVER(ORDER BY (kor+math+eng) DESC) 총점순위
FROM score  

-- score 테이블에서 학번,국어,수학,영어,총점,
-- 국어등수,수학등수,영어등수,총점등수
-- 출력하기. 총점이 큰순으로 지정하기
-- 국어등수 순으로 출력하기
SELECT *,(kor+math+eng) 총점,
  RANK() OVER(ORDER BY kor DESC) 국어등수,
  RANK() OVER(ORDER BY math DESC) 수학등수,
  RANK() OVER(ORDER BY eng DESC) 영어등수,
  RANK() OVER(ORDER BY (kor+math+eng) DESC) 총점등수
FROM score  
ORDER BY 국어등수

/*
  중간값 : median => 마리아db는 안됨. 오라클 가능
  percentile_cont(순위) within group(정렬방식) over
  순위
    0.25 : 25% 해당값. 1사분위값
    0.5 : 50% 해당값. 2사분위값
    0.75 : 75% 해당값. 3사분위값
*/
-- score 테이블에서 국어점수의 중간값 출력하기
SELECT distinct
 PERCENTILE_CONT(0.5) WITHIN 
 GROUP (ORDER BY kor) OVER () 국어중간값
FROM score

SELECT *,
 PERCENTILE_CONT(0.25) WITHIN 
 GROUP (ORDER BY kor) OVER () 국어1사분위값,
 PERCENTILE_CONT(0.5) WITHIN 
 GROUP (ORDER BY math) OVER () 수학중간값,
 PERCENTILE_CONT(0.75) WITHIN 
 GROUP (ORDER BY eng) OVER () 영어3사분위값
FROM score

/*
  누계: sum(컬러명) over(정렬방식)
*/
-- 교수의 이름,급여,보너스, 급여누계 출력하기
SELECT NAME,salary,bonus, 
    SUM(salary) OVER(ORDER BY salary DESC) 급여누계
FROM professor    

-- score 테이블에서 학번,국어,수학,영어,총점,총점등수,
-- 총점누계를 출력하기
SELECT *,(kor+math+eng) 총점,
     RANK() OVER(ORDER BY (kor+math+eng) DESC) 총점등수,
SUM(kor+math+eng) OVER(ORDER BY (kor+math+eng) DESC) 총점누계
FROM score
/*
  rollup : 두개컬럼을 기준으로 그룹화하기
           첫번째 컬럼의 소계, 전체그룹 합계값 리턴
           컬럼1 기준으로 소계 리턴
           
      group by 컬럼1, 컬럼2 with rollup
		컬럼1의 기준으로 group by 실행.
		전체 기준으로 그룹함수 리턴
	
	cube : 컬럼1 부분결과 + 컬럼2 부분결과 
	   mariadb에서는 안됨.
		오라클은 가능함	    
*/
-- score 테이블에서 ,국어,수학, 국어수합합계 출력하기
SELECT kor,math,SUM(kor+math),COUNT(*)
FROM score
GROUP BY kor,math

-- 교수테이블에서 학과별,직급별 급여합계와 인원수 출력하기
SELECT deptno,POSITION,SUM(salary),COUNT(*)
FROM professor
group BY deptno,POSITION

-- 교수테이블에서 학과별,직급별 급여합계와 인원수 출력하기
-- 학과별 급여합계와 인원수 출력하기
SELECT deptno,POSITION,SUM(salary),COUNT(*)
FROM professor
group BY deptno,POSITION WITH rollup
union
SELECT deptno,POSITION,SUM(salary),COUNT(*)
FROM professor
group BY POSITION,deptno WITH rollup

--학년별, 지역별, 몸무게평균,키평균 조회하기
SELECT grade,SUBSTR(tel,1,INSTR(tel,')')-1) 지역,
       AVG(weight),AVG(height)
FROM student
GROUP BY grade,지역       

--학년별, 지역별, 몸무게평균,키평균 조회하기
-- 학년별 평균 출력하기
SELECT grade,SUBSTR(tel,1,INSTR(tel,')')-1) 지역,
       AVG(weight),AVG(height)
FROM student
GROUP BY grade,지역 WITH ROLLUP

--학년별, 몸무게평균,키평균 조회하기
SELECT grade, AVG(weight),AVG(height)
FROM student
GROUP BY grade WITH ROLLUP

-- mariadb에서는 실행 안됨. 오라클은 가능
SELECT grade,SUBSTR(tel,1,INSTR(tel,')')-1) 지역,
       AVG(weight),AVG(height)
FROM student
GROUP BY grade,지역 WITH cube

