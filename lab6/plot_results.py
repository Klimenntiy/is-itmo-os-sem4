import matplotlib.pyplot as plt
import os

def read_results(directory, prefix, mode):
    means = []
    for n in range(1, 21):
        path = os.path.join(directory, f"{prefix}_{mode}_{n}.txt")
        if os.path.exists(path):
            with open(path) as f:
                times = [float(line.strip()) for line in f if line.strip()]
                means.append(sum(times) / len(times) if times else 0)
        else:
            means.append(0)
    return means

def plot_results(x, seq_data, par_data, title, filename, label_prefix):
    plt.figure(figsize=(10, 6))
    plt.plot(x, seq_data, label=f"{label_prefix} Sequential", marker='o')
    plt.plot(x, par_data, label=f"{label_prefix} Parallel", marker='x')
    plt.title(title)
    plt.xlabel("N (tasks/files)")
    plt.ylabel("Average Time (s)")
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.savefig(filename)
    plt.show()

def main():
    core_choice = input("Выберите режим (1 - одно ядро, 2 - два ядра): ").strip()
    type_choice = input("Выберите тип задач (cpu / disk): ").strip().lower()

    if core_choice not in ("1", "2") or type_choice not in ("cpu", "disk"):
        print("❌ Неверный выбор. Попробуйте снова.")
        return

    x = list(range(1, 21))

    if core_choice == "1":
        directory = "CPU" if type_choice == "cpu" else "Disk"
    else:
        directory = "CPU_2CPU" if type_choice == "cpu" else "Disk_2CPU"

    prefix = "results" if type_choice == "cpu" else "results_disk"

    seq = read_results(directory, prefix, "seq")
    par = read_results(directory, prefix, "par")

    title = f"{type_choice.upper()} Tasks ({core_choice} Core{'s' if core_choice == '2' else ''})"
    filename = f"{type_choice}_{core_choice}core.png"
    label_prefix = type_choice.upper()

    plot_results(x, seq, par, title, filename, label_prefix)

if __name__ == "__main__":
    main()
