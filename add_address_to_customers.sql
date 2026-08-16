-- 销售系统：客户表新增「家庭住址」字段
-- 执行方式：登录 Supabase Dashboard → SQL Editor → New query → 粘贴执行
-- 项目 URL: https://chasxggorljjqqmficnh.supabase.co

ALTER TABLE public.customers
  ADD COLUMN IF NOT EXISTS address TEXT;

COMMENT ON COLUMN public.customers.address IS '家庭住址';
