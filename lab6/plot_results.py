import matplotlib.pyplot as plt
import numpy as np

def model_times(t_base, overhead, N_tasks, speedup):
    # t_base - базовое время на 1 задачу
    # overhead - накладные расходы на параллельность
    # N_tasks - массив чисел задач
    # speedup - насколько ускоряется параллельно (например, 1.2 для 1 ядра, 2 для 2 ядер)
    
    seq = t_base * N_tasks
    par = t_base * (N_tasks / speedup) + overhead
    return seq, par

def plot_results(N, seq, par, title, filename):
    plt.figure(figsize=(8,5))
    plt.plot(N, seq, marker='o', label='Последовательное')
    plt.plot(N, par, marker='s', label='Параллельное')
    plt.title(title)
    plt.xlabel('Количество задач (N)')
    plt.ylabel('Время выполнения (сек)')
    plt.legend()
    plt.grid(True)
    plt.savefig(filename)
    plt.show()

def main():
    N = np.arange(1, 21)

    # Параметры (примеры)
    overhead_cpu = 2.0
    overhead_disk = 3.0

    t_base_cpu = 5.0  # базовое время 1 задачи CPU
    t_base_disk = 20.0  # базовое время 1 задачи Disk

    # 1 ядро CPU
    seq_cpu_1, par_cpu_1 = model_times(t_base_cpu, overhead_cpu, N, speedup=1.2)
    plot_results(N, seq_cpu_1, par_cpu_1, 'CPU 1 ядро: последовательное и параллельное', 'cpu_1core.png')

    # 2 ядра CPU
    seq_cpu_2, par_cpu_2 = model_times(t_base_cpu, overhead_cpu, N, speedup=2.0)
    plot_results(N, seq_cpu_2, par_cpu_2, 'CPU 2 ядра: последовательное и параллельное', 'cpu_2core.png')

    # 1 ядро Disk
    seq_disk_1, par_disk_1 = model_times(t_base_disk, overhead_disk, N, speedup=1.1)
    plot_results(N, seq_disk_1, par_disk_1, 'Disk 1 ядро: последовательное и параллельное', 'disk_1core.png')

    # 2 ядра Disk
    seq_disk_2, par_disk_2 = model_times(t_base_disk, overhead_disk, N, speedup=1.5)
    plot_results(N, seq_disk_2, par_disk_2, 'Disk 2 ядра: последовательное и параллельное', 'disk_2core.png')

if __name__ == "__main__":
    main()
