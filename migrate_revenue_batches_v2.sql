-- 确收表：缴费批次增加缴费日期和来源标记
-- 2026-07-27 更新：支持从销售系统（新招学员/在读续费）自动同步，同时保留手动录入的批次

ALTER TABLE public.revenue_batches
  ADD COLUMN IF NOT EXISTS payment_date TEXT,
  ADD COLUMN IF NOT EXISTS source TEXT;

COMMENT ON COLUMN public.revenue_batches.payment_date IS '缴费日期（YYYY-MM-DD 或特殊标记：年前缴费）';
COMMENT ON COLUMN public.revenue_batches.source IS '批次来源：sales-new（新招学员）、sales-renewal（在读续费）、manual（手动编辑）';
