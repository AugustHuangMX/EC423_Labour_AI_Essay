import pandas as pd
import os

# 合并 jobpostings2019 到 jobpostings2025
years = range(2019, 2026)
dfs = []

for year in years:
    filename = f"/Users/huangminxing/Documents/EC423_Essay/raw/jobpostings{year}.csv"
    if os.path.exists(filename):
        df = pd.read_csv(filename)
        df['year'] = year  # 可选：添加年份列
        dfs.append(df)
        print(f"✅ 已加载 {filename}，共 {len(df)} 行")
    else:
        print(f"⚠️  文件不存在，跳过：{filename}")

if dfs:
    combined = pd.concat(dfs, ignore_index=True)
    output_file = "/Users/huangminxing/Documents/EC423_Essay/jobpostings_2019_2025.csv"
    combined.to_csv(output_file, index=False)
    print(f"\n✅ 合并完成！共 {len(combined)} 行，已保存至 {output_file}")
else:
    print("❌ 没有找到任何文件，请检查路径。")