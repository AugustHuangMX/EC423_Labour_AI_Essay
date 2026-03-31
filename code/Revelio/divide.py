"""将 user_id_list.txt 平均分成四份，保存为 1.txt ~ 4.txt"""

input_path = "/Users/huangminxing/Documents/EC423_Essay/clean/user_id_list.txt"
output_dir = "/Users/huangminxing/Documents/EC423_Essay/clean"

with open(input_path, "r") as f:
    lines = f.readlines()

n = len(lines)
chunk_size = n // 4
remainder = n % 4

start = 0
for i in range(1, 5):
    end = start + chunk_size + (1 if i <= remainder else 0)
    with open(f"{output_dir}/{i}.txt", "w") as f:
        f.writelines(lines[start:end])
    print(f"{i}.txt: {end - start} 行")
    start = end
