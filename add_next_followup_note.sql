-- 在 followups 表新增"下次跟进备注"字段
ALTER TABLE followups ADD COLUMN IF NOT EXISTS next_followup_note TEXT;
