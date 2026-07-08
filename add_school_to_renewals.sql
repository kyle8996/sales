-- ============================================================
-- 在读续费表增加「所在学校」字段
-- ============================================================

-- 1. 添加字段
ALTER TABLE renewals ADD COLUMN IF NOT EXISTS school TEXT;

-- 2. 根据客户信息回填已有续费记录的学校
UPDATE renewals r
SET school = c.school
FROM customers c
WHERE r.phone = c.phone
  AND c.school IS NOT NULL
  AND c.school <> ''
  AND (r.school IS NULL OR r.school = '');

-- 3. 验证
SELECT student_name, phone, school, current_class FROM renewals LIMIT 20;
