import matplotlib.pyplot as plt

def read_results(prefix, mode):
    means = []
    for n in range(1, 21):
        try:
            with open(f"{prefix}_{mode}_{n}.txt") as f:
                times = [float(line.strip()) for line in f.readlines()]
                means.append(sum(times) / len(times))
        except FileNotFoundError:
            means.append(0)
    return means

x = list(range(1, 21))
cpu_seq = read_results("results", "seq")
cpu_par = read_results("results", "par")
disk_seq = read_results("results_disk", "seq")
disk_par = read_results("results_disk", "par")

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
