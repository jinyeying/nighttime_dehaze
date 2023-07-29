# nighttime_dehaze (ACMMM'2023)
[ACMMM2023] "Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution"

## Introduction
This is an implementation of the ACMMM2023 paper.
> [Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution.]\
> ACM International Conference on Multimedia (`ACMMM2023`)\
>[Yeying Jin](https://jinyeying.github.io/), Beibei Lin, Wending Yan, Wei Ye, Yuan Yuan and [Robby T. Tan](https://tanrobby.github.io/pub.html)
>

## APSF-Guided Nighttime Glow Rendering
Run the Matlab code to obtain the clean and glow pairs:
```
APSF_GLOW_RENDER_CODE/synthetic_glow_pairs.m
```
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
