-- 1. 학생의 생일이 97년 이후인 학생의 학번, 이름, 생일을 출력하기
SELECT studno,NAME,birthday FROM student 
WHERE birthday > '1996-12-31'
SELECT studno,NAME,birthday FROM student 
WHERE year(birthday) > 1996
SELECT studno,NAME,birthday FROM student 
WHERE year(birthday) >= 1997

-- 2. 학생 테이블을 읽어 
--    '학생이름의 생일은 yyyy-mm-dd  입니다. 축하합니다' 형태로 출력하기
SELECT CONCAT(NAME,'의 생일은 ',birthday,' 입니다. 축하합니다')  생일정보 FROM student

-- 3. 학생 테이블에서 학생 이름과키,몸무게, 표준체중을 출력하기
--    표준 체중은 키에서 100을 뺀 값에 0.9를 곱한 값이다.
SELECT NAME,height,weight, (height-100)*0.9 표준체중 FROM student

SELECT NAME,height,weight, (height-100)*0.9 표준체중,
       if(weight > (height-100)*0.9,"과체중","정상체중") FROM student
       
SELECT NAME,height,weight, (height-100)*0.9 표준체중,
       case 
         when ( weight - (height-100)*0.9 )>= 10 then "과체중"
         when ( weight - (height-100)*0.9 ) BETWEEN -5 AND 9 then "정상체중"
         when ( weight - (height-100)*0.9 ) < -5 then "저체중"
       END 체중단계
FROM student

-- 4. 101 번 학과 학생 중에서 3학년 이상인 학생의 
-- 이름, 아이디, 학년을 출력하기
SELECT NAME,id,grade FROM student
WHERE major1 = 101 AND grade >= 3

SELECT NAME,id,grade FROM student
WHERE major1 = 101
INTERSECT
SELECT NAME,id,grade FROM student
WHERE grade >= 3

-- 5. EMP 테이블에서 급여가 600에서 700 사이인 사원의 
-- 성명, 업무(job), 급여(salary), 부서번호(deptno)를 출력하여라.
SELECT ename,job,salary,deptno FROM emp
WHERE salary BETWEEN 600 AND 700

-- 6. EMP테이블에서 사원번호(empno)가 2001, 2005, 2008 인 
-- 사원의 사원번호, 성명, 업무(job), 급여, 입사일자(hiredate)를 출력하여라.
SELECT empno,ename, job,salary,hiredate FROM emp
WHERE empno IN (2001,2005,2008)

-- 7. EMP 테이블에서 이름의 첫 글자가 ‘주’인 사원의 이름, 급여를 조회하라.
SELECT ename,salary FROM emp WHERE left(ename,1) = '주'
SELECT ename,salary FROM emp WHERE ename LIKE '주%'

-- 8. EMP 테이블에서 급여가 800 이상이고, 담당업무(JOB)이 차장인 
--    사원의 사원번호, 성명, 담당업무, 급여, 입사일자, 부서번호를 출력하여라.
SELECT empno,ename,job,salary,hiredate,deptno  FROM emp
WHERE salary >= 800 AND  job = '차장'

-- 9. 교수테이블에서 이메일이 있는 교수의 이름, 직책,   email, emailid 를 출력하기
--  emailid는 @이전의 문자를 말한다.
select name, position,email,
substr(email,1,instr(email,'@')-1) emailid 
from professor

-- 10. 101번 학과 학생의 이름 중 두번째 글자만 '#'으로 치환하여 출력하기
select name, replace(name,substr(name,2,1),'#')
from student where major1 = '101'

-- 11. 102번 학과 학생의 이름과 전화번호, 전화번호의 국번부분만#으로 치환하여 출력하기(단 국번은 3자리로 간주함.)
select name, tel,
replace(tel,substr(tel,instr(tel,')')+1,3),'###')
from student
where major1 = 102

