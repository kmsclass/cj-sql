/*
  합집합
   - union     : 합집합. 중복제거 후 출력
   - union all : 두개의 쿼리 결과를 합하여 출력함
   
   => 2개의 select의 컬럼의 갯수가 같아야 함
      별명 설정시 첫번째 select 의 별명으로 설정됨
*/
-- 전공1학과가 202번학과이거나, 전공2학과가 101 인 학생의 학번, 이름 전공1학과코드를 출력하기
SELECT studno,NAME,major1,major2 
FROM student
WHERE major1 = 202 OR major2 = 101

SELECT studno,NAME,major1,major2 
FROM student
WHERE major1 = 202
union
SELECT studno,NAME,major1,major2 
FROM student
WHERE major2 = 101
ORDER BY name

SELECT studno,NAME,major1,major2 
FROM student
WHERE major1 = 202
UNION all
SELECT studno,NAME,major1,major2 
FROM student
WHERE major2 = 101
ORDER BY NAME

-- 교수테이블에서 교수이름, 학과코드, 급여, 연봉을 조회하기
-- 보너스가 있는 경우 : 연봉 : salary * 12 + bonus
-- 보너스가 없는 경우 : 연봉 : salary * 12
SELECT NAME,deptno,salary, salary*12 + bonus 연봉, "보너스"
FROM professor
WHERE bonus IS NOT null
union
SELECT NAME,deptno,salary, salary*12,bonus 
FROM professor
WHERE bonus IS null

/*
  문제1
  교수 중 급여가 450이상인 경우 5%인상예정이고, 
  450 미만인 경우 10% 인상예정임
  교수번호(no),교수이름(name),현재급여(salary),인상예정급여 조회하기
  인상예정 급여가 큰순으로 정렬하기
*/
SELECT NO, NAME, salary,salary * 1.05 인상예정급여
FROM professor
WHERE salary >= 450
union
SELECT NO, NAME, salary,salary * 1.1
FROM professor
WHERE salary < 450
ORDER BY 인상예정급여 DESC
/*
  교집합 : intersect
  and 연산자를 이용하는 경우가 많다
*/
-- 전공1학과가 202번이고, 전공2학과가 101번인 학생의 모든 정보 출력하기
SELECT * FROM student
WHERE major1 = 202 AND major2 = 101


/*
 차집합 : except. 오라클 : minus, except
  첫번째 select 결과에서 두번째 select 결과를 뺀 결과
*/
-- 전공1학과가 202번 학생 중 전공2학과가 101번이 아닌 학생의
-- 학번, 이름, 전공1코드, 전공2코드를 출력하기
SELECT studno,NAME,major1,major2
FROM student
WHERE major1 = 202 AND major2 != 101

SELECT studno,NAME,major1,major2
FROM student
WHERE major1 = 202
except
SELECT studno,NAME,major1,major2
FROM student
WHERE major2 = 101
-- ----------------------------------------------
/*
   단일행 함수 : 한개의 레코드에 영향을 주는 함수
   그룹함수    : 여러개의 레코드의 결과 출력
   
   문자관련함수
    - upper : 대문자로 리턴
    - lower : 소문자로 리턴
    - length : 문자의 바이트 수 리턴. 오라클:lengthb
    - char_length : 문자의 갯수 리턴. 오라클:length
*/
-- 학생의 이름, 아이디, 이름글자수,이름바이트수,id글자수,id바이트수
-- 를 출력하기
SELECT NAME, id, CHAR_LENGTH(NAME), LENGTH(NAME),
       CHAR_LENGTH(id),LENGTH(id)
FROM student       

/*
  연결함수 : concat. 오라클: ||
*/
-- 교수의 이름과 직급을 연결하여 출력하기
SELECT concat(NAME,' ',POSITION) FROM professor

-- 학생정보를 
-- 홍길동 1학년 150cm 50kg 인형식으로 출력하기
SELECT CONCAT(NAME," ",grade,"학년 ",height,"cm ",weight,"kg") 학생정보
FROM student
/*
  부분문자열 : substr, left, right
  substr(컬럼명/문자열,시작인덱스) : 시작인덱스 이후
  substr(컬럼명/문자열,시작인덱스,글자수) : 
                               시작인덱스 이후 글자수만큼 리턴
  left(컬럼명/문자열,글자수) : 왼쪽글자부터 글자수만큼 리턴
  right(컬럼명/문자열,글자수) : 오른쪽글자부터 글자수만큼 리턴
*/
SELECT NAME, LEFT(NAME,2),RIGHT(NAME,2),
       SUBSTR(NAME,1,2),SUBSTR(NAME,2)
