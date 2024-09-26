###(INIT 시작)#########
# DB 세팅
DROP DATABASE IF EXISTS `SuWithMe`;
CREATE DATABASE `SuWithMe`;

USE `SuWithMe`;

# 게시글 테이블 생성
CREATE TABLE article (
    `id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `regDate` DATETIME NOT NULL,
    `updateDate` DATETIME NOT NULL,
    `memberId` INT(10) NOT NULL, 
    boardId INT(10) UNSIGNED NOT NULL,
    `title` VARCHAR(50) NOT NULL,
    `body` TEXT NOT NULL,
    hit INT UNSIGNED NOT NULL DEFAULT 0,
    `goodReactionPoint` INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `badReactionPoint` INT(10) UNSIGNED NOT NULL DEFAULT 0
);


# 회원 테이블 생성
CREATE TABLE `member`(
      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
      regDate DATETIME NOT NULL,
      updateDate DATETIME NOT NULL,
      loginId CHAR(30) NOT NULL,
      loginPw CHAR(100) NOT NULL,
      `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반,7=관리자)',
      `name` CHAR(20) NOT NULL,
      nickname CHAR(20) NOT NULL,
      cellphoneNum CHAR(20) NOT NULL,
      email CHAR(50) NOT NULL,
      delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
      delDate DATETIME COMMENT '탈퇴 날짜'
);

# 게시판(board) 테이블 생성
CREATE TABLE board (
      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
      regDate DATETIME NOT NULL,
      updateDate DATETIME NOT NULL,
      `code` CHAR(50) NOT NULL UNIQUE COMMENT 'notice(공지사항) free(자유) QnA(질의응답) ...',
      `name` CHAR(20) NOT NULL UNIQUE COMMENT '게시판 이름',
      delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
      delDate DATETIME COMMENT '삭제 날짜'
);

# 좋아요/싫어요 테이블 구현
# memberId : 어떤 회원이 눌렀는지, relId : 몇번에 눌렀는지, relTypeCode : 글인지 댓글인지, `point` : 좋아요(+)인지, 싫어요(-)인지
CREATE TABLE reactionPoint (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL,
    relId INT(10) UNSIGNED NOT NULL,
    `point` INT(10) NOT NULL
);

## 게시판(board) 테스트 데이터 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'NOTICE',
`name` = '통합 공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'FREE',
`name` = '통합 자유 게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'POOL',
`name` = '실내 수영 위드미 게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'BEACH',
`name` = '야외 수영 위드미 게시판';


