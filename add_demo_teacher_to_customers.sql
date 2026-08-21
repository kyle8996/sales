-- 为客户表新增 Demo 老师字段
-- 执行后，销售系统“新招学员”列表/筛选/编辑弹窗即可保存和显示 Demo 老师
ALTER TABLE public.customers
ADD COLUMN IF NOT EXISTS demo_teacher TEXT;
