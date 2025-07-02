## How to Run This Project on macOS in Jupyter Notebook

1. **Install Xcode Command Line Tools**  
   Open Terminal and run:  
xcode-select --install


2. **Verify OpenCL Availability**  
OpenCL is pre-installed on macOS 10.7 and later. To check:  
ls /System/Library/Frameworks/OpenCL.framework


3. **Check Python and Jupyter Installation**  
In Terminal, check if Python 3 and Jupyter are installed:  
python3 --version
jupyter --version
If not installed, install Python 3 (from [python.org](https://www.python.org/downloads/mac-osx/)), then Jupyter:  
pip3 install jupyter

4. **Install Project Python Dependencies**  
Install PyOpenCL and Pillow:  
pip3 install pyopencl pillow

5. **Clone the Repository and Prepare Files**  
git clone https://github.com/roninvers/open-cl-image-processing.git
cd open-cl-image-processing
Place your input image in the `input/` folder (e.g., `input/img.png`).

6. **Launch Jupyter Notebook**  
In your project directory, start Jupyter:  
jupyter notebook process_image.ipynb
This will open Jupyter in your browser.

7. **Run the Notebook Cells**  
- Open `process_image.ipynb` in the browser.
- Run each cell in order (Shift+Enter).
- The processed image will be saved in the `output/` folder.

8. **Troubleshooting**  
- If you see `clGetPlatformIDs failed: PLATFORM_NOT_FOUND_KHR`, ensure Xcode Command Line Tools are installed and your Mac supports OpenCL.
- Restart Terminal or your Mac if you installed new tools and they are not detected.


Throughout this project, I aimed for a clear, methodical approach—starting with careful planning of the project structure and requirements. I incrementally implemented and tested each major component, from the OpenCL kernels to the Python host code, ensuring each stage worked as intended before moving to the next. Regularly reviewing and refining my code allowed me to address challenges such as memory management, kernel synchronization, and platform compatibility. By documenting my progress with meaningful commit messages and thorough comments, I ensured that the development process remained transparent and reproducible. This disciplined workflow enabled me to bring the project to a successful and robust closure.

# OpenCL Image Processing Project

This project demonstrates GPU-accelerated image processing using OpenCL. It applies a 3×3 Gaussian blur and logarithmic tone mapping to RGBA images.

## Project Structure
open-cl-image-processing/
├── kernels.cl
├── process_image.ipynb
├── input/
│ └── img.png
├── output/
│ └── output.png
├── README.md
└── .gitignore

## Requirements

- Python 3.x
- [PyOpenCL](https://documen.tician.de/pyopencl/)
- [Pillow (PIL)](https://python-pillow.org/)
- OpenCL drivers (e.g., PoCL for CPU or NVIDIA OpenCL for GPU)

## Setup

1. Clone this repository:
    ```
    git clone https://github.com/roninvers/open-cl-image-processing.git
    cd open-cl-image-processing
    ```

2. (Optional) Create a virtual environment:
    ```
    python3 -m venv venv
    source venv/bin/activate
    ```

3. Install dependencies:
    ```
    pip install pyopencl pillow
    ```

4. Ensure you have an OpenCL platform installed.  
   For CPU (Linux):
    ```
    sudo apt-get install pocl-opencl-icd ocl-icd-opencl-dev clinfo
    ```

## Usage

1. Place your input image in the `input/` folder (e.g., `input/img.png`).
2. Open and run `process_image.ipynb` in Jupyter Notebook or JupyterLab.
3. The processed image will be saved as the `output.png`

## Example

**Input:**  
![Input Image](input/img.png)

**Output:**  
![Processed Image](output.png)

## Development History

This repository includes a progressive commit history showing the step-by-step development of the project.
