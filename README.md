# 🧠 ASIC Implementation of a CNN Layer using Verilog (RTL to GDSII)

This project demonstrates the ASIC implementation of a CNN-like signed arithmetic processing layer using a fully hierarchical Verilog design. The goal was to go from **RTL to GDSII** using open-source EDA tools like **OpenLane** and the **Sky130 PDK**.

> ✅ Fully verified with testbenches, synthesized to ~2.9K cells, clean STA, and LVS/DRC signoff.

---
## 📁 Repository Structure
sub_module16/
├── src/ # RTL modules (mux8_1, mux4_1, regfile_32x3_dual, top_module, sub_module*)
├── tb/ # Testbenches and waveform outputs
├── runs/ # OpenLane run folders
├── reports/ # Timing, area, power, LVS/DRC reports
└── README.md # This file

---

## 📌 Project Summary

- ✅ Designed a **signed multiplier architecture** using **bottom-up hierarchical Verilog** modules.
- ✅ Verified each module (e.g., `mux8_1`, `regfile_32x3_dual`) independently using Icarus Verilog and GTKWave.
- ✅ Integrated modules into a 9-input processing system (`sub_module16`) performing cascaded signed arithmetic.
- ✅ Synthesized using OpenLane and Sky130 PDK:
  - ~2.9K standard cells  
  - Core Area: **98,918 µm²**  
  - Die Area: **120,000 µm²**  
  - ~82% core utilization  
- ✅ Achieved **full timing closure**:
  - **TNS** = 0.00 ns  
  - **WNS** = 0.00 ns  
  - **Setup Slack** = +8.94 ns  
  - **Hold Slack** = +0.85 ns  
  - **Clock Skew** = 0.00 ns  
- ✅ **Signoff:**
  - ✔ DRC-clean layout (Magic)
  - ✔ LVS matched (Netgen)
  - ⚠ 24 Antenna violations marked for diode insertion
  - Checked using OpenLane 3.x toolchain

---

## 📊 Power Report (Typical Corner)

| Component     | Power (W) | % Contribution |
|---------------|-----------|----------------|
| Sequential    | 0.000306  | 4.7%           |
| Combinational | 0.00616   | 95.3%          |
| Total         | **0.00647** | 100%        |

---

## 🧪 Tools Used

- **Language**: Verilog HDL  
- **Simulation**: Icarus Verilog, GTKWave  
- **EDA Tools**: OpenLane, Yosys, Magic, Netgen, KLayout  
- **PDK**: Sky130 (Google + SkyWater)  
- **Methodology**: Bottom-up RTL design, hierarchical integration, test-driven verification  
- **Platform**: Ubuntu + OpenLane Docker flow  

---

## 📎 Related Projects

- 🔗 [Verilog Design Library – 50+ Modules](https://github.com/Advaithag/VERILOG-BASIC-DESIGNS): A companion library of combinational and sequential logic blocks, fully simulated and documented.

---

## 👨‍💻 Author

**Advaith G**  
📧 advaithag47@gmail.com  
🔗 [GitHub: Advaithag](https://github.com/Advaithag)  
🔗 [LinkedIn: linkedin.com/in/advaithag47](https://linkedin.com/in/advaithag47)

---

### ⭐ Tip:  
If you find this project helpful, feel free to star ⭐ the repository or fork it for your own RTL-to-GDSII experiments.

