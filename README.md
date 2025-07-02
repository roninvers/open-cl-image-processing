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
3. The processed image will be saved in the `output/` folder.

## Example

**Input:**  
![Input Image](input/img.png)

**Output:**  
![Processed Image](output/output.png)

## Development History

This repository includes a progressive commit history showing the step-by-step development of the project.

---

## License

[MIT License](LICENSE)
