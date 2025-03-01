# Isotropic Image Filtering Circuit  

This repository contains the **Isotropic Image Filtering Circuit**, a digital system implemented on FPGA for **2D image filtering** using a **3x3 convolution kernel**. The project is designed to efficiently process images while allowing **dynamic configuration of image size and border handling**.

## 🔹 Features  
✔️ Supports **32x32 and 64x64 grayscale images** (8-bit per pixel).  
✔️ Implements **3x3 isotropic filtering** using a convolution kernel.  
✔️ **Configurable FSM** for:  
   - Selecting **image dimensions** (before synthesis).  
   - Choosing different **border handling methods**:  
     - White padding (border pixels set to 255).  
     - Black padding (border pixels set to 0).  
     - Mirroring (reflects adjacent pixels).  
     - Toroidal wrap-around (continuous edges).  
✔️ Optimized with **pipelined architecture** for high-frequency performance.  
✔️ Uses **Carry-Save Adder Trees** and **Booth Multipliers** for efficient computations.  

## ⚙️ How It Works  

### 🏗 Architecture  
The circuit consists of **three main blocks**:  

1. **Buffer Line**: Stores image rows to provide a **3x3 sliding window** for convolution.  
2. **Computation Block**: Uses Booth multipliers and Carry-Save Adder Trees to perform **efficient convolution calculations**.  
3. **Control Block (FSM)**: Synchronizes processing and **manages border configurations**.  

### 🖼 Border Handling Techniques  
The system supports four different **border extension methods**, selectable via control signals:  

| Mode          | Description |  
|--------------|------------|  
| **White Padding** | Sets border pixels to **255 (white)**. |  
| **Black Padding** | Sets border pixels to **0 (black)**. |  
| **Mirroring** | Mirrors the nearest pixel values at the border. |  
| **Toroidal** | Connects opposite borders for a **continuous effect**. |  

### 🏎 Performance Optimization  
To maximize speed, the design:  
✅ Uses **pipelined operations** for concurrent processing.  
✅ Employs **efficient multiplier designs** (Booth algorithm).  
✅ Optimizes resource usage on **FPGA Virtex 7**.  

## 🚀 Getting Started  

### 🛠 Requirements  
- **FPGA Board**: Xilinx Virtex-7  
- **Toolchain**: Xilinx Vivado + Vitis HLS  
- **Languages**: VHDL  

### 🔧 Synthesizing on FPGA
Open Vivado and create a new project.
Add the source files from /src/.
Configure target device (Virtex-7).
Run Synthesis → Implementation → Bitstream Generation.
Program the FPGA and test with an image input.

### 📄 Documentation
Design Report: Detailed explanation of circuit design and optimizations.
Block Diagrams: Visual representation of data flow.
