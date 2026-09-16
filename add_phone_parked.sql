-- 客户管理「未留电话」分类：给 customers 表加 phone_parked 标记列
-- 在 Supabase SQL Editor 执行：
-- https://supabase.com/dashboard/project/chasxggorljjqqmficnh/sql
ALTER TABLE customers ADD COLUMN IF NOT EXISTS phone_parked boolean DEFAULT false;
