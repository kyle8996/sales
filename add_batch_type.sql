-- 课时分成：给缴费批次表加「类型」字段（新招 / 续费）
-- 用于判断课时分成是否扣除 10% 招生提成（新招扣、续费不扣）
-- 在 Supabase SQL Editor 执行本文件后刷新系统即可生效。

ALTER TABLE revenue_batches ADD COLUMN IF NOT EXISTS batch_type text;

-- 回填历史数据：按来源自动归类
-- sales-new → 新招；sales-renewal → 续费；manual(手动) → 续费（可在缴费批次编辑弹窗手动改成新招）
UPDATE revenue_batches
SET batch_type = CASE
  WHEN source = 'sales-new' THEN '新招'
  WHEN source = 'sales-renewal' THEN '续费'
  ELSE '续费'
END
WHERE batch_type IS NULL;
