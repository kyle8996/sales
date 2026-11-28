-- 在读续费名单：支持直接编辑「家庭住址」
-- 在 Supabase Dashboard → SQL Editor 粘贴执行，一次即可；已有数据不受影响
-- SQL Editor: https://supabase.com/dashboard/project/chasxggorljjqqmficnh/sql
ALTER TABLE renewals ADD COLUMN IF NOT EXISTS address text;
