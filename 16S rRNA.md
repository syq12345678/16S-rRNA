![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/1.16S-rRNA%20general%20workflow.png)

# 1.qiime2安装

## 1.1 Minicoda软件包管理器安装

```
# 下载miniconda软件管理器(https://conda.io/miniconda.html)），将用于安装QIIME2及依赖关系 
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 运行安装程序
bash Miniconda3-latest-Linux-x86_64.sh
# 测试是否安装成功,有版本信息即为安装成功
conda --version
# 删除安装程序，下次你会下载新版
rm Miniconda3-latest-Linux-x86_64.sh
# 如果已经安装过，则升级conda为最新版本
conda update conda
```

注：安装过程中按提示操作： 

1.Please, press ENTER to continue，按回车键查看许可协议，再按空格键翻页完成全文阅读；  

2.Do you accept the license terms? [yes|no]，是否同意许可协议，输入yes同意许可；  

提示默认安装目录为家目录下~/miniconda3目录，可手动输入一个指定的安装目录，推荐按回车确认使用此目录；  

3.Do you wish the installer to initialize Miniconda3 by running conda init? [yes|no]，提示是否默认启动conda环境，这里输入yes并回车。

4.Miniconda3安装成功,默认运行base包，打开终端命令行最前面会出现（base)

5.如果下面运行安装没有权限，请运行 export PATH="~/miniconda3/bin:$PATH" 手动添加新安装的miniconda3至环境变量，或尝试source ~/.bashrc更新环境变量  

6.安装结束时提示是否添加环境变量~/.bashrc，一般选no。因为选yes可直接将conda环境加入环境变量的最高优先级，使用方便，但conda里的环境如 Python变为默认环境，破坏之前依赖Python的软件环境。而选no不添加保证之前软件安装环境不变，但运行conda及相关程序时，需要运行一条命令临时~/miniconda3/bin目录至环境变量，或使用绝对路径执行相关程序 。以后想要使用conda，需要运行如下命令将conda临时添加环境变量  export PATH="~/miniconda3/bin:$PATH"  但如果是新环境，或要经常使用QIIME 2，推荐使用默认的添加环境变量更方便。之前同意添加环境变量，完成后关闭当前终端，新打开一个终端继续操作才能生效。如果系统已经有很多程序，添加conda至环境变量可能引起之前软件的依赖关系被破坏。 

7.(可选)添加常用软件下载频道，以及国内镜像加速下载。 升级conda为最新版：新版的bug最少，碰到问题的机率也小。

```
# 添加常用下载频道 
conda config --add channels defaults 
conda config --add channels conda-forge 
conda config --add channels bioconda  
# 添加清华镜像加速下载 
site=https://mirrors.tuna.tsinghua.edu.cn/anaconda 
conda config --add channels ${site}/pkgs/free/  
conda config --add channels ${site}/pkgs/main/ 
conda config --add channels ${site}/cloud/conda-forge/ 
conda config --add channels ${site}/pkgs/r/ 
conda config --add channels ${site}/cloud/bioconda/ 
conda config --add channels ${site}/cloud/msys2/ 
conda config --add channels ${site}/cloud/menpo/ 
conda config --add channels ${site}/cloud/pytorch/  
# 查看已经添加的channels  
conda config --get cnannels
```

## 1.2 Conda安装qiime2环境

```
# 新建一个安装qiime2的文件夹
mkdir -p qiime2 
# 下载软件安装列表，官方源不容易下载 
wget -c https://data.qiime2.org/distro/core/qiime2-2020.11-py36-linux-conda.yml 
# 只有6k，但数据来源于github，有时无法下载，可以换成下列链接
wget -c http://210.75.224.110/github/QIIME2ChineseManual/2020.11/qiime2-2020.11-py36-linux-conda.yml 
# 创建虚拟环境并安装qiime2，防止影响其它己安装软件 （conda主要是在系统之外再构建一个虚拟环境，操作都在虚拟环境中进行。conda能管理不同的Python环境，不同的环境之间是互相隔离，互不影响的。）
conda env create -n qiime2-2020.11 --file qiime2-2020.11-py36-linux-conda.yml 
# 删除软件列表 
rm qiime2-2020.11-py36-linux-conda.yml
```

