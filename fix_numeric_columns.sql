-- 修复销售系统 customers / renewals 表数值字段无法保存小数的问题
-- 典型报错：invalid input syntax for type integer: "31.5"
-- 在 Supabase SQL Editor 执行，选 Run without RLS

-- customers 表：课时数、书费、合计缴费、课单价改为 numeric
ALTER TABLE customers ALTER COLUMN course_hours TYPE numeric USING (course_hours::numeric);
ALTER TABLE customers ALTER COLUMN book_fee TYPE numeric USING (book_fee::numeric);
ALTER TABLE customers ALTER COLUMN total_payment TYPE numeric USING (total_payment::numeric);
ALTER TABLE customers ALTER COLUMN unit_price TYPE numeric USING (unit_price::numeric);

-- renewals 表：同步改为 numeric
ALTER TABLE renewals ALTER COLUMN course_hours TYPE numeric USING (course_hours::numeric);
ALTER TABLE renewals ALTER COLUMN book_fee TYPE numeric USING (book_fee::numeric);
ALTER TABLE renewals ALTER COLUMN total_payment TYPE numeric USING (total_payment::numeric);
ALTER TABLE renewals ALTER COLUMN unit_price TYPE numeric USING (unit_price::numeric);
