-- 退费记录表（销售系统 / 教务系统共用同一 Supabase 项目）
-- 在 Supabase SQL Editor 执行，选 Run without RLS
CREATE TABLE IF NOT EXISTS refunds (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_name text,
  class_name text,
  total_payment numeric,               -- 原合计缴费
  book_fee numeric,                    -- 原书费（不退）
  course_hours numeric,                -- 原缴费课时数
  remaining_hours numeric,             -- 本次退费课时数
  refund_class_fee numeric,            -- 退课时费（自动算 = 退课时数 × 课单价，可改）
  refund_book_fee numeric DEFAULT 0,   -- 退书费（默认 0，不退）
  refund_date text,                    -- 退费日期 YYYY-MM-DD
  note text,
  created_at timestamptz DEFAULT now()
);
