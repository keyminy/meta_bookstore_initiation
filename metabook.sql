--- <1> 객체 제거
------ [1-1] 테이블 제거(FK -> PK 순)
DROP TABLE cart CASCADE CONSTRAINTS;
DROP TABLE meta_order CASCADE CONSTRAINTS;
DROP TABLE stock CASCADE CONSTRAINTS;
DROP TABLE book CASCADE CONSTRAINTS;
DROP TABLE category CASCADE CONSTRAINTS;
DROP TABLE member CASCADE CONSTRAINTS;

------ [1-2] 시퀀스 제거(순서와 상관없음)
DROP SEQUENCE member_seq;
DROP SEQUENCE book_seq;
DROP SEQUENCE meta_order_seq;
DROP SEQUENCE cart_seq;
DROP SEQUENCE cate_seq;
DROP SEQUENCE stock_seq;

--- <2-1> 객체 테이블 생성(PK -> FK 순)
------ [2-1] member 회원 테이블 만들기
CREATE TABLE member (
	m_no  NUMBER        CONSTRAINT member_no_pk PRIMARY KEY, -- 회원번호
    id       VARCHAR2(30)  CONSTRAINT member_id_uq_nn UNIQUE NOT NULL,     -- 아이디
	password VARCHAR2(40) CONSTRAINT member_pw_nn NOT NULL, -- 비밀번호
	name     VARCHAR2(20) CONSTRAINT member_name_nn NOT NULL, -- 이름
	address  VARCHAR2(300) CONSTRAINT member_address_nn NOT NULL, -- 주소
	phone    VARCHAR2(13) CONSTRAINT member_phone_nn NOT NULL, -- 전화번호
	email    VARCHAR2(50) CONSTRAINT member_email_nn NOT NULL, -- 이메일
	status   VARCHAR2(6)  DEFAULT 'USER', -- 상태
	regDate  DATE  DEFAULT sysdate -- 가입일
);


------ [2-2] category 카테고리 테이블 만들기
CREATE TABLE category (
	cate_no   NUMBER  CONSTRAINT cate_no_pk PRIMARY KEY, -- 카테고리번호
	cate_name VARCHAR2(100) CONSTRAINT cate_name_nn NOT NULL  -- 카테고리이름
);

------ [2-3] book 책 테이블 만들기
CREATE TABLE book (
	book_no     NUMBER    CONSTRAINT book_no_pk PRIMARY KEY, -- 책번호
	title       VARCHAR2(300) CONSTRAINT book_title_nn NOT NULL, -- 제목
	author      VARCHAR2(60) CONSTRAINT book_author_nn NOT NULL, -- 작가
	pub         VARCHAR2(60) CONSTRAINT book_pub_nn NOT NULL, -- 출판사
	pubDate     DATE  DEFAULT sysdate, -- 출판일
	description VARCHAR2(3000) CONSTRAINT book_description_nn NOT NULL, -- 설명
	price       NUMBER  CONSTRAINT book_price_nn NOT NULL, -- 가격
	cate_no     NUMBER   NOT NULL 
    CONSTRAINT book_cateNo_fk REFERENCES category(cate_no)
    ON DELETE CASCADE-- 카테고리번호
);

------ [2-4] stock 재고 테이블 만들기
CREATE TABLE stock (
	stock_no NUMBER CONSTRAINT stock_no_pk PRIMARY KEY, -- 재고번호
	stock    NUMBER CONSTRAINT stock_nn NOT NULL,     -- 재고량
	book_no  NUMBER NOT NULL 
    CONSTRAINT stock_bookNo_fk REFERENCES book(book_no)
    ON DELETE CASCADE,     -- 책번호
	sold_cnt NUMBER DEFAULT 0      -- 판매수량
);

------ [2-5] order 주문 테이블 만들기
CREATE TABLE meta_order (
	order_no       NUMBER  CONSTRAINT order_no_pk PRIMARY KEY, -- 주문상품일련번호
	order_id       NUMBER  CONSTRAINT order_id_nn NOT NULL,     -- 주문번호
	m_no        NUMBER  NOT NULL 
    CONSTRAINT order_mNo_fk REFERENCES member(m_no)
    ON DELETE CASCADE,     -- 회원번호
	book_no        NUMBER  NOT NULL 
    CONSTRAINT order_bookNo_fk REFERENCES book(book_no)
    ON DELETE CASCADE,     -- 책번호
	order_qt       NUMBER  CONSTRAINT order_qt_nn NOT NULL,     -- 주문수량
	total_price    NUMBER  CONSTRAINT order_total_price_nn NOT NULL,     -- 총가격
	receiver_addr  VARCHAR2(3000) CONSTRAINT order_receiver_addr_nn NOT NULL,     -- 수령자주소
	receiver_phone VARCHAR2(13)   CONSTRAINT order_receiver_phone_nn NOT NULL,     -- 수령자전화번호
	receiver_name  VARCHAR2(30)   CONSTRAINT order_receiver_name_nn NOT NULL,     -- 수령자이름
	order_date     DATE  DEFAULT SYSDATE, -- 주문일
	order_status   VARCHAR2(100)  CONSTRAINT order_order_status_nn NOT NULL      -- 주문상태
);

------ [2-6] cart 장바구니 테이블 만들기
CREATE TABLE cart (
	cart_no          NUMBER CONSTRAINT cart_no_pk PRIMARY KEY, -- 장바구니번호
	m_no          NUMBER NOT NULL 
    CONSTRAINT cart_mNo_fk REFERENCES member(m_no)
    ON DELETE CASCADE,  -- 회원번호
	book_no          NUMBER NOT NULL 
    CONSTRAINT cart_bookNo_fk REFERENCES book(book_no)
    ON DELETE CASCADE,  -- 책번호
	cart_book_qt     NUMBER CONSTRAINT cart_book_qt_nn NOT NULL,     -- 책수량
	cart_total_price NUMBER CONSTRAINT cart_total_price NOT NULL      -- 총가격
);


------ <2-2> 시퀀스 만들기
CREATE SEQUENCE member_seq;
CREATE SEQUENCE cate_seq;
CREATE SEQUENCE book_seq;
CREATE SEQUENCE meta_order_seq;
CREATE SEQUENCE cart_seq;
CREATE SEQUENCE stock_seq;

--- <3> 샘플데이터 넣기(PK -> FK 순 : 있는 데이터만 입력가능한다.)
-- 관리자 넣기 테스트
INSERT INTO member(m_no,id,password, name, address, phone, email,status)
VALUES(member_seq.nextval,'admin','1234','관리자','서울','010-1234-5678','admin@test.com','ADMIN');

COMMIT;