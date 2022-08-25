### **THIS CODE IS ONLY VALIDATED ON PC**

This contains Matlab functions for processing raw data of 3D-TrIm. This 
code requests user input to select the folder containing 3D-TrIm 
trajectories and will locate matching pairs of tracking and imaging data 
and transform the raw data into co-registered image volumes with overlaid 
trajectories. 

For example, call function **‘Batch_Process_3DTrIm_final’** and select folder 
**‘Fig 2A-E’**, the code will automatically find and match pairs of tracking 
and imaging data corresponding to Fig 2A-E and process. 

The resulting volume images and trajectory plots can be viewed independently 
or as overlays using the script files generated for Amira 2021.3 or newer. 
Additionally, the diffusion changepoint distribution of the trajectories is 
analyzed and exported.



If you find any bug or error in the package, please report the author at 
the email address listed below. 

Kevin Welsher, PhD<br>
Duke University<br>
Email: kevin.welsher@duke.edu

## References
### TDMS Reader:
Jim Hokanson (2022). TDMS Reader (https://www.mathworks.com/matlabcentral/fileexchange/30023-tdms-reader), MATLAB Central File Exchange. Retrieved August 25, 2022.
### inpaintn:
Parisotto, Simone, and Carola-Bibiane Schönlieb. MATLAB/Python Codes for the Image Inpainting Problem. Zenodo, 2020, doi:10.5281/ZENODO.4315173.
