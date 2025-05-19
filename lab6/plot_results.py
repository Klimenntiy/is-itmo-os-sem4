import matplotlib.pyplot as plt

def read_results(prefix, folder, mode):
    means = []
    for n in range(1, 21):
        # Формируем имя файла по шаблону
        # Если папка Disk — добавляем 'disk' в имя
        if folder.lower() == "disk":
            filename = f"{prefix}_disk_{mode}_{n}.txt"
        else:
            filename = f"{prefix}_{mode}_{n}.txt"
        filepath = f"{folder}/{filename}"

        try:
            with open(filepath) as f:
                times = [float(line.strip()) for line in f.readlines() if line.strip()]
                mean_time = sum(times) / len(times) if times else 0
                print(f"Read {len(times)} entries from {filepath}, mean = {mean_time}")
                means.append(mean_time)
        except FileNotFoundError:
            print(f"File not found: {filepath}")
            means.append(0)
    return means

x = list(range(1, 21))

cpu_seq = read_results("result", "CPU", "seq")
cpu_par = read_results("result", "CPU", "par")
disk_seq = read_results("result", "Disk", "seq")
disk_par = read_results("result", "Disk", "par")

plt.figure(figsize=(12, 8))
plt.plot(x, cpu_seq, label="CPU Sequential")
plt.plot(x, cpu_par, label="CPU Parallel")
plt.plot(x, disk_seq, label="Disk Sequential")
plt.plot(x, disk_par, label="Disk Parallel")

plt.xlabel("Number of Tasks (N)")
plt.ylabel("Average Time (s)")
plt.title("Performance Comparison")
plt.legend()
plt.grid(True)
plt.savefig("performance_graphs.png")
plt.show()
