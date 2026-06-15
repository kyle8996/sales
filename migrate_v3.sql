-- V3 Migration: 添加出生日期、报名日期、报名班级字段
ALTER TABLE customers ADD COLUMN IF NOT EXISTS birth_date TEXT;
ALTER TABLE customers ADD COLUMN IF NOT EXISTS enrollment_date TEXT;
ALTER TABLE customers ADD COLUMN IF NOT EXISTS enrolled_class TEXT;
