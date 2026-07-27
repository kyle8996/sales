-- revenue_batches v3 迁移：增加班级绑定字段
-- 用途：同一学员报名多个班级（如常规班 + 暑假班）时，可指定缴费批次仅适用于某个班级，
--      避免暑假班课时被常规班出勤消耗，反之亦然。
-- 说明：class_id 为空表示该批次为通用批次，所有班级出勤均可使用。

ALTER TABLE public.revenue_batches
  ADD COLUMN IF NOT EXISTS class_id INTEGER;

COMMENT ON COLUMN public.revenue_batches.class_id IS '缴费批次适用的班级 ID，NULL 表示通用（所有班级可用）';
