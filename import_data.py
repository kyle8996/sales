"""
DK邻里少儿英语 · Excel数据导入脚本
将私域客户登记表导入 Supabase customers 表
运行前请先在 Supabase SQL Editor 执行 setup.sql
"""
import openpyxl, requests, json, sys

SB_URL = 'https://chasxggorljjqqmficnh.supabase.co'
SB_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoYXN4Z2dvcmxqanFxbWZpY25oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MDI1NzIsImV4cCI6MjA5NzA3ODU3Mn0.E0xlNCX_jFn8X9LheAR3jFHokzWSkZlXkBDReqTvL6c'
HEADERS = {'apikey': SB_KEY, 'Authorization': f'Bearer {SB_KEY}', 'Content-Type': 'application/json', 'Prefer': 'return=minimal'}

# 状态映射
STATUS_MAP = {
    '已报名': '已成交',
    '已上门未缴费': '已试听',
    'C': '已流失',
}

def parse_row(row):
    """将 Excel 行转换为客户数据"""
    # 私域客户登记表 列: 序号, 咨询日期, 学员姓名, 年龄, 年级, 学校, 家长, 电话, 来源, 状态, 咨询记录, 跟进人, 备注, 试听时间
    name = str(row[2]).strip() if row[2] else ''
    if not name or name == '学员姓名':
        return None
    
    raw_status = str(row[9]).strip() if row[9] else ''
    status = STATUS_MAP.get(raw_status, '新线索')
    if raw_status == '已成交' or raw_status == '已报名':
        status = '已成交'
    elif raw_status in ('已上门未缴费',):
        status = '已试听'
    elif raw_status in ('C', '已流失'):
        status = '已流失'
    
    phone = str(int(row[7])) if isinstance(row[7], float) and row[7] > 99999 else (str(row[7]) if row[7] else '')
    if '没有电话' in phone or phone == 'None':
        phone = ''
    
    source = str(row[8]).strip() if row[8] else ''
    notes = str(row[10]).strip() if row[10] else ''
    tags_str = str(row[12]).strip() if row[12] else ''
    trial_date = str(row[13]).strip() if row[13] else ''
    owner = str(row[11]).strip() if row[11] else 'Kyle'
    
    # 合并备注和咨询记录
    full_notes = notes
    if notes and notes != 'None':
        full_notes = notes
    if notes and notes != 'None' and tags_str and tags_str != 'None':
        full_notes = notes + ' | 标签: ' + tags_str
    
    return {
        'name': name,
        'age': str(row[3]).strip() if row[3] and str(row[3]).strip() != 'None' else '',
        'grade': str(row[4]).strip() if row[4] and str(row[4]).strip() != 'None' else '',
        'school': str(row[5]).strip() if row[5] and str(row[5]).strip() != 'None' else '',
        'parent': str(row[6]).strip() if row[6] and str(row[6]).strip() != 'None' else '',
        'phone': phone,
        'source': source if source != 'None' else '',
        'status': status,
        'trial_date': trial_date if trial_date != 'None' else '',
        'owner': owner if owner and owner != 'None' else 'Kyle',
        'notes': str(row[10]).strip() if row[10] and str(row[10]).strip() != 'None' else '',
        'tags': tags_str if tags_str != 'None' else '',
    }

def main():
    wb = openpyxl.load_workbook('C:/Users/刘新/Desktop/DK邻里少儿中心-客户信息登记表.xlsx')
    ws = wb['私域客户登记表']
    
    customers = []
    for row in ws.iter_rows(min_row=2, values_only=True):
        data = parse_row(row)
        if data:
            customers.append(data)
    
    print(f'解析到 {len(customers)} 条客户数据')
    
    # 统计
    statuses = {}
    for c in customers:
        statuses[c['status']] = statuses.get(c['status'], 0) + 1
    print('状态分布:', statuses)
    
    # 先测试插入一条
    test = requests.post(f'{SB_URL}/rest/v1/customers', headers=HEADERS, json=customers[0])
    print(f'测试插入: {test.status_code}')
    if test.status_code >= 400:
        print(f'错误: {test.text}')
        print('\n请先在 Supabase SQL Editor 中执行 setup.sql！')
        print('1. 打开 https://supabase.com/dashboard/project/chasxggorljjqqmficnh')
        print('2. 点击左侧 "SQL Editor"')
        print('3. 粘贴 setup.sql 内容并执行')
        return
    
    # 批量插入
    batch = []
    success = 0
    for i, c in enumerate(customers):
        batch.append(c)
        if len(batch) >= 10:
            r = requests.post(f'{SB_URL}/rest/v1/customers', headers=HEADERS, json=batch)
            if r.status_code < 400:
                success += len(batch)
                print(f'已导入 {success}/{len(customers)}')
            else:
                print(f'批次失败: {r.status_code} {r.text[:200]}')
            batch = []
    
    # 最后一批
    if batch:
        r = requests.post(f'{SB_URL}/rest/v1/customers', headers=HEADERS, json=batch)
        if r.status_code < 400:
            success += len(batch)
    
    print(f'\n导入完成！成功 {success}/{len(customers)} 条')

if __name__ == '__main__':
    main()
