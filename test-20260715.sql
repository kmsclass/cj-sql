/*
 1. 교수 중 부서별 급여를 최대급여,최소급여, 최대보너스,최소보너스 출력하기
 보너스가 없는 경우는 0으로 처리한다
*/
SELECT deptno,MAX(salary),MIN(salary),
       MAX(ifnull(bonus,0)),MIN(ifnull(bonus,0)) FROM professor
group BY deptno
/*
2. 학생의 학년별 키와 몸무게 평균 출력하기.
   학년별로 정렬하고, 평균은 소숫점2자리 반올림하여 출력하기
*/ 
SELECT grade,round(avg(height),2),round(avg(weight),2)
FROM student
GROUP BY grade
ORDER BY grade

/*
3. 평균키가 170이상인  전공1학과의 
    가장 키가 큰키와, 가장 작은키, 키의 평균을 구하기 
*/ 
SELECT major1, MAX(height), MIN(height), AVG(height)
FROM student
GROUP BY major1
HAVING AVG(height) >= 170

/*
4.  사원의 직급(job)별로 평균 급여를 출력하고, 
     평균 급여가 1000이상이면 '우수', 작으면 '보통'을 출력하여라
*/ 
SELECT job, AVG(salary),  if(AVG(salary)>=1000,'우수','보통') 급여수준
FROM emp
GROUP BY job


/*
5. 학과별로 학생의 평균 몸무게와 학생수를 출력하되 
    평균 몸무게의 내림차순으로 정렬하여 출력하기
*/
SELECT major1,AVG(weight),COUNT(*)
FROM student
GROUP BY major1
ORDER BY AVG(weight) desc

 
/*
6. 학과별 교수의 수가 2명 이하인 학과번호, 인원수를 출력하기
*/
SELECT deptno, COUNT(*) 
FROM professor
GROUP BY deptno
HAVING COUNT(*) <= 2

/*
7. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기
*/

SELECT case LEFT(tel,INSTR(tel,')')-1) 
            when '02' then '서울'
            when '031' then '경기'
            when '051' then '부산'
            when '052' then '경남'
            ELSE '그외' END 지역, COUNT(*)
FROM student
GROUP BY 지역

/*
8. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기. 가로출력
*/
SELECT COUNT(*) 합계,
      sum(if(LEFT(tel,INSTR(tel,')')-1)='02',1,0)) 서울,
      sum(if(LEFT(tel,INSTR(tel,')')-1)='031',1,0)) 경기,
      sum(if(LEFT(tel,INSTR(tel,')')-1)='051',1,0)) 부산,
      sum(if(LEFT(tel,INSTR(tel,')')-1)='052',1,0)) 경남,
      sum(if(LEFT(tel,INSTR(tel,')')-1) 
		  NOT IN ('02','031','051','052'),1,0)) 그외
FROM student

/*
9. 교수들의 번호,이름,급여,보너스, 총급여(급여+보너스)
     급여많은순위,보너스많은순위,총급여많은 순위 조회하기
     총급여순위로 정렬하여 출력하기. 보너스없는 경우 0으로 함
*/
SELECT NO, NAME,salary,ifnull(bonus,0),salary+ifnull(bonus,0) 총급여,
      rank() over(ORDER BY salary DESC) 급여순위,
      rank() over(ORDER BY bonus DESC) 보너스순위,
      rank() over(ORDER BY salary+ifnull(bonus,0) DESC) 총급여순위
FROM professor
ORDER BY 총급여순위

/*
10.  교수의 직급,직급별 인원수,급여합계,보너스합계,급여평균,보너스평균 출력하기
    단 보너스가 없는 교수도 평균에 포함되도록 한다.
    급여평균이 높은순으로 정렬하기
*/
SELECT POSITION 직급,COUNT(*) 인원수,
       SUM(salary) 급여합계,SUM(ifnull(bonus,0)) 보너스합계,
		 AVG(salary) 급여평균,AVG(ifnull(bonus,0)) 보너스평균 FROM professor
GROUP BY position 
ORDER BY AVG(salary) DESC

/*
11. 1학년 학생의 인원수,키와 몸무게의 평균 출력하기
*/
SELECT COUNT(*) 인원수, AVG(height) 키평균, AVG(weight) 몸무게평균
FROM student
WHERE grade = 1

