# nighttime_dehaze (ACMMM'2023)
[ACMMM2023] "Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution"

## Introduction
This is an implementation of the ACM'MM2023 APSF paper.
> [Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution](https://arxiv.org/abs/2308.01738)\
> ACM International Conference on Multimedia (`ACMMM2023`)\
>[Yeying Jin*](https://jinyeying.github.io/), Beibei Lin*, Wending Yan, Wei Ye, Yuan Yuan and [Robby T. Tan](https://tanrobby.github.io/pub.html)

>[![arXiv](https://img.shields.io/badge/arXiv-Paper-<COLOR>.svg)](https://arxiv.org/abs/2308.01738)

## 1. Real-world Nighttime Haze and Clean Reference Data
1. [RealNightHaze](https://www.dropbox.com/sh/7qzmb3y9akejape/AABYf2ZAqn_5vmPsOPg7KqoMa?dl=0)
We provide 440 night hazy images.
2. [Internet_night_clean1](https://www.dropbox.com/sh/izex781w18efhqm/AACu8RJsyRVGNOVVTt3X-0HDa?dl=0)
We provide 411 night clean images.  
3. [Internet_night_clean2](https://www.dropbox.com/sh/yj0jac9alsfrxzx/AACsDWYljCjHuFAQ4X1HCNcva?dl=0)
We provide 50 clean night images, serve as reference images for glow removal.

## 2. Synthetic Nighttime Haze and Clean Ground Truth 
4. [GTA5 nighttime fog](https://www.dropbox.com/sh/gfw44ttcu5czrbg/AACr2GZWvAdwYPV0wgs7s00xa?dl=0) <br>
* `ECCV2020`
*Nighttime Defogging Using High-Low Frequency Decomposition and Grayscale-Color Networks* [[Paper]](https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123570460.pdf)\
Wending Yan, [Robby T. Tan](https://tanrobby.github.io/pub.html) and [Dengxin Dai](https://vas.mpi-inf.mpg.de/) 

## 3. Nighttime Dehazing Test Code
### 3.1 For the [RealNightHaze](https://www.dropbox.com/sh/7qzmb3y9akejape/AABYf2ZAqn_5vmPsOPg7KqoMa?dl=0) | [Results](https://www.dropbox.com/sh/7qzmb3y9akejape/AABYf2ZAqn_5vmPsOPg7KqoMa?dl=0), 
1. Set the `dataset path` to [RealNightHaze|Internet_night_fog](https://www.dropbox.com/sh/7qzmb3y9akejape/AABYf2ZAqn_5vmPsOPg7KqoMa?dl=0),
2. Download the checkpoint [dehaze.pt](https://www.dropbox.com/scl/fi/y634lpwli4u8dosn0o28r/dehaze.pt?rlkey=lmz1yjlga39somlfr6s0618q8&dl=0), put in [results/dehaze/model](https://github.com/jinyeying/nighttime_dehaze/tree/main/results/dehaze/model),
3. Run the [Python code](https://github.com/jinyeying/nighttime_dehaze/blob/main/main_test.py),
```
CUDA_VISIBLE_DEVICES=1 python main_test.py --dataset dehaze --datasetpath /diskc/yeying/night_dehaze/dataset/Internet_night_fog/
```
4. [Results are in `results/dehaze/output`](https://github.com/jinyeying/nighttime_dehaze/tree/main/results/dehaze/output) <br>
[Results for RealNightHaze|Internet_night_fog](https://www.dropbox.com/sh/7qzmb3y9akejape/AABYf2ZAqn_5vmPsOPg7KqoMa?dl=0).

<p align="left">
  <img width="550" src="teaser/dehaze.png">
</p>

### 3.2 For the Synthetic Dataset | [Results](https://www.dropbox.com/sh/itopl02tpv1sda9/AABx1QJVtA9wbPoNVU65r584a?dl=0),
1. Set `Line18 --have_gt` to `True`, set the `dataset path` to `GTA5` or `NHR` or `NHM` or `NHC`,
2. Download the checkpoint [GTA5.pt](https://www.dropbox.com/scl/fi/vencyhexni03379iht5yw/GTA5.pt?rlkey=oxsx81g0ds0xk085v2uglkr3t&dl=0), put in [results/GTA5/model](https://github.com/jinyeying/nighttime_dehaze/tree/main/results/GTA5/model),
Similarly, for [NHR.pt](https://www.dropbox.com/scl/fi/g6gzmjz6eynjqq02lksk0/NHR.pt?rlkey=61o5mck5zrracxoipbdfmmokx&dl=0), [NHM.pt](https://www.dropbox.com/scl/fi/bncvz68qrhakq0ws2un4w/NHM.pt?rlkey=rowzho61jyn06v2q5gxj8c7jw&dl=0), [NHC.pt](https://www.dropbox.com/scl/fi/899sug9o9cwrjdxx61raa/NHC.pt?rlkey=e7vye94mbgut8oicp1yl3kuva&dl=0),
3. Run the [Python code](https://github.com/jinyeying/nighttime_dehaze/blob/main/main_test.py),
```
CUDA_VISIBLE_DEVICES=1 python main_test.py --dataset NHM --datasetpath /diskc/yeying/night_dehaze/dataset/middlebury/testA/ 
CUDA_VISIBLE_DEVICES=1 python main_test.py --dataset NHC --datasetpath /diskc/yeying/night_dehaze/dataset/Cityscape/testA/ 
CUDA_VISIBLE_DEVICES=1 python main_test.py --dataset NHR --datasetpath /diskc/yeying/night_dehaze/dataset/NHR/testA/ 
CUDA_VISIBLE_DEVICES=1 python main_test.py --dataset GTA5 --datasetpath /diskc/yeying/night_dehaze/GTA5/testA/
```
4. [Results on the Synthetic Benchmark](https://www.dropbox.com/sh/itopl02tpv1sda9/AABx1QJVtA9wbPoNVU65r584a?dl=0).


## 4. APSF-Guided Nighttime Glow Rendering
Run the [Matlab code](https://github.com/jinyeying/nighttime_dehaze/blob/main/APSF_GLOW_RENDER_CODE/synthetic_glow_pairs.m) to obtain the clean and glow pairs:
```
APSF_GLOW_RENDER_CODE/synthetic_glow_pairs.m
````
Change the data path `nighttime_dehaze/paired_data/clean_data/`, <br>
the `paired clean and glow results` are saved in [nighttime_dehaze/paired_data/clean/](https://github.com/jinyeying/nighttime_dehaze/tree/main/paired_data/clean) and [nighttime_dehaze/paired_data/glow/](https://github.com/jinyeying/nighttime_dehaze/tree/main/paired_data/glow), <br>
the visualization of `light source maps` are in [nighttime_dehaze/paired_data/glow_render_visual/light_source/](https://github.com/jinyeying/nighttime_dehaze/tree/main/paired_data/glow_render_visual/light_source).

<p align="left">
  <img width=650" src="teaser/APSF1.png">
</p>
<p align="left">
  <img width=650" src="teaser/APSF2.png">
</p>

Run the [Matlab code](https://github.com/jinyeying/nighttime_dehaze/blob/main/APSF_GLOW_RENDER_CODE/synthetic_glow_fig3_visualization.m) to visualize the Fig.3 in the main paper:
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

## 5. [Results on the Synthetic Benchmark:](https://www.dropbox.com/sh/itopl02tpv1sda9/AABx1QJVtA9wbPoNVU65r584a?dl=0)
We provide the visualization results in `0_ACMMM23_RESULTS/NHR/index.html`, inside the directory `0_ACMMM23_RESULTS/NHR/img_0/` are hazy inputs, `0_ACMMM23_RESULTS/NHR/img_1/` are ground truths, `0_ACMMM23_RESULTS/NHR/img_2/` are our results. 

For results corresponding to `GTA5`, `NHM` or `NHC`, please refer to the respective directories.

## Evaluation: 
Set the dataset_name `GTA5` or `NHR` or `NHM` or `NHC`, and run the [Python code](https://github.com/jinyeying/nighttime_dehaze/blob/main/0_ACMMM23_RESULTS/calculate_psnr_ssim_NH_GTA5.py):
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
If this work or the Internet data is useful for your research, please cite our paper. 
```BibTeX
@inproceedings{jin2023enhancing,
  title={Enhancing visibility in nighttime haze images using guided apsf and gradient adaptive convolution},
  author={Jin, Yeying and Lin, Beibei and Yan, Wending and Yuan, Yuan and Ye, Wei and Tan, Robby T},
  booktitle={Proceedings of the 31st ACM International Conference on Multimedia},
  pages={2446--2457},
  year={2023}
}

@inproceedings{jin2022unsupervised,
  title={Unsupervised night image enhancement: When layer decomposition meets light-effects suppression},
  author={Jin, Yeying and Yang, Wenhan and Tan, Robby T},
  booktitle={European Conference on Computer Vision},
  pages={404--421},
  year={2022},
  organization={Springer}
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

