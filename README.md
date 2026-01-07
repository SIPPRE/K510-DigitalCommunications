# K510 - Digital Communications

**Department of Electrical & Computer Engineering** **University of Peloponnese**

This repository contains the supplementary material, source code, and examples for the undergraduate course **K510: Digital Communications**.



## 📚 Course Overview
The material in this repository accompanies the lectures and laboratory exercises for the Digital Communications course. It covers fundamental and advanced topics in digital transmission, modulation, channel coding, and information theory.

### Textbook
The code examples are primarily based on concepts from:
> *Modern Digital and Analog Communication Systems*, 4th and 5th Edition  
> by **B.P. Lathi** and **Zhi Ding**



## 📂 Repository Structure

The repository is organized by chapters corresponding to the course curriculum. It includes implementations in both **MATLAB/Octave** and **Python**.

| Directory     | Topic                                                    |
| :------------ | :------------------------------------------------------- |
| `Chapter6`    | Sampling & Analog-to-Digital Conversion                  |
| `Chapter7`    | Principles of Digital Data Transmission                  |
| `Chapter10`   | Performance Analysis of Digital Comm. Systems            |
| `Chapter11`   | Spread Spectrum Communications                           |
| `Chapter12`   | Digital Communications over Linearly Distortive Channels |
| `Chapter13`   | Introduction to Information Theory                       |
| `Chapter14`   | Error Correction Coding                                  |
| `python_code` | **Python** implementations and Jupyter Notebooks         |

## 🚀 Getting Started

### Prerequisites

#### Python
To run the `.ipynb` notebooks and Python scripts, you will need a standard data science environment. We recommend using [Anaconda](https://www.anaconda.com/) or installing the dependencies via `pip`:

```bash
pip install numpy scipy matplotlib jupyterlab
```

#### MATLAB / Octave

- **MATLAB**: Requires the Communications Toolbox for certain scripts.

- **Octave**: Most scripts are compatible with GNU Octave. You may need to load the communications package:

  Code snippet

  ```
  pkg load communications
  ```

### Running the Code

1. Clone the repository:

   Bash

   ```
   git clone [https://github.com/SIPPRE/K510-DigitalCommunications.git](https://github.com/SIPPRE/K510-DigitalCommunications.git)
   ```

2. Navigate to the folder:

   Bash

   ```
   cd K510-DigitalCommunications
   ```

3. Launch Jupyter (for Python notebooks):

   Bash

   ```
   jupyter lab
   ```

## 📝 License

This project is open for educational purposes. Please refer to the specific license file (if available) or contact the maintainers for usage rights regarding commercial applications.

------

**Maintained by:** SIPPRE Group and Athanasios Koutras (Course Lecturer)
