create table address
(
    id             int auto_increment
        primary key,
    user_id        int                  not null comment '用户ID',
    receiver       varchar(50)          not null comment '收件人姓名',
    phone          varchar(20)          not null comment '收件人手机号',
    province       varchar(50)          not null comment '省份',
    city           varchar(50)          not null comment '城市',
    district       varchar(50)          not null comment '区/县',
    detail_address varchar(255)         not null comment '详细地址',
    is_default     tinyint(1) default 0 not null comment '是否为默认地址',
    create_time    datetime             not null comment '创建时间',
    update_time    datetime             not null comment '更新时间'
)
    comment '用户收货地址表';

create index idx_user_id
    on address (user_id);

create table goods
(
    id            int auto_increment
        primary key,
    name          varchar(100)     not null,
    NormalPrice   int              not null,
    SurprisePrice int              not null,
    imageUrl      longtext         not null,
    description   varchar(255)     not null,
    category      varchar(100)     not null,
    stock         int default 1000 not null,
    is_out        tinyint(1)       not null
);

create table orders
(
    id          int auto_increment
        primary key,
    userid      int           not null,
    order_code  bigint        not null,
    totalPrice  int           not null,
    create_time datetime      not null,
    address_id  int           null comment '收货地址ID',
    receiver    varchar(50)   null comment '收件人姓名',
    phone       varchar(20)   null comment '收件人电话',
    address     varchar(255)  null comment '完整地址',
    payed       int default 0 not null
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

create table invoice
(
    id             int auto_increment
        primary key,
    user_id        int            not null,
    invoice_number bigint         not null,
    order_code     bigint         not null,
    title          varchar(100)   not null,
    tax_number     varchar(50)    null,
    amount         decimal(10, 2) not null,
    status         int default 0  null,
    create_time    datetime       null,
    update_time    datetime       null,
    constraint invoice_ibfk_1
        foreign key (user_id) references wn_user (id)
);

create index user_id
    on invoice (user_id);

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

