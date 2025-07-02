// Gaussian kernel weights as macros for a 3x3 kernel
// These weights create a gentle blur effect (standard Gaussian blur)
#define K0 0.0625f  // Top-left
#define K1 0.125f   // Top-center
#define K2 0.0625f  // Top-right
#define K3 0.125f   // Middle-left
#define K4 0.25f    // Center
#define K5 0.125f   // Middle-right
#define K6 0.0625f  // Bottom-left
#define K7 0.125f   // Bottom-center
#define K8 0.0625f  // Bottom-right

// -------------------------------------
// Kernel 1: Gaussian Blur
// Applies a 3x3 Gaussian blur to an input image.
// Each work-item processes one pixel.
// -------------------------------------
__kernel void gaussian_blur(
    __global uchar4* input,   // Input image (RGBA, 8-bit per channel)
    __global uchar4* output,  // Output image (same format as input)
    int width,                // Image width
    int height                // Image height
) {
    // Get the x and y coordinates for this work-item (pixel)
    int x = get_global_id(0);
    int y = get_global_id(1);

    // Make sure we don't go out of bounds!
    if (x >= width || y >= height) return;

    // We'll accumulate the weighted sum of RGB channels here
    float3 sum = (float3)(0.0f, 0.0f, 0.0f);

    // Loop over the 3x3 neighborhood around the current pixel
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            // Clamp coordinates to stay inside the image
            int sample_x = clamp(x + dx, 0, width - 1);
            int sample_y = clamp(y + dy, 0, height - 1);

            // Fetch the neighboring pixel
            uchar4 pixel = input[sample_y * width + sample_x];

            // Compute the index for the kernel weight (flattened 3x3)
            int kidx = (dy+1)*3 + (dx+1);

            // Select the correct Gaussian weight for this position
            float weight = 0.0f;
            switch(kidx) {
                case 0: weight = K0; break;
                case 1: weight = K1; break;
                case 2: weight = K2; break;
                case 3: weight = K3; break;
                case 4: weight = K4; break;
                case 5: weight = K5; break;
                case 6: weight = K6; break;
                case 7: weight = K7; break;
                case 8: weight = K8; break;
            }

            // Accumulate the weighted RGB values
            sum.x += weight * pixel.x;
            sum.y += weight * pixel.y;
            sum.z += weight * pixel.z;
        }
    }

    // Prepare the output pixel, clamp to [0,255] and preserve alpha
    uchar4 result;
    result.x = convert_uchar_sat(sum.x);
    result.y = convert_uchar_sat(sum.y);
    result.z = convert_uchar_sat(sum.z);
    result.w = input[y * width + x].w; // Keep original alpha channel
    output[y * width + x] = result;
}

// -------------------------------------
// Kernel 2: Logarithmic Tone Mapping
// Applies a simple logarithmic tone mapping to compress dynamic range.
// This is useful for displaying HDR images on standard displays.
// -------------------------------------
__kernel void tone_mapping(
    __global uchar4* input,   // Input image (RGBA, 8-bit per channel)
    __global uchar4* output,  // Output image (same format as input)
    int width,                // Image width
    int height,               // Image height
    float max_luminance       // Maximum luminance for normalization
) {
    // Get the x and y coordinates for this work-item (pixel)
    int x = get_global_id(0);
    int y = get_global_id(1);

    // Bounds check (always important!)
    if (x >= width || y >= height) return;

    // Fetch the input pixel and normalize RGB channels to [0,1]
    uchar4 pixel = input[y * width + x];
    float r = pixel.x / 255.0f;
    float g = pixel.y / 255.0f;
    float b = pixel.z / 255.0f;

    // Calculate luminance using standard Rec. 709 weights
    float Y = 0.2126f * r + 0.7152f * g + 0.0722f * b;
    float Y_out = 0.0f;

    // Apply logarithmic tone mapping (if luminance is non-zero)
    if (Y > 0.0f) {
        Y_out = log(1.0f + Y) / log(1.0f + max_luminance);
    }

    // Scale RGB channels to match the new luminance
    float scale = (Y > 1e-6f) ? (Y_out / Y) : 0.0f;
    float r_out = r * scale;
    float g_out = g * scale;
    float b_out = b * scale;

    // Write the result, converting back to [0,255] and preserving alpha
    uchar4 result;
    result.x = convert_uchar_sat(r_out * 255.0f);
    result.y = convert_uchar_sat(g_out * 255.0f);
    result.z = convert_uchar_sat(b_out * 255.0f);
    result.w = pixel.w;  // Preserve alpha channel

    output[y * width + x] = result;
}
