-- 在 Supabase SQL Editor 中执行以下 SQL，创建在读续费表
CREATE TABLE IF NOT EXISTS renewals (
  id BIGSERIAL PRIMARY KEY,
  payment_date TEXT,        -- 缴费日期
  student_name TEXT,        -- 姓名
  birth_date TEXT,          -- 出生日期
  phone TEXT,               -- 电话
  parent_name TEXT,         -- 家长姓名
  current_class TEXT,       -- 所在班级
  payment_package TEXT,     -- 缴费课时包
  course_hours NUMERIC DEFAULT 0,  -- 课时数
  book_fee NUMERIC DEFAULT 0,      -- 书费
  total_payment NUMERIC DEFAULT 0, -- 合计缴费
  unit_price NUMERIC DEFAULT 0,    -- 课单价
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 启用 RLS 并允许所有操作
ALTER TABLE renewals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all" ON renewals FOR ALL USING (true) WITH CHECK (true);