FROM student       

-- 문제
-- 학생 중 주민번호기준 생일이 3월인 학생의 이름과,생년월일을 조회하기
-- 생년월일은 주민번호 기준으로 한다
SELECT NAME, jumin, LEFT(jumin,6) 생년월일
FROM student
WHERE SUBSTR(jumin,3,2) = '03'

SELECT NAME, jumin, LEFT(jumin,6) 생년월일
FROM student
WHERE SUBSTR(jumin,3,2) = 3

/*
  문자열의 위치인덱스: instr
  instr(문자열,문자) : 문자열에서 문자의 위치인덱스값 리턴
*/
-- 학생의 이름,전화번호,지역번호 출력하기
-- 지역번호 : 02, 031, 032,...
SELECT NAME ,tel, LEFT(tel,INSTR(tel,')')-1) 지역번호,INSTR(tel,')')
FROM student
/*
  문자추가함수 : lpad, rpad
  lpad(문자열,전체자리수,추가문자) : 왼쪽에 문자 추가
  rpad(문자열,전체자리수,추가문자) : 오른쪽에 문자 추가
*/
-- 학생의 학번,이름 출력하기
-- 학번은 10자리로 출력. 빈자리는 오른쪽에 *로 채움
-- 이름은 10자리로 출력. 빈자리는 왼쪽에 #으로 채움
SELECT rpad(studno,10,"*"),lpad(NAME,10,"#")
FROM student
/*
  문자제거함수 : trim,ltrim,rtrim
  trim(leading/trailing/both 변경할 문자열 from 문자열)
*/
SELECT CONCAT("***",TRIM('    양쪽 공백 제거   '),"***")
SELECT CONCAT("***",LTRIM('    왼쪽 공백 제거   '),"***")
SELECT CONCAT("***",RTRIM('    오른쪽 공백 제거   '),"***")
SELECT TRIM(LEADING '0' FROM "000123456780001230000")
SELECT TRIM(trailing '0' FROM "000123456780001230000")
SELECT TRIM(both '0' FROM "000123456780001230000")

/*
  문자열치환함수 : replace
*/
-- 학생의 이름 중 성을 #으로 변경하여 출력하기
SELECT NAME, replace(name,left(NAME,1),"#") FROM student

-- 학생의 이름 중 두번째 글자를 #으로 변경하여 출력하기
SELECT NAME, replace(name,substr(NAME,2,1),"#") FROM student

-- 문제
-- 전공1학과가 101인 학과 학생의 이름, 주민번호(jumin)번호 출력하기
-- 주민번호는 뒤의 6자리는 ******로출력하기
SELECT NAME,replace(jumin,RIGHT(jumin,6),"******") FROM student
WHERE major1 = 101 
SELECT NAME,replace(jumin,substr(jumin,8),"******") FROM student
WHERE major1 = 101 
SELECT NAME,concat(substr(jumin,1,7),"******") FROM student
WHERE major1 = 101 
SELECT NAME,concat(left(jumin,7),"******") FROM student
WHERE major1 = 101 
/*
  숫자관련 함수
    반올림함수 : round
     round(숫자) : 소숫점이하 1번째 자리에서 반올림하여 정수로 리턴
     round(숫자,자리수) : 소숫점이하 자리수+1번째 
	                      자리에서 소숫점이하 자리수로 리턴
*/
SELECT ROUND(12.3456,-1) r1, -- 1의 자리에서 반올림하여 10자리로출력
       ROUND(12.3456) r2,
       ROUND(12.3456,0) r3,
       ROUND(12.3456,1) r4,
       ROUND(12.3456,2) r5,
       ROUND(12.3456,3) r6
 
/*
    버림함수 : truncate
     truncate(숫자,자리수) : 소숫점이하 자리수로 리턴
*/
SELECT truncate(12.3456,-1) r1, -- 1의 자리에서 버림 10자리로출력
--     truncate(12.3456) r2,    -- 오류발생. 
       truncate(12.3456,0) r3,
       truncate(12.3456,1) r4,
       truncate(12.3456,2) r5,
       truncate(12.3456,3) r6
       
-- 교수의 급여를 15%인상하여 정수로 출력하기
-- 교수의 이름,현재급여,반올림된 인상예정급여, 절삭된 인상예정급여
-- 출력하기
SELECT NAME, salary, round(salary * 1.15),truncate(salary * 1.15,0)
FROM professor

