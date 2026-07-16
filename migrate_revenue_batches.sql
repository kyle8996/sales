-- 确收表：每个学员的缴费批次（FIFO 匹配课单价）
-- 2026-07-16 更新：支持「课时数、书费、合计缴费」三字段，课单价自动计算

-- 首次建表
CREATE TABLE IF NOT EXISTS public.revenue_batches (
  id BIGSERIAL PRIMARY KEY,
  student_id INTEGER NOT NULL,
  batch_order INTEGER NOT NULL DEFAULT 1,
  hours NUMERIC NOT NULL DEFAULT 0,
  book_fee NUMERIC NOT NULL DEFAULT 0,
  total_payment NUMERIC NOT NULL DEFAULT 0,
  unit_price NUMERIC NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (student_id, batch_order)
);

-- 若表已存在，补全新字段
ALTER TABLE public.revenue_batches
  ADD COLUMN IF NOT EXISTS book_fee NUMERIC NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_payment NUMERIC NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_revenue_batches_student ON public.revenue_batches(student_id);

COMMENT ON TABLE public.revenue_batches IS '销售系统确收表：学员缴费批次，按 batch_order 先进先出计算确收。课单价 = (合计缴费 - 书费) / 课时数';
