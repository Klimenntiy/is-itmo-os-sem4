import matplotlib.pyplot as plt
import os
import re

def read_times(folder, mode):
    times = []
    # Ищем файлы вида *seq_1.txt ... *seq_20.txt или *par_1.txt ... *par_20.txt
    pattern = re.compile(rf".*_{mode}_(\d+)\.txt$")
    for i in range(1, 21):
        file_found = False
        for filename in os.listdir(folder):
            match = pattern.match(filename)
            if match and int(match.group(1)) == i:
                filepath = os.path.join(folder, filename)
                with open(filepath) as f:
                    vals = [float(line.strip()) for line in f if line.strip()]
                    avg = sum(vals) / len(vals) if vals else 0
                    times.append(avg)
                file_found = True
                break
        if not file_found:
            print(f"Warning: файл для {mode} с номером {i} не найден")
            times.append(0)
    return times

def plot_two_graphs(x, seq_data, par_data, folder):
    plt.figure(figsize=(10,5))
    plt.plot(x, seq_data, marker='o')
    plt.title(f"Sequential Execution Time\nПапка: {folder}")
    plt.xlabel("N (число задач)")
    plt.ylabel("Среднее время (с)")
    plt.grid(True)
    plt.savefig(f"{folder}_sequential.png")
    plt.show()

    plt.figure(figsize=(10,5))
    plt.plot(x, par_data, marker='o', color='orange')
    plt.title(f"Parallel Execution Time\nПапка: {folder}")
    plt.xlabel("N (число задач)")
    plt.ylabel("Среднее время (с)")
    plt.grid(True)
    plt.savefig(f"{folder}_parallel.png")
    plt.show()

def main():
    folder = input("Введите имя папки с результатами: ").strip()

    if not os.path.isdir(folder):
        print("Ошибка: такой папки нет!")
        return

    x = list(range(1, 21))
    seq = read_times(folder, "seq")
    par = read_times(folder, "par")

    plot_two_graphs(x, seq, par, folder)

if __name__ == "__main__":
    main()