/*
  문제1
  점수테이블(score)에서 학번(studno),국어(kor),수학(math),영어(eng),
  총점,평균 출력하기
  평균은 소숫점이하 2자리로 반올림하기
  총점의 내림차순으로 정렬하여 출력하기
*/
DESC score
SELECT studno,kor,math,eng, kor+math+eng 총점, 
       ROUND((kor+math+eng)/3,2) 평균
FROM score
ORDER BY 총점 desc

SELECT *, kor+math+eng 총점, 
       ROUND((kor+math+eng)/3,2) 평균
FROM score
ORDER BY 총점 DESC

SELECT *, kor+math+eng 총점, 
       ROUND((kor+math+eng)/3,2) 평균
FROM score
ORDER BY kor+math+eng desc

SELECT *, kor+math+eng 총점, 
       ROUND((kor+math+eng)/3,2) 평균
FROM score
ORDER BY ROUND((kor+math+eng)/3,2) DESC -- 평균의 역순으로 정렬

/*
  근사정수 : 가장 가까운 정수
    ceil   : 큰 근사정수
    floor  : 작은 근사정수
*/
SELECT CEIL(12.3456),FLOOR(12.3456),CEIL(-12.3456),FLOOR(-12.3456)
/*
  나머지함수 : mod, %연산자로 사용가능
  제곱함수 : power
  제곱근함수 : sqrt
*/
SELECT 21/8,21%8,MOD(21,8),POWER(3,3),SQRT(9)
-- 몫을 정수로 출력하기
SELECT 21/8,truncate(21/8,0),FLOOR(21/8),
       21%8,MOD(21,8),POWER(3,3),SQRT(9)
       
/*
  날짜관련 함수
  now() : 현재일시. 오라클:sysdate (datetime)
  curdate(),current_date, current_date() : 현재일자(date)
*/       
SELECT NOW(), CURDATE(), CURRENT_DATE, CURRENT_DATE()
-- 내일날짜, 어제
SELECT CURDATE() + 1,CURDATE() - 1
-- 날짜사이의 일수 : datediff()
SELECT NOW(), '2026-01-01', DATEDIFF(NOW(),'2026-01-01')
-- 학생의 이름(name),생일(birthday),현재개월수,나이를 출력하기
-- 개월수: 일수/30계산. 반올림하여 정수로 출력
-- 나이 : 일수/365계산. 반올림하여 정수로 출력
SELECT NAME, birthday, round(DATEDIFF(NOW(),birthday)/30) 개월수, 
       round(DATEDIFF(NOW(),birthday)/365) 나이
FROM student

-- 학생의 이름과 생년,생월,생일을 출력하기. yyyy-mm-dd
SELECT NAME,birthday, SUBSTR(birthday,1,4) 생년,SUBSTR(birthday,6,2) 생월,
       SUBSTR(birthday,9,2) 생일
FROM student
/*
 year(날짜) : 년도 리턴
 month(날짜) : 월 리턴
 day(날짜) : 일 리턴
 weekday(날짜) : 0:월,1:화,...일:6
 dayofweek(날짜) : 1:일, 2:월,.. 7:토
 week(날짜) : 일년 기준 몇번째 주
 last_day(날짜) : 해당월의 마지막일자 리턴
*/
SELECT NAME,birthday, YEAR(birthday) 생년, month(birthday) 생월,
       day(birthday) 생일
FROM student       

SELECT NOW(), WEEKDAY(NOW()), DAYOFWEEK(NOW()),WEEK(NOW()),
       LAST_DAY(NOW())
       
SELECT LAST_DAY('2026-02-01')       
-- 교수이름,입사일(hiredate),입사년도휴가보상일, 올해휴가보상일
-- 출력하기. 휴가보상일은 입사월의 마지막일자
SELECT NAME,hiredate, last_day(hiredate) 입사년도휴가보상일,
   last_day(CONCAT(YEAR(NOW()),SUBSTR(hiredate,5))) 입사년도휴가보상일
FROM professor

