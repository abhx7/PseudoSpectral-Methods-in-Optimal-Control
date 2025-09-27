# 🎯 Pursuit-Evasion Optimal Control Project

This repository contains the implementation of a **Pursuit-Evasion Game** as part of the AS5580 course project.  
The work models a **pursuer-target engagement** scenario using a 3-DOF aircraft model and solves it as an **optimal control problem**.  
Two different formulations were tested, and numerical simulations were run in **Python** and **MATLAB**.

---

## 📌 Problem Overview
- The pursuer aims to **minimize distance** to the evader while respecting physical constraints.
- The evader maintains a predefined trajectory.
- The model enforces:
  - Smooth and feasible **control inputs**  
  - Avoidance of the **attack envelope** of the evader  
  - Balance between **distance minimization** and **control effort**

---

## 🛠 Methodology
We explored two formulations:

1. **Method 1 – Time Stepping with RK4**  
   - Uses the 4th-order Runge–Kutta method for trajectory generation.  
   - Control inputs interpolated using Lagrange polynomials.  
   - Optimized using solvers like `scipy.optimize.minimize` and `cyipopt`.

2. **Method 2 – Nonlinear Constraints Formulation**  
   - Directly enforces system dynamics as nonlinear equality constraints.  
   - Requires larger variable sets but avoids integration instabilities.  
   - Implemented using MATLAB’s `fmincon`.

---

## ⚡ Cost Function
The cost function combines:
- 📏 **Separation Distance** (pursuer → target)  
- 🕹 **Control Effort Penalty**  
- 🛡 **Angle Penalty** (avoid entering evader’s attack cone)  
- 🎯 **Terminal Cost** (final position matching)

---

## 📊 Results
We simulated multiple cases varying:
- Initial positions of pursuer/evader  
- Control inputs of evader  
- Time horizon and discretization nodes  

Below are some example outputs (see `images/` folder for more):

### Control Inputs
![Control Inputs](https://github.com/abhx7/PseudoSpectral-Methods-in-Optimal-Control/blob/main/Assignments/Course%20Project/nx.png)
![Control Inputs](https://github.com/abhx7/PseudoSpectral-Methods-in-Optimal-Control/blob/main/Assignments/Course%20Project/nz.png)
![Control Inputs](https://github.com/abhx7/PseudoSpectral-Methods-in-Optimal-Control/blob/main/Assignments/Course%20Project/mu.png)


### Optimized Trajectories
![Trajectory](https://github.com/abhx7/PseudoSpectral-Methods-in-Optimal-Control/blob/main/Assignments/Course%20Project/traj.png))


---

## 📬 Authors
- Abhigyan Roy  
- Hrishav Das  
- Reva Dhillon  
- Agni Ravi Deepa  

---

## 🔮 Future Work
- Extend to **3D pursuit-evasion** dynamics.  
- Introduce **active evasion strategies** for the target.  
- Apply in **autonomous UAV and defense scenarios**.  

---

## 📜 License
This repository is for academic and research use. Please cite appropriately if used.
