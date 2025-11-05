#!/usr/bin/env python3
"""
Generate Windows ICO file from PNG icon.
Requires Pillow: pip3 install Pillow
"""

try:
    from PIL import Image
except ImportError:
    print("Error: Pillow is required. Install it with: pip3 install Pillow")
    exit(1)

import sys
import os

def create_ico(input_path, output_path):
    """Create ICO file with multiple sizes from PNG"""
    # Open the source image
    img = Image.open(input_path)
    
    # ICO file sizes (Windows supports multiple sizes in one ICO)
    sizes = [16, 32, 48, 64, 128, 256]
    
    # Create list of images at different sizes
    images = []
    for size in sizes:
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        images.append(resized)
    
    # Save as ICO with multiple sizes
    images[0].save(
        output_path,
        format='ICO',
        sizes=[(img.width, img.height) for img in images]
    )
    
    print(f"Successfully created {output_path} with sizes: {sizes}")

if __name__ == "__main__":
    input_file = "assets/millitimer-icon-pink.png"
    output_file = "windows/runner/resources/app_icon.ico"
    
    if not os.path.exists(input_file):
        print(f"Error: Input file not found: {input_file}")
        sys.exit(1)
    
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    create_ico(input_file, output_file)

