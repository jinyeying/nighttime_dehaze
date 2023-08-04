# nighttime_dehaze (ACMMM'2023)
[ACMMM2023] "Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution"

## Introduction
This is an implementation of the ACMMM2023 paper.
> [Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution](https://arxiv.org/abs/2308.01738)\
> ACM International Conference on Multimedia (`ACMMM2023`)\
>[Yeying Jin*](https://jinyeying.github.io/), Beibei Lin*, Wending Yan, Wei Ye, Yuan Yuan and [Robby T. Tan](https://tanrobby.github.io/pub.html)

>[![arXiv](https://img.shields.io/badge/arXiv-Paper-<COLOR>.svg)](https://arxiv.org/abs/2308.01738)

## [Results on the Synthetic Benchmark:](https://www.dropbox.com/scl/fi/jqv405gx03rebym8d959w/0_ACMMM23_RESULTS.zip?rlkey=b61k1a903c0ogk7skapyf1m2l&dl=0)
We provide the visualization results in `0_ACMMM23_RESULTS/NHR/index.html`, inside the directory `0_ACMMM23_RESULTS/NHR/img_0/` are hazy inputs, `0_ACMMM23_RESULTS/NHR/img_1/` are ground truths, `0_ACMMM23_RESULTS/NHR/img_2/` are our results. For results corresponding to 'NHM' or 'NHC', please refer to the respective directories.

## Evaluation: 
Set the dataset_name 'NHR' or 'NHM' or 'NHC', and Run the Python code:
```
python calculate_psnr_ssim_NH.py
```
| Dataset | PSNR | SSIM | 
|--------|------|------ |
| NHR | **27.33** |**0.93**|
| NHM | **34.73** |**0.94**|
| NHC | **39.23** |**0.98**|

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