-- 12. 교수테이블의의  email 주소의 @다음의 3자리를 ###으로 치환하여 출력하기  교수의 이름, email, #mail을 출력하기
select name, position,email, 
replace(email,substr(email,instr(email,'@')+1,3),'###') "#mail"
from professor

-- 13. 교수테이블의  email 주소의 @앞의 3자리를 ###으로 치환하여 출력하기  교수의 이름, email, #mail을 출력하기
select name, position,email, 
      replace(email,substr(email,instr(email,'@')-3,3),'###') "#mail"
from professor

-- 14. 사원테이블에서 사원이름에 *를 왼쪽에 채운  6자리수 이름과, 업무와 급여를 출력한다.
select lpad(ename,6,'*'), job,salary from emp

-- 15. 교수들의 근무 개월 수를 현재 일을 기준으로  계산하되,  개월수는 일자를 30으로 나누어 계산한다
-- 근무 개월 순으로 정렬하여 출력하기.  
-- 단, 개월 수의 소수점 이하 버린다
select name,hiredate, 
truncate(datediff(NOW(),hiredate)/30,0) 근무개월 
from professor order by 근무개월;


-- 16. 사용자 아이디에서 문자열의 길이가 7이상인   학생의 이름과 
-- 사용자 아이디를 출력 하여라
SELECT NAME,id FROM student WHERE CHAR_LENGTH(id) >= 7
SELECT NAME,id FROM student WHERE LENGTH(id) >= 7

-- 17. 교수테이블에서 이름과, 교수가 사용하는 email  서버의 이름을   
--  출력하라.  이메일 서버는 @이후의 문자를 말한다.

SELECT NAME, SUBSTR(email,INSTR(email,"@")+1) email서버 
FROM professor

-- 18. 101번학과, 201번, 301번 학과 교수의 이름과  id를 출력하는데, id는 오른쪽을 $로 채운 후 
--      20자리로 출력하고  동일한 학과의 학생의   이름과 id를 출력하는데,  학생의 id는 왼쪽#으로 채운 후 20자리로 출력하라.
select name,rpad(id,20,'$') from professor 
where deptno in (101,201,301)
union
select name,lpad(id,20,'#') from student
 where major1 in (101,201,301)

-- 19. 2026년 1월 10일 부터 2026년 5월 20일까지 개월수를 반올림해서 정수 출력하기
-- 개월수 : 일자/30 으로 하고 반올림하여 정수로 출력함
select DATEDIFF('2026-5-20','2026-01-10')/30
select round(DATEDIFF('2026-5-20','2026-01-10')/30)

SELECT 
 DATEDIFF(STR_TO_DATE('2026년5월20일','%Y년%m월%d일'),
 str_to_date('2026년01월10일','%Y년%m월%d일'))/30
                
SELECT 
round(DATEDIFF(STR_TO_DATE('2026년5월20일','%Y년%m월%d일'),
str_to_date('2026년01월10일','%Y년%m월%d일'))/30)

-- 20. EMP 테이블에서 10번 부서원의 현재까지의 근무 월수를 계산하여  
-- 출력하여라.  
-- 근무월수 : 근무일수/30 반올림하여 정수로 출력하기
select ename, round(datediff(NOW(),hiredate)/30) 근무월수 from emp
where deptno=10


-- 21. 학생의 이름과 지도교수번호 조회하기
--   지도교수가 없는 경우 지도교수배정안됨 출력하기
SELECT NAME, ifnull(profno,'지도교수배정안됨') profno 
FROM student


-- 22. major 테이블에서 코드, 코드명, build 조회하기
--   build 값이 없는 경우 '단독 건물 없음' 출력하기
SELECT CODE, NAME,ifnull(build,'단독건물없음')
FROM major

-- 23. 학생의 이름, 전화번호, 지역명 조회하기
-- 지역명 : 지역번호가 02 : 서울, 031:경기, 032:인천 그외 기타지역
SELECT NAME, tel, 
    if(LEFT(tel,INSTR(tel,')')-1)=02,'서울',
	  if(LEFT(tel,INSTR(tel,')')-1)=031,'경기',
	  if(LEFT(tel,INSTR(tel,')')-1)=032,'인천','그외기타지역'))) 지역명
