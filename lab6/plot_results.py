import matplotlib.pyplot as plt
import os

def read_results(folder, mode):
    means = []
    for n in range(1, 21):
        filename = os.path.join(folder, f"results_{mode}_{n}.txt")
        try:
            with open(filename) as f:
                times = [float(line.strip()) for line in f if line.strip()]
                mean_time = sum(times) / len(times) if times else 0
                means.append(mean_time)
        except FileNotFoundError:
            print(f"File not found: {filename}")
            means.append(0)
    return means

def plot_cpu_comparison(folder, cpu_label):
    x = list(range(1, 21))
    seq = read_results(folder, "seq")
    par = read_results(folder, "par")

    plt.figure(figsize=(10, 6))
    plt.plot(x, seq, marker='o', label='Sequential')
    plt.plot(x, par, marker='o', label='Parallel')
    plt.title(f"CPU {cpu_label}: Sequential vs Parallel")
    plt.xlabel("Number of Tasks (N)")
    plt.ylabel("Average Execution Time (s)")
    plt.legend()
    plt.grid(True)
    plt.savefig(f"cpu_{cpu_label}_comparison.png")
    plt.show()

if __name__ == "__main__":
    folder_1cpu = input("Введите папку с результатами для 1 ядра: ").strip()
    folder_2cpu = input("Введите папку с результатами для 2 ядер: ").strip()

    print("\n--- График для 1 ядра ---")
    plot_cpu_comparison(folder_1cpu, "1")

    print("\n--- График для 2 ядер ---")
    plot_cpu_comparison(folder_2cpu, "2")
