# 🔧 Hardware Deployment of Secure ML Models

This project demonstrates the deployment of Machine Learning models—**Linear Regression** and **Support Vector Regression (SVR)**—on hardware using an **FPGA (PYNQ Z2 Board)**. It includes a performance comparison (accuracy and time) between software-based execution in Python and hardware execution via Verilog.

---

## 🖼️ FPGA Board

This is the **PYNQ Z2 FPGA board** used for hardware deployment:

<div align="center">
  <img src="https://m.media-amazon.com/images/I/81a+hoSRZAL._AC_UF1000,1000_QL80_.jpg" alt="FPGA Board" width="400"/>
</div>



## 🧠 Project Overview

- **ML Models Used:**
  - Linear Regression for House Price Prediction
  - SVR (Support Vector Regression) for CO₂ Emission Gas Prediction

- **Software Stack:**
  - Python (Jupyter Notebooks)
  - scikit-learn (for model training)
  - Xilinx Vivado (for Verilog simulation and IP core packaging)
  - PYNQ SDK

- **Hardware Stack:**
  - PYNQ Z2 FPGA Board
  - Custom Verilog modules (IEEE 754 based floating-point operations)

---

---

## 💡 Why IEEE 754 Over Fixed-Point?

Initially, we attempted **fixed-point (Q22.10)** representation for weights and inputs to optimize resource usage. However, fixed-point arithmetic presented the following challenges:

- 🔸 **Loss of Precision**: Fixed-point formats are sensitive to scale and rounding, especially when input values vary widely. This caused significant errors in regression output.
- 🔸 **Difficult Normalization**: Handling overflow/underflow and normalization is complex in fixed-point without built-in support.
- 🔸 **Inconsistent Accuracy**: While suitable for classification tasks, fixed-point lacked the numerical stability required for regression where small errors propagate.

Hence, we transitioned to **IEEE 754 single-precision (32-bit) floating-point format**, because:

- ✅ It offers **greater dynamic range** and **higher precision**, essential for regression tasks.
- ✅ Supported well in Vivado via custom logic or IP cores.
- ✅ Ensures compatibility with Python-trained models which use 32-bit floats internally.
- ✅ Reduces rounding and overflow errors significantly compared to fixed-point.

This made IEEE 754 a more robust choice for real-time ML inference on hardware.

---

## ⚙️ Methodology

### 🔹 1. Software Implementation

- Preprocessed and split datasets (80% train / 20% test)
- Trained using `LinearRegression()` and `SVR()` from `scikit-learn`
- Extracted model weights and bias
- Evaluated models using R² score (Linear Regression: **0.9211**)
- Evaluated models using R² score (Support Vector Regression: **0.8753**)

### 🔹 2. Hardware Implementation

- Designed floating-point arithmetic modules (Adder, Multiplier, Comparator) using **IEEE 754**
- Converted weights, inputs, and bias into IEEE 754 32-bit format
- Created a modular Verilog-based **Linear Regression** and **Support Vector Regression** system 
- Packed Verilog module as AXI4-Lite IP using **Xilinx Vivado**
- Interfaced IP core with PYNQ Z2 board via **ARM processor**
- Used SDK code to write inputs/read outputs and benchmark execution time

---

## 🔬 Comparison
**NUMBER OF SAMPLES USE**
-For **Linear Regression**
| Mode              | R²      | MAE         | MSE               | RMSE        | Time Taken  |
|-------------------|---------|-------------|-------------------|-------------|-------------|
| Python (Software) | 0.9212  | 81305.2330  | 10100187858.8633  | 100499.6908 | 0.002s      |
| FPGA (Hardware)   | -0.8681 | 384304.2154 | 239363200159.3078 | 489247.5857 | 0.001s      |

-For **Support Vector Regresssion** 

| Mode              | R²     | MAE     | MSE      | RMSE    | Time Taken  |
|-------------------|--------|---------|----------|---------|-------------|
| Python (Software) | 0.8753 | 10.1431 | 474.5266 | 21.7836 | 0.29599s    |
| FPGA (Hardware)   | 0.8753 | 10.1690 | 474.6537 | 21.7865 | 0.002s      |

---

## 📈 Future Work

- Further optimize SVR model for better hardware mapping
- Explore fixed-point arithmetic for energy-efficient deployment
- Expand model support (e.g., logistic regression, decision trees)

---

## 📦 Dependencies

To run software models:

```bash
      pip install numpy pandas scikit-learn jupyter
```
To run Hardware file you requided software **Vivado and SDK**

## 👨‍💻 Authors
Anika Verma (2023UEE0125)

Heer Chovatiya (2023UEE0137)

Gaurav Tiwari (2023UEE0134)

Saksham Vijay (2023UEE0150)

Supervisor: Dr. Yamuna Prasad
TA: Mr. Mahendar Gurve
