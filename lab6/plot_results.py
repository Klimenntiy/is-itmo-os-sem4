import matplotlib.pyplot as plt

def read_results(folder, mode):
    means = []
    for n in range(1, 21):
        if folder.lower() == "disk":
            filename = f"results_disk_{mode}_{n}.txt"
        else:
            filename = f"results_{mode}_{n}.txt"
        filepath = f"{folder}/{filename}"

        try:
            with open(filepath) as f:
                times = [float(line.strip()) for line in f if line.strip()]
                mean_time = sum(times) / len(times) if times else 0
                print(f"Read {len(times)} entries from {filepath}, mean = {mean_time}")
                means.append(mean_time)
        except FileNotFoundError:
            print(f"File not found: {filepath}")
            means.append(0)
    return means

x = list(range(1, 21))

cpu_seq = read_results("CPU", "seq")
cpu_par = read_results("CPU", "par")
disk_seq = read_results("Disk", "seq")
disk_par = read_results("Disk", "par")

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
