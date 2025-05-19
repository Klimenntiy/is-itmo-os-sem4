import matplotlib.pyplot as plt

def read_results(folder, mode):
    means = []
    for n in range(1, 21):
        filename = f"{folder}/results_{mode}_{n}.txt"
        try:
            with open(filename) as f:
                times = [float(line.strip()) for line in f if line.strip()]
                mean_time = sum(times) / len(times) if times else 0
                means.append(mean_time)
        except FileNotFoundError:
            print(f"File not found: {filename}")
            means.append(0)
    return means

def plot_mode(mode_name):
    x = list(range(1, 21))

    folder_1cpu = "CPU_1"
    folder_2cpu = "CPU_2"

    data_1cpu = read_results(folder_1cpu, mode_name)
    data_2cpu = read_results(folder_2cpu, mode_name)

    plt.figure(figsize=(10,6))
    plt.plot(x, data_1cpu, marker='o', label='1 CPU')
    plt.plot(x, data_2cpu, marker='o', label='2 CPU')
    plt.title(f"Performance for {mode_name.upper()} mode")
    plt.xlabel("Number of tasks (N)")
    plt.ylabel("Average execution time (s)")
    plt.legend()
    plt.grid(True)
    plt.savefig(f"{mode_name}_performance.png")
    plt.show()

if __name__ == "__main__":
    plot_mode("seq")  
    plot_mode("par") 