SELECT COUNT(*) 인원수, AVG(height) 키평균, AVG(weight) 몸무게평균
FROM student
GROUP BY grade
having grade = 1

/*
12. 학생의 점수테이블(score)에서 수학 평균,수학표준편차,수학분산 조회하기
*/
SELECT avg(math),stddev(math),variance(math)
FROM score

/*
13. 교수의 전체 인원수와 월별 입사 인원수를 출력하기
*/
SELECT month(hiredate) 월, COUNT(*) 인원수  FROM professor
GROUP BY month(hiredate) WITH rollup

SELECT concat(COUNT(*)+"",'명') '전체' ,
       count(if(MONTH(hiredate)=1,1,NULL)) '1월',
       count(if(MONTH(hiredate)=2,1,NULL)) '2월',
       count(if(MONTH(hiredate)=3,1,NULL)) '3월',
       count(if(MONTH(hiredate)=4,1,NULL)) '4월',
       count(if(MONTH(hiredate)=5,1,NULL)) '5월',
       count(if(MONTH(hiredate)=6,1,NULL)) '6월',
       count(if(MONTH(hiredate)=7,1,NULL)) '7월',
       count(if(MONTH(hiredate)=8,1,NULL)) '8월',
       count(if(MONTH(hiredate)=9,1,NULL)) '9월',
       count(if(MONTH(hiredate)=10,1,NULL)) '10월',
       count(if(MONTH(hiredate)=11,1,NULL)) '11월',
       count(if(MONTH(hiredate)=12,1,NULL)) '12월'
FROM professor
/*
14. 학년별,성별 몸무게평균, 키평균조회하기. 학년별로도 평균 출력하기
*/
SELECT grade, if(SUBSTR(jumin,7,1) IN (1,3),"남학생","여학생") 성별, 
       AVG(weight) 몸무게평균, AVG(height) 키평균
FROM student
GROUP BY grade, 성별 WITH rollup       

/*
15. 2학년 학생의 학번,이름, score 테이블에서 학번에 해당하는  점수를 조회하기
    학번순으로 정렬하여 출력하기
*/
SELECT s1.studno,s1.name, s2.kor, s2.math, s2.eng 
FROM student s1, score s2
WHERE s1.studno = s2.studno
 AND grade = 2
ORDER BY s1.studno

SELECT s1.studno,s1.name, s2.kor, s2.math, s2.eng 
FROM student s1 join score s2
on s1.studno = s2.studno
WHERE grade = 1
ORDER BY s1.studno

/*
16. 교수의 이름, 입사일,학과코드,학과명을 출력하기 
   입사일 순으로 정렬하여 출력하기
*/
SELECT p.name,p.hiredate,p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
ORDER BY p.hiredate

SELECT p.name,p.hiredate,p.deptno, m.name
FROM professor p join major m
on p.deptno = m.code
ORDER BY p.hiredate

/*
17. 성이 김씨인 학생들의 이름, 학과이름 학과위치 출력하기
*/
SELECT s.name,m.name,m.build
FROM student s, major m
WHERE s.major1 = m.code
AND left(s.name,1) = '김'

SELECT s.name,m.name,m.build
FROM student s, major m
WHERE s.major1 = m.code
AND s.name LIKE '김%'

SELECT s.name,m.name,m.build
FROM student s join major m
on s.major1 = m.code
where left(s.name,1) = '김'

SELECT s.name,m.name,m.build
FROM student s join major m
on s.major1 = m.code
where s.name LIKE '김%'

/*
18. 김태훈 학생의 학번, 이름, 국어,영어,수학 총점을 출력하기
*/
SELECT s1.studno, s1.name, s2.kor, s2.eng, s2.math, kor+eng+math 총점
FROM student s1, score s2
WHERE s1.studno = s2.studno
AND s1.name = '김태훈'

SELECT s1.studno, s1.name, s2.kor, s2.eng, s2.math, kor+eng+math 총점
FROM student s1 join score s2
on s1.studno = s2.studno
where s1.name = '김태훈'
/*
19. 학번과 학생이름, 소속학과이름을 학생 이름순으로 정렬하여 출력
*/
SELECT s1.studno,s1.name, m.name
FROM student s1, major m
WHERE s1.major1 = m.code
ORDER by s1.name

SELECT s1.studno,s1.name, m.name
FROM student s1 join major m
on s1.major1 = m.code
ORDER by s1.name


