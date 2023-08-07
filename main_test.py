from DEGLOW_test import UGATIT
import argparse
from utils import *

def parse_args():
    desc = "Pytorch implementation of GAPSF_Enhancing Visibility in Nighttime Haze Images Using Guided APSF and Gradient Adaptive Convolution"
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('--phase', type=str, default='test', help='[train / test]')
    parser.add_argument('--dataset', type=str, default='dehaze', help='dataset_name')
    parser.add_argument('--datasetpath', type=str, default='/disk1/yeying/dataset/REALNH', help='dataset_path')
    
    parser.add_argument('--ch', type=int, default=64, help='base channel number per layer')
    parser.add_argument('--n_res', type=int, default=4, help='The number of resblock')
    parser.add_argument('--n_dis', type=int, default=6, help='The number of discriminator layer')

    parser.add_argument('--img_size', type=int, default=512, help='The size of image')
    parser.add_argument('--result_dir', type=str, default='results', help='Directory name to save the results')    
    parser.add_argument('--have_gt', type=str2bool, default=False, help='have ground truth/reference images')

    return check_args(parser.parse_args())

def check_args(args):
    check_folder(os.path.join(args.result_dir, args.dataset, 'model'))
    return args

def main():
    # parse arguments
    args = parse_args()
    if args is None:
      exit()

    gan = UGATIT(args)
    gan.build_model()

    if args.phase == 'test' :
        gan.test()
        print(" [*] Test finished!")

if __name__ == '__main__':
    main()