/*
  교수 중 입사월(hiredate)이 1 ~ 3월인 
  교수의 급여를 15%인상 예정임
  교수이름(name),현재급여(salary),
  반올림인상급여(salary * 1.15),급여소급일 출력하기
  급여소급일: 올해 입사월의 마지막 일자.
  인상예정 교수만 출력하기
*/
SELECT NAME,salary, round(salary*1.15) 인상급여,
last_day(CONCAT(YEAR(NOW()),SUBSTR(hiredate,5))) 급여소급일
FROM professor
WHERE month(hiredate) BETWEEN 1 and 3
/*
  date_add(날짜,옵션) : 날짜 기준 이후
  date_sub(날짜,옵션) : 날짜 기준 이전
  옵션
    year : 년도
    month : 월
    day : 일자
    hour : 시간
    minute : 분
    second : 초
*/
-- 현재시간 기준 1일 이후 날짜
SELECT NOW(), DATE_ADD(NOW(),INTERVAL 1 DAY)
-- 현재시간 기준 1시간 이후 날짜
SELECT NOW(), DATE_ADD(NOW(),INTERVAL 1 HOUR)
-- 현재시간 기준 2일 이전 날짜
SELECT NOW(), DATE_SUB(NOW(),INTERVAL 2 DAY)
-- 현재기준 10일 이후의 날짜와 20일 이후의 해당월의 마지막
-- 일자를 출력하기
SELECT NOW(), 
       DATE_ADD(NOW(),INTERVAL 10 DAY) 10일이후,
