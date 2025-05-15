create table goods
(
    id            int auto_increment
        primary key,
    name          varchar(100) not null,
    NormalPrice   int          not null,
    SurprisePrice int          not null,
    imageUrl      longtext     not null,
    description   varchar(255) not null,
    category      varchar(100) not null
);

create table orders
(
    id          int auto_increment
        primary key,
    userid      int      not null,
    order_code  bigint   not null,
    totalPrice  int      not null,
    create_time datetime not null
);

create table wn_caritem
(
    id     int auto_increment
        primary key,
    userid int    not null,
    goodid int    not null,
    num    int    not null,
    code   bigint null
);

create table wn_user
(
    id              int auto_increment
        primary key,
    account         varchar(100)                not null comment '�û��˺�',
    password        varchar(255)                not null comment '����',
    email           varchar(100)                null comment '��������',
    telphone        varchar(20)                 null comment '�ֻ�����',
    points          int            default 0    null comment '����',
    money           decimal(10, 2) default 0.00 null comment '�˻����',
    avatar          varchar(255)                null comment 'ͷ��·��',
    reg_time        datetime                    null comment 'ע��ʱ��',
    status          char           default 'Y'  null comment '״̬ Y-���� N-����',
    last_login_time datetime                    null comment '����¼ʱ��',
    last_login_ip   varchar(50)                 null comment '����¼IP',
    nickname        varchar(100)                not null,
    constraint uk_account
        unique (account)
);

create table wn_verification_code
(
    id          int auto_increment
        primary key,
    target      varchar(100)  not null comment '目标手机号或邮箱',
    code        varchar(20)   not null comment '验证码',
    create_time datetime      not null comment '创建时间',
    expire_time datetime      not null comment '过期时间',
    status      int default 0 null comment '状态：0-未使用 1-已使用 2-已过期'
)
    comment '验证码表';

