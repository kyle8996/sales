-- DK邻里少儿英语 · 销售业务系统 v2 · 数据库升级
-- 请在 Supabase SQL Editor 中执行此文件

-- 1. customers 表添加 level 列
ALTER TABLE customers ADD COLUMN IF NOT EXISTS level TEXT DEFAULT 'B';

-- 2. followups 表添加新字段
ALTER TABLE followups ADD COLUMN IF NOT EXISTS need_reminder BOOLEAN DEFAULT false;
ALTER TABLE followups ADD COLUMN IF NOT EXISTS trial_invited BOOLEAN DEFAULT false;
ALTER TABLE followups ADD COLUMN IF NOT EXISTS trial_session_id BIGINT;

-- 3. 创建试听场次表
CREATE TABLE IF NOT EXISTS trial_sessions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title TEXT NOT NULL,
  session_date TEXT NOT NULL,
  start_time TEXT,
  end_time TEXT,
  max_capacity INT,
  class_type TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. 更新已有客户的状态为新的三状态
-- 已成交 → 已报名；已试听 → 已上门未报名；其他 → 未上门
UPDATE customers SET status = '已报名' WHERE status = '已成交';
UPDATE customers SET status = '已上门未报名' WHERE status = '已试听';
UPDATE customers SET status = '未上门' WHERE status NOT IN ('已报名', '已上门未报名');

-- 5. RLS 策略（新表）
ALTER TABLE trial_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all on trial_sessions" ON trial_sessions FOR ALL USING (true) WITH CHECK (true);

-- 6. 扩展现有 trial_schedule 表以支持新字段
ALTER TABLE trial_schedule ADD COLUMN IF NOT EXISTS trial_session_id BIGINT REFERENCES trial_sessions(id) ON DELETE SET NULL;
ALTER TABLE trial_schedule ADD COLUMN IF NOT EXISTS attended BOOLEAN DEFAULT false;

-- 7. 索引
CREATE INDEX IF NOT EXISTS idx_trial_sessions_date ON trial_sessions(session_date);
CREATE INDEX IF NOT EXISTS idx_trial_schedule_session ON trial_schedule(trial_session_id);
