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

def plot_results(folder):
    x = list(range(1, 21))
    seq_data = read_results(folder, "seq")
    par_data = read_results(folder, "par")

    plt.figure(figsize=(10,6))
    plt.plot(x, seq_data, marker='o', label='Sequential')
    plt.plot(x, par_data, marker='o', label='Parallel')
    plt.title(f"Performance in folder: {folder}")
    plt.xlabel("Number of tasks (N)")
    plt.ylabel("Average execution time (s)")
    plt.legend()
    plt.grid(True)
    plt.savefig(f"{folder}_performance.png")
    plt.show()

if __name__ == "__main__":
    folder = input("Enter folder name with results: ").strip()
    plot_results(folder)
