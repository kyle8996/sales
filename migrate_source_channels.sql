-- 客户来源拆分为一级/二级渠道
-- 请在 Supabase SQL Editor 中执行此脚本
-- https://supabase.com/dashboard/project/chasxggorljjqqmficnh/sql/new

-- 1. 新增一级渠道和二级渠道列
ALTER TABLE customers ADD COLUMN IF NOT EXISTS source_primary TEXT;
ALTER TABLE customers ADD COLUMN IF NOT EXISTS source_secondary TEXT;

-- 2. 将现有来源数据迁移到二级渠道
UPDATE customers SET source_secondary = source WHERE source IS NOT NULL AND source != '';
