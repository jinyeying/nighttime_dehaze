import time, itertools
from dataset import ImageFolder
from torchvision import transforms
from torch.utils.data import DataLoader
from networks import *
from utils import *
from glob import glob
from PIL import Image
from cv2 import resize

IMG_EXTENSIONS = [
    '.jpg', '.JPG', '.jpeg', '.JPEG',
    '.png', '.PNG', '.ppm', '.PPM', '.bmp', '.BMP',
]

class GAPSF(object) :
    def __init__(self, args):        
        self.result_dir = args.result_dir
        self.dataset = args.dataset
        self.datasetpath = args.datasetpath

        self.n_res = args.n_res

        self.ch = args.ch
        self.img_size = args.img_size

        self.have_gt = args.have_gt

        print("# dataset : ", self.dataset)
        print("# datasetpath : ", self.datasetpath)


    def build_model(self):
        self.test_transform = transforms.Compose([
            transforms.Resize((self.img_size, self.img_size)),
            transforms.ToTensor(),
            transforms.Normalize(mean=(0.5, 0.5, 0.5), std=(0.5, 0.5, 0.5))
        ])
      
        self.testA = ImageFolder(os.path.join('dataset', self.datasetpath), self.test_transform)
        self.testA_loader = DataLoader(self.testA, batch_size=1, shuffle=False)

        self.genA2B = ResnetGenerator(input_nc=3, output_nc=3, ngf=self.ch, n_blocks=self.n_res, img_size=self.img_size).to('cuda')

    def load(self, dir, name):
        params = torch.load(os.path.join(dir, name))
        self.genA2B.load_state_dict(params['genA2B'])

    def test(self):
        model_list = glob(os.path.join(self.result_dir, self.dataset, 'model', '*.pt'))
        model_filename = os.path.basename(model_list[-1])
        print(os.path.join(self.result_dir, self.dataset, 'model'), model_filename)
        self.load(os.path.join(self.result_dir, self.dataset, 'model'), model_filename)
        print(" [*] Load SUCCESS")

        self.genA2B.eval()

        path_realA=os.path.join(self.result_dir, self.dataset, 'input')
        if not os.path.exists(path_realA):
            os.makedirs(path_realA)
         
        path_fakeB=os.path.join(self.result_dir, self.dataset, 'output')
        if not os.path.exists(path_fakeB):
            os.makedirs(path_fakeB)

        path_AB=os.path.join(self.result_dir, self.dataset,'input_output')
        if not os.path.exists(path_AB):
            os.makedirs(path_AB)

        self.input_list = [os.path.splitext(f) for f in os.listdir(os.path.join(self.datasetpath)) if any(f.endswith(suffix) for suffix in IMG_EXTENSIONS)]
      
        for n, in_name in enumerate(self.input_list):
            img_name = in_name[0]
            im_suf   = in_name[-1]
            print('predicting: %d / %d' % (n + 1, len(self.input_list)))
            
            img = Image.open(os.path.join('dataset', self.datasetpath,  img_name + im_suf)).convert('RGB')

            img_width, img_height =img.size

            real_A = (self.test_transform(img).unsqueeze(0)).to('cuda')                                    
            fake_A2B, _, _ = self.genA2B(real_A)
            
            A_real = RGB2BGR(tensor2numpy(denorm(real_A[0])))
            B_fake = RGB2BGR(tensor2numpy(denorm(fake_A2B[0])))
            A_real = resize(A_real, (img_width, img_height))
            B_fake = resize(B_fake, (img_width, img_height))
            A2B = np.concatenate((A_real, B_fake), 1)
            
            if self.have_gt == True:
                if self.dataset == 'NHM':
                    print('NHM',os.path.join('dataset', self.datasetpath.replace('testA','testB'), img_name.replace('_NighttimeHazy','_lowLight') + im_suf))
                    ref = Image.open(os.path.join('dataset', self.datasetpath.replace('testA','testB'), img_name.replace('_NighttimeHazy','_lowLight') + im_suf)).convert('RGB') 
                elif self.dataset == 'NHC':
                    print('NHC',os.path.join('dataset', self.datasetpath.replace('testA','testB'), img_name.replace('_nightHazy','_lowLight') + im_suf))
                    ref = Image.open(os.path.join('dataset', self.datasetpath.replace('testA','testB'), img_name.replace('_nightHazy','_lowLight') + im_suf)).convert('RGB')
                else:
                    #ref = Image.open(os.path.join('dataset', self.datasetpath.replace('hazy','gt'), img_name + im_suf)).convert('RGB')
                    ref = Image.open(os.path.join('dataset', self.datasetpath.replace('testA','testB'), img_name + im_suf)).convert('RGB')
                ref_A = (self.test_transform(ref).unsqueeze(0)).to('cuda')  
                A_ref  = RGB2BGR(tensor2numpy(denorm(ref_A[0])))
                A_ref = resize(A_ref, (img_width, img_height))
                A2B = np.concatenate((A_real, A_ref, B_fake), 1)

            cv2.imwrite(os.path.join(path_realA,  '%s%s' % (img_name, im_suf)), A_real * 255.0) 
            cv2.imwrite(os.path.join(path_fakeB,  '%s%s' % (img_name, im_suf)), B_fake * 255.0)
            cv2.imwrite(os.path.join(path_AB,     '%s%s' % (img_name, im_suf)), A2B * 255.0)
