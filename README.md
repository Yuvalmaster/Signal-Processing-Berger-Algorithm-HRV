# ECG Signal Processing using Berger Algorithm for HRV

## Project Overview
The Berger-HRV project aims to analyze and understand Heart Rate Variability by implementing the Berger algorithm. HRV provides insights into the dynamic interactions between the sympathetic and parasympathetic branches of the autonomic nervous system, which regulate heart rate and cardiovascular function. Detections and quantifying HRV, can result in valuable information about cardiac health, stress levels, and overall autonomic nervous system activity.

## Berger Algorithm for HRV Analysis
The project utilizes the Berger algorithm, a well-established method for HRV analysis. The Berger algorithm involves the following key steps:

* **R-Peak Detection**: The first step of the algorithm is to detect R-peaks in the electrocardiogram (ECG) signal. R-peaks correspond to the highest point in each heartbeat and serve as reference points for HRV analysis.

* **RR Interval Calculation**: The algorithm calculates the time intervals between successive R-peaks, known as RR intervals. These intervals represent the variation in the heart's beat-to-beat timing and form the basis of HRV analysis.

* **HRV Parameter Calculation**: Using the RR intervals, the algorithm calculates various HRV parameters. These parameters include time domain measures such as standard deviation of RR intervals (SDNN), root mean square of successive differences (RMSSD), and frequency domain measures such as high-frequency (HF) and low-frequency (LF) power. These parameters provide insights into the overall variability, short-term fluctuations, and autonomic balance of the heart rate.

# Repository Structure
The repository is organized to facilitate easy access to the project resources and implementation of the Berger algorithm. Here's an overview of the main components:

* Functions: this folder contains the implementation of the Berger algorithm for HRV analysis. It includes scripts and functions necessary for R-peak detection, RR interval calculation, and HRV parameter calculation. The code is organized to ensure modularity and ease of use.

* Data: The Data folder includes ECG samples that was used for HRV analysis. 