last_day(DATE_ADD(NOW(),INTERVAL 20 DAY)

-- 교수번호,이름,입사일,정식입사일 출력하기
-- 정식입사일 : 입사일기준 3개월이후로한다
SELECT NO,NAME,hiredate,date_add(hiredate,INTERVAL 3 month)
FROM professor

/*
   날짜관련 변환함수
   date_format(날짜,pattern) :  
   날짜를 pattern에 맞는 문자열로 변환. 오라클:to_char(..)
	str_to_date(pattern맞는문자열,pattern) :
   pattern에 맞는 문자열을 Date로 변환. 오라클:to_date(..)
	pattern에서 사용되는 문자
	%Y : 년도
	%m : 월
	%d : 일
	%H : 0 ~ 23시
	%h : 1 ~ 12시
	%p : AM/PM
	%W : 요일
	%a : 요일. 약자로 표시
*/
SELECT NOW(),
  DATE_FORMAT(NOW(),"%Y년%m월%d일 %H:%i:%s %W %a %p"),
  YEAR(NOW()) 년도1, DATE_FORMAT(NOW(),"%Y") 년도2
-- 지역변경
SET lc_time_names = "ko_KR"  
SELECT NOW(),
  DATE_FORMAT(NOW(),"%Y년%m월%d일 %H:%i:%s %W %a %p"),
  YEAR(NOW()) 년도1, DATE_FORMAT(NOW(),"%Y") 년도2
SET lc_time_names = "en_US"  
SELECT NOW(),
  DATE_FORMAT(NOW(),"%Y년%m월%d일 %h:%i:%s %W %a %p"),
  YEAR(NOW()) 년도1, DATE_FORMAT(NOW(),"%Y") 년도2
/*
  문제 : 2026년 12월 25일 일자를 이용하여 2026-12-25일의
         요일 출력하기
*/
SET lc_time_names = "ko_KR"  
SELECT STR_TO_DATE("2026년 12월 25일","%Y년 %m월 %d일"),
DATE_FORMAT(STR_TO_DATE
           ("2026년 12월 25일","%Y년 %m월 %d일"),"%W")
/*
   기타함수
   ifnull(컬럼,기본값) : 컬럼의 값이 null인 경우 기본값으로
                         리턴
*/           
-- 교수의 이름, 급여,보너스 출력하기. 
-- 보너스가 없는 경우는 0으로 출력하기
SELECT NAME,salary,ifnull(bonus,0)
FROM professor

/*
 문제 
 교수의 이름(name), 학과코드(deptno), 
        급여(salary),보너스(bonus), 
		  통상임금(salary + bonus) 출력하기
 단 union을 사용하지 않고 ifnull 함수를 사용하여 출력하기		  
*/
SELECT NAME,deptno,salary,bonus, 
       salary+ifnull(bonus,0) 통상임금
FROM professor
/*
  조건함수 : if, case
  if(조건문,참,거짓) : 
   조건문의 결과가 참인참.거짓인경우 거짓
   오라클: decode 함수
*/
-- 교수의 이름,학과번호,학과명 출력하기
-- 학과명은 학과번호 101이면 , 컴퓨터공학으로
-- 나머지는 공란으로 출력하기
SELECT NAME,deptno, if(deptno=101,"컴퓨터공학","") 학과명
FROM professor

-- 교수의 이름,학과번호,학과명 출력하기
-- 학과명은 학과번호 101이면 , 컴퓨터공학으로
-- 나머지는 그외학과으로 출력하기
SELECT NAME,deptno, if(deptno=101,"컴퓨터공학","그외학과") 학과명
FROM professor

-- 학생의 주민번호 7번째 자리가 1인경우 남자, 2인경우 여자
-- 로 성별을 출력하기
-- 학생의 이름,주민번호,성별 출력하기
SELECT NAME,jumin,
       if(SUBSTR(jumin,7,1)='1',"남자","여자") 성별
FROM student

-- 학생의 주민번호 7번째 자리가 1,3인경우 남자, 
--  2,4인경우 여자로 성별을 출력하기
-- 학생의 이름,주민번호,성별 출력하기
SELECT NAME,jumin,
     if(SUBSTR(jumin,7,1)='1',"남자",
	      if(SUBSTR(jumin,7,1)='2',"여자",
			if(SUBSTR(jumin,7,1)='3',"남자",
			if(SUBSTR(jumin,7,1)='4',"여자","")))) 성별
FROM student

SELECT NAME,jumin,
     if(SUBSTR(jumin,7,1) IN ('1','3'),"남자",
      if(SUBSTR(jumin,7,1) IN ('2','4'),"여자","")) 성별
FROM student
/*
  문제
  교수이름(name), 학과번호(deptno), 학과명 출력하기
  학과명 : 101=컴퓨터공학, 102=멀티미디어공학
           201=기계공학, 그외=그외학과
*/
SELECT NAME,deptno,
 if(deptno=101,"컴퓨터공학",
  if(deptno=102,"멀티미디어공학",
    if(deptno=201,"기계공학","그외학과"))) 학과명
FROM professor
/*
  case 조건문
   case 컬럼명 when 값1 then 문자열
              when 값2 then 문자열
              ...
              else 문자열 end
   case when 조건식1 then 문자열
        when 조건식2 then 문자열
        ...
        else 문자열 end	           
*/
/* case 구문으로 구현하기
교수이름(name), 학과번호(deptno), 학과명 출력하기
  학과명 : 101=컴퓨터공학, 102=멀티미디어공학
           201=기계공학, 그외=그외학과
*/
SELECT NAME, deptno,
     case deptno when 101 then "컴퓨터공학"
                 when 102 then "멀티미디어공학"
                 when 201 then "기계공학"
					  ELSE "그외학과" END 학과명
FROM professor	

-- 교수이름, 학과번호,대학명 출력하기
-- 대학명 : 101,102,201=공과대학, 그외는 그외대학 출력하기
-- if 함수
SELECT NAME, deptno, 
  if(deptno IN (101,102,201),"공과대학","그외대학") 대학명 
FROM professor
-- case 함수 : 오류발생
SELECT NAME, deptno,
   case deptno when 101,102,201 then "공과대학"
   ELSE "그외대학" END 대학명
FROM professor   
-- case 함수
SELECT NAME, deptno,
   case when deptno IN (101,102,201) then "공과대학"
   ELSE "그외대학" END 대학명
FROM professor

/*
  문제
  학생의 이름,주민번호,출생분기 출력하기
  출생분기 : 주민번호 기준
        1 ~ 3월 : 1분기
        4 ~ 6월 : 2분기
        7 ~ 9월 : 3분기
        10~12월 : 4분기
*/
SELECT NAME,jumin,
case 
when SUBSTR(jumin,3,2) BETWEEN '01' AND '03' then "1분기"
when SUBSTR(jumin,3,2) BETWEEN '04' AND '06' then "2분기"
when SUBSTR(jumin,3,2) BETWEEN '07' AND '09' then "3분기"
when SUBSTR(jumin,3,2) BETWEEN '10' AND '12' then "4분기"
ELSE "출생분기오류" END 출생분기
FROM student  
/*
  문제
  학생의 이름,생일(birthday),출생분기 출력하기
  출생분기 : 생일 기준
        1 ~ 3월 : 1분기
        4 ~ 6월 : 2분기
        7 ~ 9월 : 3분기
        10~12월 : 4분기
*/
SELECT NAME,birthday,
case
when MONTH(birthday) between 1 AND 3 then "1분기"
when MONTH(birthday) between 4 AND 6 then "2분기"
when MONTH(birthday) between 7 AND 9 then "3분기"
when MONTH(birthday) between 10 AND 12 then "4분기"
END 출생분기
FROM student


