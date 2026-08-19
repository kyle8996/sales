-- 为 trial_sessions 表添加 Demo 老师字段
ALTER TABLE public.trial_sessions
ADD COLUMN IF NOT EXISTS teacher TEXT;

-- 可选：添加注释
COMMENT ON COLUMN public.trial_sessions.teacher IS 'Demo 老师名字，如 Dora / Cindy';
