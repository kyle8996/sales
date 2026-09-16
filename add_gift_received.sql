-- 销售系统：新增「是否领取报名礼物」字段
-- 用途：新招学员 / 在读续费两张表，在「课单价」列后新增一列下拉（是/否）
-- 执行位置：Supabase Dashboard → SQL Editor（chasxggorljjqqmficnh 项目）
-- 注意：本项目的 /rest/v1/sql 端点未开放，DDL 必须在此手动执行

ALTER TABLE customers ADD COLUMN IF NOT EXISTS gift_received text DEFAULT '否';
ALTER TABLE renewals ADD COLUMN IF NOT EXISTS gift_received text DEFAULT '否';
