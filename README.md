# nighttime_dehaze (ACMMM'2023)
[ACMMM2023] "Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution"

## Introduction
This is an implementation of the ACMMM2023 GAPSF paper.
> [Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution](https://arxiv.org/abs/2308.01738)\
> ACM International Conference on Multimedia (`ACMMM2023`)\
>[Yeying Jin*](https://jinyeying.github.io/), Beibei Lin*, Wending Yan, Wei Ye, Yuan Yuan and [Robby T. Tan](https://tanrobby.github.io/pub.html)

>[![arXiv](https://img.shields.io/badge/arXiv-Paper-<COLOR>.svg)](https://arxiv.org/abs/2308.01738)

## Real-world Nighttime Haze and Clean Reference 
1. [RealNightHaze](https://www.dropbox.com/sh/7qzmb3y9akejape/AABYf2ZAqn_5vmPsOPg7KqoMa?dl=0)
We provide 440 night hazy images.
2. [Internet_night_clean1](https://www.dropbox.com/sh/izex781w18efhqm/AACu8RJsyRVGNOVVTt3X-0HDa?dl=0)
We provide 411 night clean images.  
3. [Internet_night_clean2](https://www.dropbox.com/sh/yj0jac9alsfrxzx/AACsDWYljCjHuFAQ4X1HCNcva?dl=0)
We provide 50 clean night images, reference images for glow removal.

## Synthetic Nighttime Haze and Clean Ground Truth 
4. [GTA5 nighttime fog](https://www.dropbox.com/sh/gfw44ttcu5czrbg/AACr2GZWvAdwYPV0wgs7s00xa?dl=0) <br>
* `ECCV2020`
*Nighttime Defogging Using High-Low Frequency Decomposition and Grayscale-Color Networks* [[Paper]](https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123570460.pdf)\
Wending Yan, [Robby T. Tan](https://tanrobby.github.io/pub.html) and [Dengxin Dai](https://vas.mpi-inf.mpg.de/) 


## APSF-Guided Nighttime Glow Rendering
Run the Matlab code to obtain the clean and glow pairs:
```
APSF_GLOW_RENDER_CODE/synthetic_glow_pairs.m
````
Change the data path `nighttime_dehaze/paired_data/clean_data/`, <br>
the paired clean and glow results are saved in `nighttime_dehaze/paired_data/clean/` and `nighttime_dehaze/paired_data/glow/`, <br>
the visualization of light source maps are in `nighttime_dehaze/paired_data/glow_render_visual/light_source/`.

<p align="left">
  <img width=650" src="teaser/APSF1.png">
</p>
<p align="left">
  <img width=650" src="teaser/APSF2.png">
</p>

Run the Matlab code to visualize the Fig.3 in the main paper:
```
APSF_GLOW_RENDER_CODE/synthetic_glow_fig3_visualization.m
```
<p align="left">
  <img width=950" src="teaser/APSF_Fig3.png">
</p>

APSF and Alpha Matting are the implementations of the papers:<br>
* `CVPR03`
*Shedding Light on the Weather* [[Paper](https://cave.cs.columbia.edu/old/publications/pdfs/Narasimhan_CVPR03.pdf)]
* `CVPR06`
*A Closed-Form Solution to Natural Image Matting* [[Paper](https://people.csail.mit.edu/alevin/papers/Matting-Levin-Lischinski-Weiss-CVPR06.pdf)]

## [Results on the Synthetic Benchmark:](https://www.dropbox.com/sh/itopl02tpv1sda9/AABx1QJVtA9wbPoNVU65r584a?dl=0)
We provide the visualization results in `0_ACMMM23_RESULTS/NHR/index.html`, inside the directory `0_ACMMM23_RESULTS/NHR/img_0/` are hazy inputs, `0_ACMMM23_RESULTS/NHR/img_1/` are ground truths, `0_ACMMM23_RESULTS/NHR/img_2/` are our results. 

For results corresponding to `GTA5`, `NHM` or `NHC`, please refer to the respective directories.

## Evaluation: 
Set the dataset_name 'NHR' or 'NHM' or 'NHC', and Run the Python code:
```
python calculate_psnr_ssim_NH_GTA5.py
```
| Dataset | PSNR | SSIM | 
|--------|------|------ |
| GTA5| **30.383** |**0.9042**|
| NHR | **26.56** |**0.89**|
| NHM | **33.76** |**0.92**|
| NHC | **38.86** |**0.97**|

### Citation
If this work is useful for your research, please cite our paper. 
```BibTeX
@misc{jin2023enhancing,
      title={Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution}, 
      author={Yeying Jin and Beibei Lin and Wending Yan and Wei Ye and Yuan Yuan and Robby T. Tan},
      year={2023},
      eprint={2308.01738},
      archivePrefix={arXiv},
      primaryClass={cs.CV}
}
```
If GTA5 nighttime fog data is useful for your research, please cite the paper. 
```BibTeX
@inproceedings{yan2020nighttime,
	title={Nighttime defogging using high-low frequency decomposition and grayscale-color networks},
	author={Yan, Wending and Tan, Robby T and Dai, Dengxin},
	booktitle={European Conference on Computer Vision},
	pages={473--488},
	year={2020},
	organization={Springer}
}
```