FROM student

SELECT NAME,tel,
 case LEFT(tel,INSTR(tel,')')-1) 
      when '02' then '서울' 
      when '031' then '경기' 
      when '032' then '인천'
		ELSE "그외기타지역" END 지역명
FROM student
		 
-- 24. 학생의 이름, 전화번호, 지역명 조회하기
-- 지역명 : 지역번호가 02,031,032: 수도권, 그외 기타지역 
SELECT NAME, tel, 
    if(LEFT(tel,INSTR(tel,')')-1)=02,'수도권',
	  if(LEFT(tel,INSTR(tel,')')-1)=031,'수도권',
	  if(LEFT(tel,INSTR(tel,')')-1)=032,'수도권','기타지역'))) 지역명
FROM student

SELECT NAME, tel, 
 if(LEFT(tel,INSTR(tel,')')-1) IN (02,031,032),
 "수도권",'기타지역') 지역명
FROM student

SELECT NAME,tel,
 case when LEFT(tel,INSTR(tel,')')-1) IN (02,031,032) then  "수도권"
		ELSE "기타지역" END 지역명
FROM student


-- 26. score 테이블에서 학번, 국어,영어,수학, 학점, 인정여부 을 출력하기
-- 학점은 세과목 평균이 95이상이면 A+,90 이상 A0
-- 85이상이면 B+,80 이상 B0
-- 75이상이면 C+,70 이상 C0
-- 65이상이면 D+,60 이상 D0
-- 인정여부는 평균이 60이상이면 PASS로 미만이면 FAIL로 출력한다.

SELECT studno, kor, eng, math,(kor+math+eng)/3 평균,
   case when (kor+math+eng)/3 >= 95 then 'A+'
        when (kor+math+eng)/3 >= 90 then 'A0'
        when (kor+math+eng)/3 >= 85 then 'B+'
        when (kor+math+eng)/3 >= 80 then 'B0'
        when (kor+math+eng)/3 >= 75 then 'C+'
        when (kor+math+eng)/3 >= 70 then 'C0'
        when (kor+math+eng)/3 >= 65 then 'D+'
        when (kor+math+eng)/3 >= 60 then 'C0'
        ELSE 'F' END 학점,
    if(((kor+math+eng)/3) >= 60,'PASS','FAIL') 인정여부
FROM score    


-- 27. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D그룹을 출력하기
-- 160 미만 : A그룹
-- 160 ~ 169까지 : B그룹
-- 170 ~ 179까지 : C그룹
-- 180이상       : D그룹

SELECT NAME,height, 
  case when height >= 180 then 'D그룹'
       when height >= 170 then 'C그룹'
       when height >= 160 then 'B그룹'
       ELSE 'A그룹' END 그룹
FROM student

SELECT NAME,height, 
  case when height >= 180 then 'D그룹'
       when height BETWEEN 170 and 179 then 'C그룹'
       when height BETWEEN 160 AND 169 then 'B그룹'
       ELSE 'A그룹' END 그룹
FROM student

-- 28.  교수테이블에서 교수의 급여액수를 기준으로 200이하는 4급, 201~300 : 3급, 301~400:2급
-- 401 이상은 1급으로 표시한다. 교수의 이름, 급여, 등급을 출력하기
-- 단 등급의 오름차순으로 정렬하기

SELECT NAME, salary, 
   if(salary <= 200,'4급',
	  if(salary <= 300,'3급',
	  if(salary <= 400,'2급','1급'))) 등급
FROM professor
ORDER BY 등급

SELECT NAME, salary, 
   case when salary <= 200 then '4급'
        when salary between 201 AND 300 then '3급'
        when salary BETWEEN 301 AND 400 then '2급'
        ELSE '1급' END 등급
FROM professor
ORDER BY 등급