​        注：从yml的软件列表文件中可以得知，QIIME 2依赖的软件多达336个。  下载安装所有依赖关系，时间主要由网速决定。再重试是可以继续末完成的任务，很快就成功了。如果添加有上述国内的镜像，半小时内可以搞定。

## 1.3 Conda操作指令

```
# 查看当前存在的虚拟环境（可以看到除了conda自带的base环境，还有已经创建的qiime2-2020.11虚拟环境
conda env list
# 激活16SrRNA分析需要的qiime2环境（每次打开终端默认是base环境，所以使用qiime2环境进行操作时需要先激活qiime2环境）
conda activate qiime2-2020.11
#检查qiime2环境是否安装成功
qiime --help
```

注：

1.关闭工作环境 conda deactivate  不用QIIME 2时关闭环境，不然其它程序可能找不到或运行可能会出错

2.删除虚拟环境`conda remove -n qiime2-2020.11

# 2.qiime2背景介绍

## 2.1qiime2中的几个核心概念

### 2.1.1Data files: qiime2 artifacts

​       qiiime2为了使分析流程标准化，分析过程可重复，制定了<u>统一的分析过程文件格式.qza</u>；qza文件类似于一个封闭的文件格式(本质上是个标准格式的压缩包)，里面包括原始数据、分析的过程和结果；这样保证了文件格式的标准，同时可以追溯每一步的分析，以及图表的绘制参数。这一方案为实现可重复分析提供了基础。比如文章投稿，同时提供分析过程的文件，方便同行学习、重复结果分析以及结果的再利用。  

​        由qiime2产生的数据类型，叫<u>qiime 2对象(artifacts)</u>，通常包括<u>数据和元数据/样本信息(metadata)</u>。元数据描述数据，包括类型、格式和它如何产生。典型的扩展名为.qza。  qiime2采用对象代替原始数据文件(如fasta文件)，因此分析者必须导入数据来创建qiime2对象。

​       使用artifact(对象)一词可能产生混淆，因为其通常的意思为实验偏差的来源。我们这里artifact的意思是指被多步处理的对象。

### 2.1.2Data files: visualizations

​        qiime2生成的<u>图表结果对象或文件类型，以.qzv为扩展名，末尾的v代表visual</u>；它同qza文件类似，包括分析方法和结果，方便追溯图表是如何产生的；唯一与qza不同的，它是分析的终点，即结果的呈现，不会在流程中继续分析。可视化的结果包括统计结果表格、交互式图像、静态图片及其它组合的可视化呈现。这类文件可以使用 qiime tools view命令查看。  

​       不安装qiime2程序也可在线 https://view.qiime2.org/ 导入文件并显示结果图表，同时可查看数据分析过程。

### 2.1.3Semantic types  

​         qiime2每步分析中产生的qza文件，都有相应的语义类型，以便程序识别和分析。

​          常用的语义类型有：

| FeatureTable[Frequency]                   | 频率，即Feature表(OTU表)，为每个样品中对应OTU出现频率的表格  |
| :---------------------------------------- | :----------------------------------------------------------- |
| FeatureTable[RelativeFrequency]           | 相对频率，OTU表标准化为百分比的相度丰度                      |
| FeatureTable[PresenceAbsence]             | OTU有无表，显示样本中某个OTU有或无的表格                     |
| FeatureTable[Composition]                 | 组成表，每个样品中OTU的频率                                  |
| Phylogeny[Rooted]                         | 有根进化树                                                   |
| Phylogeny[Unrooted]                       | 无根进化树                                                   |
| DistanceMatrix                            | 距离矩阵                                                     |
| PCoAResults                               | 主成分分析结果                                               |
| SampleData[AlphaDiversity]                | Alpha多样性结果，来自样本自身的分析                          |
| SampleData[SequencesWithQuality]          | 带质量的序列，要求有质量值，要求序列名称与样品存在对应关系，如为按样品拆分后的数据格式 |
| SampleData[PairedEndSequencesWithQuality] | 成对的带质量序列，要求序列ID与样品编号有对应关系             |
| FeatureData[Taxonomy]                     | 每一个OTU/Feature的分类学信息                                |
| FeatureData[Sequence]                     | 代表性序列                                                   |
| FeatureData[AlignedSequence]              | 代表性序列进行多序列比对的结果                               |
| FeatureData[PairedEndSequence]            | 双端序列进行聚类或去噪后，分类好的OTU或Feature               |
| EMPSingleEndSequences                     | 采用地球微生物组计划标准实验方法产生的单端测序数据           |
| EMPPairedEndSequences                     | 采用地球微生物组计划标准实验方法产生的双端测序数据           |
| TaxonomicClassifier                       | 用于物种注释的分类软件                                       |

### 2.1.4Plugins

| q2-alignment          | 生成和操作多序列比对                             |
| --------------------- | ------------------------------------------------ |
| q2-composition        | 用于物种数据分析                                 |
| q2-cutadapt           | 从序列数据中删除接头序列，引物和其他不需要的序列 |
| q2-dada2              | 序列质量控制                                     |
| q2-deblur             | 序列质量控制                                     |
| q2-demux              | 混合测序样本拆分和查看序列质量                   |
| q2-diversity          | 探索群落多样性                                   |
| q2-emperor            | beta多样性3D可视化                               |
| q2-feature-classifier | 物种注释                                         |
| q2-feature-table      |                                                  |
| q2-fragment-insertion |                                                  |
|                       |                                                  |
|                       |                                                  |
|                       |                                                  |
|                       |                                                  |
|                       |                                                  |
|                       |                                                  |
|                       |                                                  |

- # 按条件操作特征表</u>
-  # 系统发育树扩展，确定准确的进化地位 
-  q2-gneiss # 构建组合模型
- q2-longitudinal # 成对样本和时间序列分析
- <u>q2-metadata # 处理元数据</u>
- <u>q2-phylogeny # 生成和操纵系统发育树</u>
- q2-quality-control # 用于特征和序列数据质量控制
- q2-quality-filter # 基于PHRED的过滤和修剪
- q2-sample-classifier # 样本元数据的机器学习预测
- <u>q2-taxa # 处理特征物种分类注释</u>
- q2-types # 定义微生物组分析的类型
-  q2-vsearch # 聚类和去冗余

 插件的功能见上方<u>qiime 插件 --help</u>弹出的信息,例如<u>qiime alignment --help</u>可以查看qiime alignment插件的功能和使用方法。下划线的插件是本次分析流程中将要用到的插件

# 3.qiime流程概述

## 3.1qiime插件工作流程概述

![搜狗截图20年12月18日1650_8](https://i.loli.net/2020/12/19/8mIeGC2x7DSBYVo.png)

-  每种类型的数据（如：对象Artifacts和可视化Visualizations）和功能action （如：方法methods、可视化工具visualizers和流程pipelines）用不同颜色的节点（即方框）代表。
-  连接节点的边分为实线（代表需要的输入或输出文件）和虚线（代表可选的输入文件）。如果没明白什么意思，可以回头读一下”核心概念”。
-  命令/动作(Actions)采用插件或动作的名称来命名。想使用这些命令，可以打开终端，在命令行中输入qiime，再配合各种功能，如qiime demux emp-single。
-  流程(Pipelines)是一种特殊的动作，即一条命令运行多个单独的命令。为了简洁，在一些流程图中，流程被标记为箱体————封装多个在内部运行的动作。
- 对象/数据(Artifacts)采用语义类型的名称来命名。可以理解为：语义类型=专业术语，或者直接理解为“概念”。
- 可视化(Visualizations)有各种名称，一些代表数据的意义，一些用表达的意义来命名。

## 3.2qiime数据分析流程概述



![搜狗截图20年12月18日1730_12](https://i.loli.net/2020/12/19/n1e5h8uQN6gMlaT.png)

黄色框代表操作方法，绿色框代表文件或数据

![搜狗截图20年12月18日1727_11](https://i.loli.net/2020/12/19/vfLsSoqcyJuCkZA.png)

- 所有数据都必须导入为qiime2对象(扩展名为.qza的文件），以便由qimm2操作使用（除了包含元数据的manifest.tsv文件和metadata.tsv文件）。

- 所有扩增子测序的分析的起点是原始序列数据。原始数据多数为fastq格式，其包含有DNA序列数据和每个碱基的质量值。  我们必须进行混合样本的样本拆分（demultiplex），以便确定每条序列来自于哪个样本。  <u>然后进行序列去噪（denoised）以获得扩增子序列变异体（amplicon sequence variants, ASVs）</u>，这样做目的有二个：⑴降低测序错误；⑵序列去冗余。特征表和代表性序列是去噪获得的关键结果，是下游分析的核心数据。一个特征表简单说就是一张Excel表，行名为ASV名称，列名为样本名。

- <u>特征（feature）是对ASV的称呼。</u>  我们可以基于特征表做很多事，常用分析包括：  序列的物种分类。比如，这里面有什么物种？  Alpha(α)和Beta(β)Z样性分析，即分别描述样本内或样本间的多样性。比如我们可以了解样本间有多少物种是一样的，即相似性如何？  许多的多样性分析依赖于个体特征的进化相似性。如果你测序的是系统发育的标记基因，如16S rRNA基因，你可以采用多序列比对方式评估特征间的系统发育关系。  不同实验组间特征的差异丰度分析，确定哪些ASVs显著的多或少。  

- ASV和OTU的概念非常重要，一定要理解清楚！！！

  qiime1使用OTU作为feature,而qiime2使用ASV作为feature,为什么？
  

### 3.2.1样本拆分（demultiplex）

![搜狗截图20年12月18日1751_13](https://i.loli.net/2020/12/19/pqEdTZyz1unW4M9.png)

- 对大多数新用户来说，数据导入和原始序列样本拆分是最头痛的部分，一定要理解清楚

- 大多数二代测序仪器有能力在单个通道（lane）／同一批次（run）中测序数百甚至数千个样本。我们通过多通道混用（multiplexing）的方法来提高检测速度，即多个样本混在一个文库中测序。既然这些来自不同样本的个读段（read）混合在一个“池”中，我们是如何知道每来个read来自哪个样本呢？这通常采用在每个序列的一端或双端附加唯一的条形码barcode（即索引index或标签tag）序列来实现区分read来源。检测这些条形码序列并将reads分类到所属的样本来源的过程就是“样本拆分”。这个过程非常类似于快递的分拣。  

- 这个流程图描述了qiime 2样本拆分的可能步骤，原始数据类型不同，步骤会有差异。通常情况下，测序公司返回的测序文件有raw.fastq和clean.fastq两种。<u>针对raw.fastq,我们需要使用q2-cutadapt去除primer、barcode等非生物序列和样本拆分方能进行下一步分析。而针对clean.fastq,我们只需要使用q2-demux进行样本拆分便可。</u>

  
  
  ### <u>3.2.2去噪（d</u>enoising)

-  挑选OTU（OTU picking)在qiime1版本时曾经是一个常用的分析步骤，对序列进行去噪，取重复和聚类，即将相似的序列归一为单个序列，一般相似性的阈值定位97%。

- 而qiime2版本中的dada2和deblur产生的“OTU”是通过对唯一序列进行分组而创建的，因此这些OTU相当于来自QIIME 1的100%相似度的OTU，通常称为扩增子序列变异体ASV。在qimme2中，dada2和deblur方法仅去噪去嵌合，不再按相似度聚类，结果与真实物种的序列更接近。这些OTU比qiime1默认的97%相似度聚类的OTU具有更高的分辨率，并且它们具有更高的质量，因为这些质量控制步骤比qiime 1中实现更好。因此，与qiime 1相比，可以对样本的多样性和分类组成进行更准确的估计。

-  见上图样本拆分和去噪工作流程的右边描述。  目前在qiime2中可用的去噪方法包括dada2和deblur。注意：从图中可以看出deblur分析之前必须进行数据质量过滤，而这个步骤对dada来说是不需要的。deblur和dada2都包含内部嵌合体检查方法和丰度过滤，因此按照这些方法不需要额外的过滤。 简而言之，这些方法滤除有噪声的序列，校正不确定序列中的错误（在dada2的分析中），去除嵌合序列，去除单体(singletons，出现频率仅有一次的序列)，合并去噪后的双端序列（在dada2的分析中），然后对这些序列进行去冗余。  

-  值得注意的是deblur去噪只针对单端数据，双端数据需要提前将序列合并后方可使用deblur去噪，而dada2适用于双端和单端数据

-  <u>综合上述分析，从去噪步骤简便角度看，优先选用dada2去噪</u>

  ### 3.2.3特征表 （feature table)

  特征表是qiime中分析的核心。几乎所有的分析步骤(除样本拆分和去噪外)都以某种方式涉及特征表。 

  ### 3.2.4物种分类和分类学分析 (taxonomy classification and taxonomic analyses)
  
  我们可以通过要查询的序列（即ASV）与具有已知分类信息的参考序列数据库进行比较来获得物种注释。仅仅找到最接近的比对结果并不一定是最好的，因为其他相同或接近的序列可能具有不同的分类注释。因此，我们使用基于比对、k-mer频率等物种分类器来确定最接近的分类学关联，并具有一定程度的置信度或一致区域（如果不能确定地预测物种名称，那么这可能不是同一物种）。
  
  ![搜狗截图20年12月19日2134_3](https://i.loli.net/2020/12/19/bwHutE3q75ypvZn.png)

- q2-feature-classifier包括三种不同的分类方法。classify-consensus-blast和classify-consensus-vsearch都是基于比对的方法，可以在N个最好的比对结果中找一致最高的用于分类。这些方法直接参考数据库FeatureData[Taxonomy]和FeatureData[Sequence]文件，不需要预先训练。  

- 基于机器学习的分类方法是通过classify-sklearn实现的。理论上讲， scikit-learn中的任何分类方法均可应用于物种分类。用于物种分类的软件或插件叫“分类器”，这些分类器因为采用了机器学习原理，在正式用于你的数据分类前必须训练这些分类器，以便让软件“学会”哪些特征可以最好地区分每个分类组。这个训练过程是在进行正式分类前额外需要的步骤。训练出来的分类器是具有“物种数据库和标记基因”特异性的。分类器一旦训练成功，只要你测序引物等测序条件没有改变，它就可以多次使用而不需要重新训练！

- 训练分类器需要用到特定的物种分类数据库（比如Greengenes database）和你自己测序时的引物序列，训练步骤是：先用引物定位Greengenes中的参考序列，然后截取出这些参考序列（截取出的参考序列长度和你测序获得的序列长度类似），然后把这些序列与物种分类名称匹配，这样就获得了“分类器”。所以分类器具有“物种数据库和标记基因”特异性。

-  本例中将 使用classify-sklearning进行分类。  所有分类器生成一个FeatureData[Taxonomy]对象，其中包含每个查询序列的物种分类信息。  

  ### 3.2.5多序列比对和进化树构建 Sequence alignment and phylogeny building  

  通常多样性分析依赖于个体特征之间的系统发育相似性。如果你正在进行系统发育标记基因测序（例如，16S rRNA基因），你可以多序列对齐(align)这些序列来评估每个特征之间的系统发育关系。然后这个系统发育树可以被其他下游分析使用，例如UniFrac距离分析。  用于对齐序列和产生系统发育的不同方法展示在下面的流程图中。

  ![搜狗截图20年12月19日2146_4](https://i.loli.net/2020/12/19/hBvaNMlFZpzwuCV.png)

### 3.2.6多样性分析 Diversity analysis

- 样本中有多少不同的物种/OTUs/ASVs？  每个样本存在多少系统发育多样性？  单个样本和样本组有多相似/不同？  哪些因素与微生物组成和多样性的差异相关呢？ 这些问题可以通过α和β多样性分析来回答。Alpha多样性测量单个样本中的多样性水平。β多样性测量样本之间的多样性或差异程度。然后我们可以使用统计检验来说明样本组之间的α多样性是否不同（例如，指出哪些组具有更多/更少的物种丰富度）以及组之间的β多样性是否显著差异（例如，确定一个组中的样本比另一个组中的样本更相似），通过这些结果来证明这些组中的成员正在形成一个特定的微生物组成。  

- 样本数据-α多样性SampleData[AlphaDiversity]对象，其中包含特征表中每个样本的α多样性估计。这是α多样性分析的核心对象。  

- 距离矩阵DistanceMatrix对象，包含特征表中每对样本之间的成对距离/差异。这是β多样性分析的核心对象。  

- 主坐标结果PCoAResults对象，包含每个距离/不同度量的主坐标排序结果。主坐标分析是一种降维技术，有助于在二维或三维空间中进行样本相似度或差异的可视化比较。

  ![搜狗截图20年12月19日2152_5](https://i.loli.net/2020/12/19/ZK1r4G75PaIVd8x.png)

# 4.分析流程

## 4.1启动qiime2运行环境

```
# 进入QIIME2 conda工作环境 
conda activate qiime2-2020.11 
# 这时我们的命令行前面出现 (qiime2-2020.2) 表示成功进入工作环境
# 创建本节学习目录 
mkdir qiime2
cd qiime2
```

## 4.2数据导入 Importing data

相关插件：qiime tools import

```
# 查看可用导入格式
qiime tools import --show-importable-formats
# 查看可用导入类型
qiime tools import --show-importable-types
```

- 本例中导入fastq数据，需要manifest file，这是一个纯文本文件，主要作用是告诉软件每个fastq数据的样本名和序列方向。导入的数据是双端序列，那么manifest file一般有3列，分别是样本id、文件名和序列方向。导入的数据如果是单端序列，manifest file一般有2列，分别是样本id和文件名。

- manifest文件基本要求如下：  1）文件必须是制表符分隔的纯文本文件，如tsv或txt文件； 2）注释行以#开头，可以出现在文中任意位置，程序会自己忽略； 3）空行也会被忽略； 第一行为表头，与QIIME1相比不再以#开头，更合理； 4）表头每列名称必须唯一，不能包括标点符号; 5）建议实验设计只使用字母和数字，任何符号在后续分析都可能会有问题 文件至少包括除表头外的一行数据； 第一列为样品名，用于标识每个样品，名字必须唯一。

- 本例使用的是双端测序数据，已知在当前工作目录下必须有fastq数据文件和导入fastq数据的manifes.tsv

- Keemei是一个用于验证示例元数据的Google Sheets插件。在开始任何分析之前，样本元数据的验证非常重要。尝试按照Keemei网站上的说明安装Keemei并验证你的manifest.tsv文件

  ```
  #获取fastq文件
  
  #获取manifest.tsv
  
  #查看清单文件
  head -n3 manifest.tsv
  ```

  清单文件内容示例

  ```
  
  ```

  注：使用此清单格式时，样本名称只能出现在一行中，并且每列只能映射到每列一个文件名（单端为一列，双端为两列）。 每个样本的绝对文件路径必须是绝对路径，它指定文件的“完整”位置。 在这里使用$ PWD变量，这意味着输入文件manifest.tsv和fastq以及输出文件都必须在当前的工作目录中。

  ```
  # 使用清单文件导入数据
  qiime tools import \
   --type 'SampleData[PairedEndSequencesWithQuality]' \
   --input-path manifest.tsv \
   --output-path paired-end-demux.qza \
   --input-format PairedEndFastqManifestPhred33V2
   # 结果可视化
   qiime demux summarize \
    --i-data paired-end-demux.qza \
    --o-visualization paired-end-demux.qzv
  
  ```

  使用https://view.qiime2.or查看qzv文件可视化结果

## 4.3序列质量控制和特征表 Sequence quality control and feature table

```
time qiime dada2 denoise-paired \
--i-demultiplexed-seqs paired-end-demux.qza \
--p-trunc-len-f 180 \
--p-trunc-len-r 180 \
--o-table dada2_table.qza \
--o-representative-sequences dada2_rep_set.qza \
--o-denoising-stats dada2_stats.qza

