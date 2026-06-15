-- DK邻里少儿英语 · 销售业务系统 · 数据库初始化
-- 请在 Supabase SQL Editor 中执行此文件

-- 1. 客户表
CREATE TABLE IF NOT EXISTS customers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  age TEXT,
  grade TEXT,
  school TEXT,
  parent TEXT,
  phone TEXT,
  source TEXT,
  status TEXT DEFAULT '新线索',
  trial_date TEXT,
  owner TEXT,
  notes TEXT,
  tags TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 跟进记录表
CREATE TABLE IF NOT EXISTS followups (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id BIGINT REFERENCES customers(id) ON DELETE CASCADE,
  content TEXT,
  next_step TEXT,
  reminder_date TEXT,
  owner TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. 试听排期表
CREATE TABLE IF NOT EXISTS trial_schedule (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id BIGINT REFERENCES customers(id) ON DELETE CASCADE,
  week_start TEXT NOT NULL,
  day_of_week INT,
  time_slot TEXT,
  class_type TEXT,
  status TEXT DEFAULT '已预约',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_customers_status ON customers(status);
CREATE INDEX IF NOT EXISTS idx_customers_owner ON customers(owner);
CREATE INDEX IF NOT EXISTS idx_customers_source ON customers(source);
CREATE INDEX IF NOT EXISTS idx_followups_customer ON followups(customer_id);
CREATE INDEX IF NOT EXISTS idx_followups_reminder ON followups(reminder_date);
CREATE INDEX IF NOT EXISTS idx_trial_week ON trial_schedule(week_start);

-- RLS 策略（允许 anon 全部操作）
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE followups ENABLE ROW LEVEL SECURITY;
ALTER TABLE trial_schedule ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all on customers" ON customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on followups" ON followups FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on trial_schedule" ON trial_schedule FOR ALL USING (true) WITH CHECK (true);
