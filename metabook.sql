--- <1> ��ü ����
------ [1-1] ���̺� ����(FK -> PK ��)
DROP TABLE cart CASCADE CONSTRAINTS;
DROP TABLE meta_order CASCADE CONSTRAINTS;
DROP TABLE stock CASCADE CONSTRAINTS;
DROP TABLE book CASCADE CONSTRAINTS;
DROP TABLE category CASCADE CONSTRAINTS;
DROP TABLE member CASCADE CONSTRAINTS;

------ [1-2] ������ ����(������ �������)
DROP SEQUENCE member_seq;
DROP SEQUENCE book_seq;
DROP SEQUENCE meta_order_seq;
DROP SEQUENCE cart_seq;
DROP SEQUENCE cate_seq;
DROP SEQUENCE stock_seq;

--- <2-1> ��ü ���̺� ����(PK -> FK ��)
------ [2-1] member ȸ�� ���̺� �����
CREATE TABLE member (
	m_no  NUMBER        CONSTRAINT member_no_pk PRIMARY KEY, -- ȸ����ȣ
    id       VARCHAR2(30)  CONSTRAINT member_id_uq_nn UNIQUE NOT NULL,     -- ���̵�
	password VARCHAR2(40) CONSTRAINT member_pw_nn NOT NULL, -- ��й�ȣ
	name     VARCHAR2(20) CONSTRAINT member_name_nn NOT NULL, -- �̸�
	address  VARCHAR2(300) CONSTRAINT member_address_nn NOT NULL, -- �ּ�
	phone    VARCHAR2(13) CONSTRAINT member_phone_nn NOT NULL, -- ��ȭ��ȣ
	email    VARCHAR2(50) CONSTRAINT member_email_nn NOT NULL, -- �̸���
	status   VARCHAR2(6)  DEFAULT 'USER', -- ����
	regDate  DATE  DEFAULT sysdate -- ������
);


------ [2-2] category ī�װ� ���̺� �����
CREATE TABLE category (
	cate_no   NUMBER  CONSTRAINT cate_no_pk PRIMARY KEY, -- ī�װ���ȣ
	cate_name VARCHAR2(100) CONSTRAINT cate_name_nn NOT NULL  -- ī�װ��̸�
);

------ [2-3] book å ���̺� �����
CREATE TABLE book (
	book_no     NUMBER    CONSTRAINT book_no_pk PRIMARY KEY, -- å��ȣ
	title       VARCHAR2(300) CONSTRAINT book_title_nn NOT NULL, -- ����
	author      VARCHAR2(60) CONSTRAINT book_author_nn NOT NULL, -- �۰�
	pub         VARCHAR2(60) CONSTRAINT book_pub_nn NOT NULL, -- ���ǻ�
	pubDate     DATE  DEFAULT sysdate, -- ������
	description VARCHAR2(3000) CONSTRAINT book_description_nn NOT NULL, -- ����
	price       NUMBER  CONSTRAINT book_price_nn NOT NULL, -- ����
	cate_no     NUMBER   NOT NULL 
    CONSTRAINT book_cateNo_fk REFERENCES category(cate_no)
    ON DELETE CASCADE-- ī�װ���ȣ
);

------ [2-4] stock ��� ���̺� �����
CREATE TABLE stock (
	stock_no NUMBER CONSTRAINT stock_no_pk PRIMARY KEY, -- ����ȣ
	stock    NUMBER CONSTRAINT stock_nn NOT NULL,     -- ���
	book_no  NUMBER NOT NULL 
    CONSTRAINT stock_bookNo_fk REFERENCES book(book_no)
    ON DELETE CASCADE,     -- å��ȣ
	sold_cnt NUMBER DEFAULT 0      -- �Ǹż���
);

------ [2-5] order �ֹ� ���̺� �����
CREATE TABLE meta_order (
	order_no       NUMBER  CONSTRAINT order_no_pk PRIMARY KEY, -- �ֹ���ǰ�Ϸù�ȣ
	order_id       NUMBER  CONSTRAINT order_id_nn NOT NULL,     -- �ֹ���ȣ
	m_no        NUMBER  NOT NULL 
    CONSTRAINT order_mNo_fk REFERENCES member(m_no)
    ON DELETE CASCADE,     -- ȸ����ȣ
	book_no        NUMBER  NOT NULL 
    CONSTRAINT order_bookNo_fk REFERENCES book(book_no)
    ON DELETE CASCADE,     -- å��ȣ
	order_qt       NUMBER  CONSTRAINT order_qt_nn NOT NULL,     -- �ֹ�����
	total_price    NUMBER  CONSTRAINT order_total_price_nn NOT NULL,     -- �Ѱ���
	receiver_addr  VARCHAR2(3000) CONSTRAINT order_receiver_addr_nn NOT NULL,     -- �������ּ�
	receiver_phone VARCHAR2(13)   CONSTRAINT order_receiver_phone_nn NOT NULL,     -- ��������ȭ��ȣ
	receiver_name  VARCHAR2(30)   CONSTRAINT order_receiver_name_nn NOT NULL,     -- �������̸�
	order_date     DATE  DEFAULT SYSDATE, -- �ֹ���
	order_status   VARCHAR2(100)  CONSTRAINT order_order_status_nn NOT NULL      -- �ֹ�����
);

------ [2-6] cart ��ٱ��� ���̺� �����
CREATE TABLE cart (
	cart_no          NUMBER CONSTRAINT cart_no_pk PRIMARY KEY, -- ��ٱ��Ϲ�ȣ
	m_no          NUMBER NOT NULL 
    CONSTRAINT cart_mNo_fk REFERENCES member(m_no)
    ON DELETE CASCADE,  -- ȸ����ȣ
	book_no          NUMBER NOT NULL 
    CONSTRAINT cart_bookNo_fk REFERENCES book(book_no)
    ON DELETE CASCADE,  -- å��ȣ
	cart_book_qt     NUMBER CONSTRAINT cart_book_qt_nn NOT NULL,     -- å����
	cart_total_price NUMBER CONSTRAINT cart_total_price NOT NULL      -- �Ѱ���
);


------ <2-2> ������ �����
CREATE SEQUENCE member_seq;
CREATE SEQUENCE cate_seq;
CREATE SEQUENCE book_seq;
CREATE SEQUENCE meta_order_seq;
CREATE SEQUENCE cart_seq;
CREATE SEQUENCE stock_seq;

--- <3> ���õ����� �ֱ�(PK -> FK �� : �ִ� �����͸� �Է°����Ѵ�.)
-- ������ �ֱ� �׽�Ʈ
INSERT INTO member(m_no,id,password, name, address, phone, email,status)
VALUES(member_seq.nextval,'admin','1234','������','����','010-1234-5678','admin@test.com','ADMIN');

COMMIT;