```

## 4.4特征表可视化

```
# 统计结果可视化
time qiime metadata tabulate \   
--m-input-file dada2_stats.qza  \   
--o-visualization dada2_stats.qzv
# 特征表摘要
time qiime feature-table summarize \   
--i-table dada2_table.qza \   
--m-sample-metadata-file metadata.tsv \   
--o-visualization dada2_table.qzv
# 代表序列
qiime feature-table tabulate-seqs \
--i-data dada2_rep_set.qza \
--o-visualization dada2_rep_set.qzv

```

## 4.5构建多样性分析所需的进化树

```
time qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences dada2_rep_set.qza \
--o-alignment aligned-rep-seqs.qza \
--o-masked-alignment masked-aligned-rep-seqs.qza \
--o-tree unrooted-tree.qza \
--o-rooted-tree rooted-tree.qza

```

## 4.6核心多样性

```
time qiime diversity core-metrics-phylogenetic \
--i-phylogeny rooted-tree.qza \
--i-table dada2_table.qza \
--p-sampling-depth 21934 \
--m-metadata-file metadata.tsv \
--output-dir core-metrics-results
```

## 4.7aphla多样性

```
# aphla多样性
qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
--m-metadata-file metadata.tsv \
--o-visualization core-metrics-results/faith-pd-group-significance.qzv
# aphla显著性分析和可视化
qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/evenness_vector.qza \
--m-metadata-file metadata.tsv \
--o-visualization core-metrics-results/evenness-group-significance.qzv
# alpha稀疏取线
time qiime diversity alpha-rarefaction \
--i-table ./dada2_table.qza \
--i-phylogeny rooted-tree.qza \
--p-max-depth 48400 \
--m-metadata-file metadata.tsv \
--o-visualization alpha-rarefaction.qzv

```

## 4.8beta多样性

```
time qiime diversity beta-group-significance \
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata.tsv \
--m-metadata-column group \
--o-visualization core-metrics-results/unweighted-unifrac-group -significance.qzv \

time qiime diversity beta-group-significance \
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata.tsv \
--m-metadata-column phenol-concentration \
--o-visualization core-metrics-results/unweighted-unifrac-phenol-concentration-significance.qzv \
--p-pairwise

time qiime diversity beta-group-significance \
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata.tsv \
--m-metadata-column septum \
--o-visualization core-metrics-results/unweighted-unifrac-septum-significance.qzv \
--p-pairwise
```

## 4.9物种注释

```
# 物种注释
time qiime feature-classifier classify-sklearn \
--i-reads dada2_rep_set.qza \
--i-classifier gg-13-8-99-nb-classifier.qza \
--o-classification taxonomy.qza
# 可视化物种注释为表
qiime metadata tabulate \
--m-input-file taxonomy.qza \
--o-visualization taxonomy.qzv
# 物种组成柱状图
qiime taxa barplot \
--i-table dada2_table.qza \   
--i-taxonomy taxonomy.qza \   
--m-metadata-file metadata.tsv \   
--o-visualization taxa-bar-plots.qzv


```