-- 문자열 붙이기 + 랜덤 수 출력, 게시글 테스트 데이터 생성
INSERT INTO article
SET regDate = NOW(),
    updateDate = NOW(),
    memberId = CEILING(RAND() * 3),
    boardId = CEILING(RAND() * 4),
    title = CONCAT('제목', SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
    `body` = CONCAT('내용', SUBSTRING(RAND() * 1000 FROM 1 FOR 2));


## 회원 테스트 데이터 생성
## (관리자)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자',
cellphoneNum = '01012341234',
email = 'abc@gmail.com';

## (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '회원1_이름',
nickname = '회원1_닉네임',
cellphoneNum = '01043214321',
email = 'abcd@gmail.com';

## (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '회원2_이름',
nickname = '회원2_닉네임',
cellphoneNum = '01056785678',
email = 'abcde@gmail.com';

## (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test3',
loginPw = 'test3',
`name` = '회원3_이름',
nickname = '회원3_닉네임',
cellphoneNum = '01065656565',
email = 'goast@gmail.com';

### 좋아요/싫어요 테이블 테스트 데이터 생성

# 1번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = -1;

# 3번 회원이 1번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;

## update join -> 기존 게시글의 good bad RP 값을 RP 테이블에서 추출해서 article 테이블에 채운다.
UPDATE article AS A
INNER JOIN (
    SELECT RP.relTypeCode, RP.relId,
        SUM(IF(RP.`point` > 0, RP.`point`, 0)) AS goodReactionPoint,
        SUM(IF(RP.`point` < 0, RP.`point` * -1, 0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON A.id = RP_SUM.relId
SET A.goodReactionPoint = RP_SUM.goodReactionPoint,
A.badReactionPoint = RP_SUM.badReactionPoint;


# reply 테이블 생성
CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
    relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
    `body`TEXT NOT NULL
);

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 1';

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 2';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 3';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`body` = '댓글 4';


# reply 테이블에 좋아요 관련 컬럼 추가
ALTER TABLE reply ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE reply ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# reactionPoint 테스트 데이터 생성
# 1번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 1번 회원이 2번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 2,
`point` = 1;

# 2번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 2번 회원이 2번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 2,
`point` = -1;

# 3번 회원이 1번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'reply',
relId = 1,
`point` = 1;

# update join -> 기존 게시물의 good,bad RP 값을 RP 테이블에서 가져온 데이터로 채운다
UPDATE reply AS R
INNER JOIN (
    SELECT RP.relTypeCode,RP.relId,
    SUM(IF(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
    SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON R.id = RP_SUM.relId
SET R.goodReactionPoint = RP_SUM.goodReactionPoint,
R.badReactionPoint = RP_SUM.badReactionPoint;


# 기존의 회원 비번을 암호화
UPDATE `member`
SET loginPw = SHA2(loginPw,256);

###(INIT 끝)
##########################################
###(프로젝트 고유 테이블 관련)

## 수영장 정보 테이블 생성
CREATE TABLE pool (
    id INT PRIMARY KEY,		-- 번호
    statusCode VARCHAR(10) DEFAULT NULL,	-- 영업상태구분코드
    statusName VARCHAR(50) DEFAULT NULL,	-- 영업상태명
    detailStatusCode VARCHAR(10) DEFAULT NULL,	-- 상세영업상태코드
    detailStatusName VARCHAR(50) DEFAULT NULL,	-- 상세영업상태명
    suspensionStartDate DATE DEFAULT NULL,	-- 휴업시작일자
    suspensionEndDate DATE DEFAULT NULL,		-- 휴업종료일자
    callNumber VARCHAR(20) DEFAULT NULL,	-- 소재지전화
    postalCodeLocation VARCHAR(255) DEFAULT NULL,	-- 소재지우편번호
    postalCodeStreet TEXT(255) DEFAULT NULL,	-- 도로명우편번호
    addressLocation TEXT DEFAULT NULL,		-- 소재지전체주소
    addressStreet TEXT DEFAULT NULL,		-- 도로명전체주소
    `name` TEXT DEFAULT NULL,			-- 사업장명
    latitude VARCHAR(20) DEFAULT NULL,		-- 좌표정보(x)
    longitude VARCHAR(20) DEFAULT NULL	-- 좌표정보(y)
);

SELECT * FROM pool;

SELECT * 
FROM pool
WHERE 1
AND latitude IS NOT NULL AND latitude != ''
AND longitude IS NOT NULL AND longitude != ''
AND statusCode = 1;

SELECT id, `name`, latitude, longitude FROM pool;

-- 1015개 : 정상 그 외 비정상
SELECT COUNT(*) FROM pool;

-- 930개
SELECT COUNT(*)
FROM pool
WHERE 1
AND latitude IS NOT NULL AND latitude != ''
AND longitude IS NOT NULL AND longitude != ''
AND statusCode = 1;

SELECT * 
FROM pool
WHERE 1
AND latitude IS NOT NULL AND latitude != ''
AND longitude IS NOT NULL AND longitude != ''
AND statusCode = 1
AND `name` LIKE '%인피니티풀%';

SELECT * FROM pool WHERE `name` LIKE '%삼부%';

SELECT `name`, postalCodeStreet	, addressLocation
FROM pool WHERE `name` LIKE '%로키 스위밍 클럽%';


-- 테스트데이터 5개
-- 삼부스포렉스
SELECT `name`, latitude, longitude FROM pool WHERE `name` LIKE '%삼부%';
-- 스위밍키즈 도안관저점
SELECT `name`, latitude, longitude FROM pool WHERE `name` LIKE '%스위밍키즈 도안관저점%';
-- 프렌즈 아쿠아 키즈풀
SELECT `name`, latitude, longitude FROM pool WHERE `name` LIKE '%프렌즈 아쿠아 키즈풀%';
-- 로키 스위밍 클럽
SELECT `name`, latitude, longitude FROM pool WHERE `name` LIKE '%로키 스위밍 클럽%';
-- 아쿠아 차일드
SELECT `name`, latitude, longitude FROM pool WHERE `name` LIKE '%아쿠아 차일드';

## 수영 일정 테이블 생성
CREATE TABLE `event` (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 일정 고유 ID
    title VARCHAR(255) NOT NULL,        -- 일정 제목
    `body` TEXT,                        -- 일정 설명
    createDate DATETIME NOT NULL,       -- 일정 생성 시각
    updateDate DATETIME NOT NULL,       -- 일정 수정 시각
    startDate DATE NOT NULL,        -- 일정 시작 날짜와 시간
    endDate DATE,                   -- 일정 종료 날짜와 시간 (없을 경우 NULL)
    completed BOOLEAN DEFAULT FALSE,    -- 일정 완료 여부 (오수완 체크용)
    memberId INT                          -- 일정 작성자의 사용자 ID (FK)
);

-- 캘린더 테스트 데이터 생성
INSERT INTO `event`
SET title = CONCAT('일정 제목', SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
    `body` = CONCAT('일정 내용', SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
    createDate = NOW(),
    updateDate = NOW(),
    startDate = NOW(),
    endDate = NOW(),
    memberId = 2;
    
SELECT * FROM `event`;

SELECT * FROM `member`;

-- 테스트 데이터 조회
SELECT  M.loginId, E.*
FROM `event` E
INNER JOIN `member` M
ON M.id = E.memberId;

SELECT E.*, M.nickname
FROM `event` E
INNER JOIN `member` M
ON M.id = E.memberId;


## 해수욕장 정보 테이블 생성
CREATE TABLE beach (
    id INT PRIMARY KEY,		-- 번호
    `name` TEXT DEFAULT NULL,			-- 해수욕장명
    nx INT DEFAULT 0,			-- nx 값
    ny INT DEFAULT 0,			-- ny 값
    latitude VARCHAR(20) DEFAULT NULL,		-- 위도
    longitude VARCHAR(20) DEFAULT NULL	-- 경도
);

SELECT * FROM beach;

-- 정상 데이터 : 420개
SELECT COUNT(*) FROM beach;

###(INIT 끝)
##########################################

## 게시글 테스트 데이터 대량 생성
INSERT INTO article
(
    regDate, updateDate, memberId, boardId, title, `body`
)
SELECT NOW(), NOW(), FLOOR(RAND() * 2) + 2, CEILING(RAND() * 4), CONCAT('제목__', RAND()), CONCAT('내용__', RAND())
FROM article;

##########################################

SHOW TABLES;

SELECT *
FROM article
ORDER BY id DESC;

SELECT *
FROM `member`;

SELECT *
FROM `board`;

SELECT *
FROM reactionPoint;

SELECT * 
FROM `reply`;


SELECT A.* , M.nickname AS extra__writer
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
WHERE A.id = 1;

# LEFT JOIN
SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

# 서브쿼리
SELECT A.*, 
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(IF(RP.point > 0,RP.point,0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0,RP.point,0)),0) AS extra__badReactionPoint
FROM (
    SELECT A.*, M.nickname AS extra__writer 
    FROM article AS A
    INNER JOIN `member` AS M
    ON A.memberId = M.id) AS A
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

# JOIN
SELECT A.*, M.nickname AS extra__writer,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(IF(RP.point > 0,RP.point,0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0,RP.point,0)),0) AS extra__badReactionPoint
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

SELECT IFNULL(SUM(RP.point),0)
FROM reactionPoint AS RP
WHERE RP.relTypeCode = 'article'
AND RP.relId = 3
AND RP.memberId = 2;


SELECT R.*, M.nickname AS extra__writer
FROM reply AS R
INNER JOIN `member` AS M
ON R.memberId = M.id
WHERE relTypeCode = 'article'
AND relId = 2
ORDER BY R.id ASC;

SELECT A.*, M.nickname AS extra__writer, IFNULL(COUNT(R.id),0) AS extra__repliesCount
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN `reply` AS R
ON A.id = R.relId
GROUP BY A.id;

-- 코멘트 포함해서 `member` 테이블의 정보 보기
SHOW FULL COLUMNS FROM `member`;

-- 마지막에 추가된 데이터의 아이디
SELECT LAST_INSERT_ID();

-- 1부터 100까지 랜덤 수
SELECT CEILING(RAND() * 100);