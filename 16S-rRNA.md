[TOC]

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/1.16S-rRNA%20general%20workflow.png)

# 1. 软件安装

## 1.1 qiime2 安装

### 1.1.1  minicoda 软件包管理器安装

```
# 下载 miniconda 软件管理器，将用于安装 qiime2 及依赖关系 
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 运行安装程序
bash Miniconda3-latest-Linux-x86_64.sh
# 测试 conda 是否安装成功,出现版本信息即安装成功
conda --version
# 删除安装程序
rm Miniconda3-latest-Linux-x86_64.sh
# 如果已经安装过，则升级 conda 为最新版本
conda update conda
```

注：安装过程中按提示操作： 

1. 一直按回车键查看许可协议，出现是否同意协议，输入yes同意许可协议
2. 出现是否同意安装在家目录，输入yes同意
3. 出现是否初始化，输入yes同意
4. 默认安装目录为家目录下 ''~/miniconda3 ''，也可以手动输入一个指定的安装目录，推荐按回车使用默认目录
5. miniconda3 安装成功,默认运行base包，打开终端命令行最前面会出现（base)
6. 如果运行安装没有权限，可运行  export PATH="~/miniconda3/bin:$PATH"  手动添加新安装的 miniconda3 至环境变量，或者 source ~/.bashrc 更新环境变量  
7. (可选)添加常用软件下载频道，以及国内镜像加速下载。 

```
# 添加常用下载频道 
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
conda config --show channels
```

### 1.1.2 conda 安装 qiime2 环境

```
# 首先定位到自己这个用户的位置
cd ~
# 新建一个安装 qiime2 的文件夹并进入
mkdir -p qiime2-2020.11/biosoft
cd qiime2-2020.11/biosoft
# 下载软件安装列表
wget -c https://data.qiime2.org/distro/core/qiime2-2020.11-py36-linux-conda.yml 
# 创建虚拟环境并安装 qiime2 ，防止影响其它己安装软件 （conda 主要是在系统之外再构建一个虚拟环境，操作都在虚拟环境中进行。conda 能管理不同的 Python 环境，不同的环境之间是互相隔离，互不影响的。）
conda env create -n qiime2-2020.11 --file qiime2-2020.11-py36-linux-conda.yml 
# 删除软件列表 
rm qiime2-2020.11-py36-linux-conda.yml
```

### 1.1.3 conda 操作指令

```
# 查看当前存在的虚拟环境（可以看到除了 conda 自带的 base 环境，还有已经创建的 qiime2-2020.11 虚拟环境
conda env list
# 激活 16S rRNA 分析需要的 qiime2 环境
conda activate qiime2-2020.11
# 退出 qiime2-2020.11 环境（在虚拟环境中操作完毕后，记得退出当前虚拟环境）
conda deactivate qiime2-2020.11
# 检查 qiime2 环境是否安装成功
qiime --help
```

## 1.2 sratoolkit 安装

```
# 下载 sratoolkit 安装包
# 实验数据主要来自 NCBI 数据库，NCBI 数据库提供的 sra 数据下载及格式转换的软件是 sratoolkit
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.0/sratoolkit.2.10.0-ubuntu64.tar.gz
# 解压缩
tar -xzvf sratoolkit.2.10.0-ubuntu64.tar.gz
# 文件夹重命名方便后续操作
mv sratoolkit.2.10.0-ubuntu64.tar.gz sratoolkit
# 导入临时环境变量
cd sratoolkit.2.9.6/bin
export PATH="$(pwd):$PATH"
# 检查软件是否安装成功
prefetch --help
```

也可以使用 linuxbrew 安装 sratoolkit

```
# 使用 brew 安装 sratoolkit
brew install sratoolkit
```

## 1.3 parallel 安装

```
# parallel 是进行多线程运行的工具，并行运行可以提升效率，节省时间
brew install parallel
```

# 2. qiime2 背景介绍

## 2.1 qiime2 中的几个核心概念

### 2.1.1 Data files: qiime2 artifacts

- qiiime2 为了使分析流程标准化，分析过程可重复，制定了统一的分析过程文件格式 .qza；qza 文件本质上是个标准格式的压缩包，里面包括原始数据、分析的过程和结果；这样保证了文件格式的标准，同时可以追溯每一步的分析，以及图表的绘制参数。
- 由 qiime2 产生的数据类型，叫qiime 2 对象(artifacts)，通常包括数据和元数据/样本信息 (metadata)。元数据描述数据，包括类型、格式和它如何产生。典型的扩展名为.qza。qiime2 采用对象代替原始数据文件(如  fasta 文件)，因此分析者必须导入数据来创建 qiime2 对象。
- 使用 artifact (对象)一词可能产生混淆，因为其通常的意思为实验偏差的来源。这里的 artifact 的意思是指被多步处理的对象。

### 2.1.2 Data files: visualizations

-  qiime2 生成的图表结果对象或文件类型，以 .qzv 为扩展名，末尾的v代表 visual；它同 qza 文件类似，包括分析方法和结果，方便追溯图表是如何产生的；唯一与 qza 不同的，它是分析的终点，即结果的呈现，不会在流程中继续分析。可视化的结果包括统计结果表格、交互式图像、静态图片及其它组合的可视化呈现。这类文件可以使用 qiime tools view 命令查看。  

### 2.1.3 Semantic types  

- qiime2 每步分析中产生的 qza 文件，都有相应的语义类型，以便程序识别和分析。
- 常用的语义类型有：

| FeatureTable[Frequency]                   | 频率，即 Feature 表(OTU表)，为每个样品中对应 OTU 出现频率的表格 |
| :---------------------------------------- | :----------------------------------------------------------- |
| FeatureTable[RelativeFrequency]           | 相对频率，OTU 表标准化为百分比的相度丰度                     |
| FeatureTable[PresenceAbsence]             | OTU 有无表，显示样本中某个 OTU 有或无的表格                  |
| FeatureTable[Composition]                 | 组成表，每个样品中 OTU 的频率                                |
| Phylogeny[Rooted]                         | 有根进化树                                                   |
| Phylogeny[Unrooted]                       | 无根进化树                                                   |
| DistanceMatrix                            | 距离矩阵                                                     |
| PCoAResults                               | 主成分分析结果                                               |
| SampleData[AlphaDiversity]                | Alpha多样性结果，来自样本自身的分析                          |
| SampleData[SequencesWithQuality]          | 带质量的序列，要求有质量值，要求序列名称与样品存在对应关系，如为按样品拆分后的数据格式 |
| SampleData[PairedEndSequencesWithQuality] | 成对的带质量序列，要求序列 ID 与样品编号有对应关系           |
| FeatureData[Taxonomy]                     | 每一个 OTU/Feature 的分类学信息                              |
| FeatureData[Sequence]                     | 代表性序列                                                   |
| FeatureData[AlignedSequence]              | 代表性序列进行多序列比对的结果                               |
| FeatureData[PairedEndSequence]            | 双端序列进行聚类或去噪后，分类好的 OTU或Feature              |
| EMPSingleEndSequences                     | 采用地球微生物组计划标准实验方法产生的单端测序数据           |
| EMPPairedEndSequences                     | 采用地球微生物组计划标准实验方法产生的双端测序数据           |
| TaxonomicClassifier                       | 用于物种注释的分类软件                                       |

### 2.1.4 Plugins

- 常用的插件有：


| q2-alignment          | 生成和操作多序列比对                             |
| :-------------------- | ------------------------------------------------ |
| q2-composition        | 用于物种数据分析                                 |
| q2-cutadapt           | 从序列数据中删除接头序列，引物和其他不需要的序列 |
| q2-dada2              | 序列质量控制                                     |
| q2-deblur             | 序列质量控制                                     |
| q2-demux              | 混合测序样本拆分和查看序列质量                   |
| q2-diversity          | 探索群落多样性                                   |
| q2-emperor            | beta 多样性 3D 可视化                            |
| q2-feature-classifier | 物种注释                                         |
| q2-feature-table      | 按条件操作特征表                                 |
| q2-fragment-insertion | 系统发育树扩展，确定准确的进化地位               |
| q2-gneiss             | 构建组合模型                                     |
| q2-longitudinal       | 成对样本和时间序列分析                           |
| q2-metadata           | 处理元数据                                       |
| q2-phylogeny          | 生成和操纵系统发育树                             |
| q2-quality-control    | 用于特征和序列数据质量控制                       |
| q2-quality-filter     | 基于 PHRED的过滤和修剪                           |
| q2-sample-classifier  | 样本元数据的机器学习预测                         |
| q2-taxa               | 处理特征物种分类注释                             |
| q2-types              | 定义微生物组分析的类型                           |
| q2-vsearch            | 聚类和去冗余                                     |

- 插件的功能见上方<u>qiime 插件 --help</u>弹出的信息,例如<u>qiime alignment --help</u>可以查看 qiime alignment 插件的功能和使用方法。


# 3. qiime 流程概述

## 3.1 qiime 插件工作流程概述

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/2.qiime%20plug-in%20workflow.png)

-  每种类型的数据（如：对象 Artifacts 和可视化 Visualizations ）和功能 action （如：方法 methods 、可视化工具 visualizers 和流程 pipelines ）用不同颜色的节点（即方框）代表。
-  连接节点的边分为实线（代表需要的输入或输出文件）和虚线（代表可选的输入文件）。如果没明白什么意思，可以回头读一下”核心概念”。
-  命令/动作( Actions )采用插件或动作的名称来命名。想使用这些命令，可以打开终端，在命令行中输入 qiime ，再配合各种功能，如 qiime demux emp-single 。
-  流程( Pipelines )是一种特殊的动作，即一条命令运行多个单独的命令。为了简洁，在一些流程图中，流程被标记为箱体————封装多个在内部运行的动作。
- 对象/数据(Artifacts)采用语义类型的名称来命名。可以理解为：语义类型=专业术语，或者直接理解为“概念”。
- 可视化(Visualizations)有各种名称，一些代表数据的意义，一些用表达的意义来命名。

## 3.2 qiime 数据分析流程概述

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/3.qiime%20data%20analysis%20workflow.png)

-  黄色框代表操作方法，绿色框代表文件或数据

- 所有数据都必须导入为 qiime2 对象(扩展名为 .qza 的文件），以便由 qiime2 操作使用（除了包含元数据的manifest.tsv文件和metadata.tsv文件）。

- 所有扩增子测序的分析的起点是原始序列数据。原始数据多数为 fastq 格式，其包含有 DNA 序列数据和每个碱基的质量值。然后进行混合样本的样本拆分（demultiplex），以便确定每条序列来自于哪个样本。  再进行序列去噪（denoised）以获得扩增子序列变异体（amplicon sequence variants, ASVs），这样做目的有二个：⑴降低测序错误；⑵序列去冗余。

- 特征（feature）是对 ASV 的称呼。


###    3.2.1 样本拆分（demultiplex）

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/5.sample%20demux%20and%20denoise%20workflow.png)

- 数据导入和原始序列样本拆分是最头痛的部分，一定要理解清楚
- 大多数二代测序仪器有能力在单个通道（lane）／同一批次（run）中测序数百甚至数千个样本。多通道混用（multiplexing）的方法可以提高检测速度，即多个样本混在一个文库中测序。既然这些来自不同样本的个读段（read）混合在一个“池”中， 那如何知道每来个read来自哪个样本呢？因此通常采用在每个序列的一端或双端附加唯一的条形码 barcode（即索引 index 或标签 tag ）序列来实现区分 read 来源。检测这些条形码序列并将 reads 分类到所属的样本来源的过程就是“样本拆分”。这个过程非常类似于快递的分拣。

### 3.2.2 去噪（deniosing)

- 挑选 OTU（OTU picking)在 qiime1 版本时曾经是一个常用的分析步骤，对序列进行去噪，取重复和聚类，即将相似的序列归一为单个序列，一般相似性的阈值定位97%。
- 而 qiime2 版本中的 dada2 和 deblur 产生的“OTU”是通过对唯一序列进行分组而创建的，因此这些 OTU 相当于来自 qiime1 的100%相似度的 OTU，通常称为扩增子序列变异体 ASV。在 qiime2 中，dada2 和 deblur 方法仅去噪去嵌合，不再按相似度聚类，结果与真实物种的序列更接近。
- 见上图样本拆分和去噪工作流程的右边描述。  目前在 qiime2 中可用的去噪方法包括 dada2 和 deblur。注意：从图中可以看出 deblur 分析之前必须进行数据质量过滤，而这个步骤对 dada 来说是不需要的。deblur 和 dada2 都包含内部嵌合体检查方法和丰度过滤，因此按照这些方法不需要额外的过滤。 简而言之，这些方法滤除有噪声的序列，校正不确定序列中的错误（在 dada2 的分析中），去除嵌合序列，去除单体(singletons，出现频率仅有一次的序列)，合并去噪后的双端序列（在 dada2 的分析中），然后对这些序列进行去冗余。因此，dada2 的去噪效果比 deblur 的去噪效果好。
- deblur 去噪只针对单端数据，双端数据需要提前将序列合并后方可使用 deblur 去噪，而 dada2 适用于双端和单端数据
- 通常情况下，测序公司返回的测序文件有 raw.fastq 和 clean.fastq 两种。针对 raw.fastq ,如果使用 deblur 去噪，我们需要使用 q2-cutadapt 去除 primer、barcode 等非生物序列和使用 q2-demux 进行样本拆分方能进行下一步分析；如果使用 dada2 去噪，我们不需要使用 q2-cutadapt 去除非生物序列，直接使用 q2-demux 进行样本拆分便可，因为 dada2 具有修剪非生物序列的功能。
- <u>综合上述分析，从去噪步骤简便角度看，优先选用 dada2 去噪</u>。

### 3.2.3 特征表 （feature table)

- 特征表是 qiime 中分析的核心。几乎所有的分析步骤(除样本拆分和去噪外)都以某种方式涉及特征表。 

### 3.2.4 物种分类和分类学分析 (taxonomy classification and taxonomic analyses)

- 通过要查询的序列（即ASV）与具有已知分类信息的参考序列数据库进行比较来获得物种注释。仅仅找到最接近的比对结果并不一定是最好的，因为其他相同或接近的序列可能具有不同的分类注释。因此，使用基于比对、k-mer 频率等物种分类器来确定最接近的分类学关联，并具有一定程度的置信度或一致区域（如果不能确定地预测物种名称，那么这可能不是同一物种）。
- q2-feature-classifier 包括三种不同的分类方法。
- classify-consensus-blast 和 classify-consensus-vsearch 都是基于比对的方法，可以在N个最好的比对结果中找一致最高的用于分类。这些方法直接参考数据库 FeatureData[Taxonomy] 和 FeatureData[Sequence] 文件，不需要预先训练。  
- 基于机器学习的分类方法是通过 classify-sklearn 实现的。理论上讲， scikit-learn 中的任何分类方法均可应用于物种分类。用于物种分类的软件或插件叫“分类器”，
- 训练分类器需要用到特定的物种分类数据库（比如Greengenes database）和你自己测序时的引物序列，训练步骤是：先用引物定位 Greengenes 中的参考序列，然后截取出这些参考序列（截取出的参考序列长度和你测序获得的序列长度类似），然后把这些序列与物种分类名O称匹配，这样就获得了“分类器”。所以分类器具有“物种数据库和标记基因”特异性
- 本例中将 使用 classify-sklearning 进行分类。  所有分类器生成一个 FeatureData[Taxonomy] 对象，其中包含每个查询序列的物种分类信息。

### 3.2.5 进化树构建  phylogeny building  

- 为了生成系统发育树，我们将使用 q2-phylogeny 插件中的 align-to-tree-mafft-fasttree 工作流程。  首先，工作流程使用 maft 程序执行对 featuredata[sequence] 中的序列进行多序列比对，以创建 featuredata[alignedsequence] 。 接下来，流程过滤对齐的的高度可变区(高变区)，这些位置通常被认为会增加系统发育树的噪声。随后，流程应用 fasttree 基于过滤后的比对结果生成系统发育树。fasttree 程序创建的是一个无根树，因此在本流程的最后一步中，应用根中点法将树的根放置在无根树中最长端到端距离的中点，从而形成有根树。

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/7.Sequence%20alignment%20and%20phylogeny%20building%20.png)

### 3.2.6 多样性分析 Diversity analysis

- Alpha 多样性测量单个样本中的多样性水平，其多样性指数是反映样本中微生物丰富度和均匀度的综合指标。β多样性测量样本之间的多样性或差异程度。可以用 features（ASV）的丰度信息进行样本间距离计算， 也可以用 features（ASV）之间的系统发生关系进行计算。

1. α多样性 

 Shannon’s diversity index ：定量群落丰富度的指数，包括丰富度（richness）和均匀度（evenness）两个层面.

 Observed OTUs ：一种群落丰富度的定性方法

 Faith’s系统发育多样性：结合群落特征之间的系统发育关系的对群落丰富度进行定性

 均匀度 Evenness 或 Pielou’s 均匀度：度量群落均匀度

2. β多样性 

Jaccard 距离：一种群落差异的定性指数，即只考虑种类，不考虑丰度

Bray-Curtis 距离：一种群落差异的定量方法

UniFrac 是用于比较生物群落的一种距离度量，它在计算过程中包含了遗传距离（phylogenetic distances）的信息, 根据构建的进化树枝的长度计量两个不同环境样品之间的差异。

非加权 UniFrac 距离（ unweighted UniFrac distance）：结合群落特征之间的系统发育关系对群落差异度进行定性。

加权 UniFrac 距离（weighted UniFrac distance )：结合群落特征之间的系统发育关系对群落差异度进行定量。

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/8.%20Diversity%20analysis%20workflow.png)

其中 Unweighted UniFrac distance 只考虑了物种在样本中是否存在，因此结果中，0表示两个微生物群落间 ASV的种类一致。而 Weighted UniFrac distance  则同时考虑物种的存在及其丰度，结果中的0则表示群落间 ASV 的种类和数量都一致。

# 4. 单项数据分析

## 4.1 启动 qiime2 运行环境

```
# 进入 qiime2 conda工作环境 
conda activate qiime2-2020.11 
# 这时我们的命令行前面出现 (qiime2-2020.11) 表示成功进入工作环境
# 定位到当前用户工作目录
cd ~
# 创建本节学习目录并进入
mkdir -p qiime2-2020.11/project1
cd qiime2-2020.11/project1
```

## 4.2 数据下载

### 4.2.1 分类器下载

- 在 qiime 官方文档    https://docs.qiime2.org/2020.11/   中可以看到可供下载的 16s 数据库有 greengene 和silva。并且两种数据库都有基于全长和基于可变区进行训练的分类器，通常选择基于全长进行训练,因为即使测的可变区对用全长训练也没有较大影响。

- Greengene 数据库是针对细菌和古菌 16S rRNA 基因的数据库。由于是人工整理，比较准确。很多科研工作者选择使用该数据库。分类层级采用常用的七级：界门纲目科属种，方便理解和阅读。同时，qiime软件默认物种注释数据库也是它。

- Silva 数据库是一个包含三域微生物（细菌，古菌，真核）rRNA基因序列的综合数据库。其数据库涵盖了原核和真核微生物的小亚基 rRNA 基因序列（简称SSU，即16S和18SrRNA）和大亚基 rRNA 基因序列（简称LSU，即23S和28SrRNA）。由于是最大最全的数据库，其缺点是假阳性会更高。另一方面，它的物种注释采用的是14层级，且与常用的七级不同，不能转化和比较。

- 通过阅读本例的参考文献 Comparative Analysis of Soil Microbiome Profiles in the Companion Planting of White Clover and Orchard Grass Using 16S rRNA Gene Sequencing Data 得知，本次测试的数据主要是相同条件下 White clover 单独种植，Orchard Grass 单独种植和两者共同种植的三组不同的微生物组。因此选用 greengene 数据库。（注：如果涉及到测血液中的微生物选用silva数据库）

  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/12.png)

  ```
  # 下载物种注释数据库制作的 greengene 分类器
  wget \   
  -O "gg-13-8-99-nb-classifier.qza" \   
  "https://data.qiime2.org/2020.2/common/gg-13-8-99-nb-classifier.qza"
  ```

### 4.2.2 实验数据来源

- 这里的实验数据主要来自于文献 Comparative Analysis of Soil Microbiome Profiles in the Companion Planting of White Clover and Orchard Grass Using 16S rRNA Gene Sequencing Data 。

  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/9.data%20achieve.png)

- 文献末尾有实验测序数据来源链接，打开链接   https://www.ncbi.nlm.nih.gov/sra/PRJNA625872   可以看到数据在 NCBI 网站上并且共有27个 sra 数据 。按照图中的步骤，点击右上方的 send to ,在弹出来的窗口中选择 file 和 accession list,最后点击 creat file，得到一个名为 “SraAccList.txt” 的文件。打开文件是一列 sra 数据编号 

  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/10.data%20achieve.png)

- 采用 sratoolkit 工具包中的 prefetch 工具，可以下载 NCBI 数据库提供的 sra 数据，输入命令 prefetch --help 可以查看其用法，本例先以27个 sra 数据中编号为 SRR11573560 的 sra 数据为例。 运行命令如下

  ```
  # 下载实验数据
  prefetch SRR11573560
  ```
  
- 下载完成之后并不是本例所需要的 .fastq 格式的文件，而是 .sra 格式的文件，所以需要进行格式转换，可以使用 sratoolkit 工具包里面的 fastq-dump 工具来进行格式转化。输入命令 fastq-dump --help 查看其用法。在转换文件格式前要清楚sra文件是单端测序数据还是双端测序数据，本例是单端测序数据。使用 fastq-dump 命令。

  ```
  # 将 sra 格式的文件转换为 fastq 格式的文件
  fastq-dump SRR11573560
  # 查看 fastq 文件
  head -n 20 SRR11573560.fastq
  ```

## 4.3 数据导入 Importing data

- 相关插件：qiime tools import


```
# 查看可用导入格式
qiime tools import --show-importable-formats
# 查看可用导入类型
qiime tools import --show-importable-types
```

- 本例中导入 fastq 数据，需要 manifest 文件，这是一个纯文本文件，主要作用是告诉软件每个 fastq 数据的样本名和序列方向。导入的数据是双端序列，那么 manifest 文件一般有3列，分别是样本 id 、文件名和序列方向。导入的数据如果是单端序列，manifest 文件一般有2列，分别是样本 id 和文件名。

- manifest 文件基本要求如下： 

  1. 文件必须是制表符分隔的纯文本文件，如 tsv 或 txt 文件； 

  2. 注释行以 # 开头，可以出现在文中任意位置，程序会自己忽略； 

  3. 空行也会被忽略；

  4. 表头每列名称必须唯一，不能包括标点符号; 

  5. 建议 manifest 文件只使用字母和数字，任何符号在后续分析都可能会有问题 。

- 已知本例使用的是单端测序数据且当前工作目录下必须有 fastq 数据文件和导入 fastq 数据的 manifes.tsv

- 可知样本数据共有27个，这里以SRR11573560.fastq为例子

  ```
  # 用制表分隔符即 tab 键创建一个 manifest.tsv 文件，示例如下
  sample-id	absolute-filepath
  SRR11573560 	$PWD/SRR11573560.fastq
  # 查看清单文件
  head manifest.tsv
  ```

  注：使用此清单格式时，样本名称只能出现在一行中，并且每列只能映射到每列一个文件名（单端为一列，双端为两列）。 每个样本的绝对文件路径必须是绝对路径，它指定文件的“完整”位置。 在这里使用$PWD变量，这意味着输入文件 manifest.tsv 和 fastq 以及输出文件都必须在当前的工作目录中。

  ```
  # 使用清单文件导入 fastq 数据
  qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest.tsv \
  --output-path demux.qza \
  --input-format SingleEndFastqManifestPhred33V2
  # 结果可视化
  qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv
  ```

- 得到的 demux.qzv 文件可以查看样本的序列和测序深度，它提供每个样本中序列数及序列质量的信息。

- [demux.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/single/demux.qzv?raw=true)

  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/13.png)

  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/14.png)

##  4.4 序列质量控制和特征表 Sequence quality control and feature table

- 由前面分析可知，这里使用 dada2 进行质量控制并且本例数据为单端测序的数据，因此使用命令 qiime dada2 denoise-single。在本例中，从上图可以看到质量得分在测序运行中相对均匀分布并且大部分序列在416bp以上，因此选择416bp。如果质量得分在左侧有大幅度下降，那么使用 --p-trim-left 命令时应裁掉质量得分成下降趋势的一部分。

```
# 序列质控
qiime dada2 denoise-single \
--i-demultiplexed-seqs demux.qza \
--p-trim-left 0 \
--p-trunc-len 416 \
--o-table table.qza \
--o-representative-sequences rep-seqs.qza \
--o-denoising-stats stats.qza
# 去噪过程统计结果可视化
time qiime metadata tabulate \
--m-input-file stats.qza \
--o-visualization stats.qzv
#提取table.tsv文件
bash table.sh stats.qzv >table.tsv
# 特征表摘要可视化
qiime feature-table summarize \
--i-table table.qza \
--o-visualization table.qzv \
--m-sample-metadata-file table.tsv
# 代表序列
qiime feature-table tabulate-seqs \
--i-data rep-seqs.qza \
--o-visualization rep-seqs.qzv
```

- stats.qzv 文件可视化可以看到包含样品元数据 sampl-id 和去噪过程中有多少条序列被过滤等信息。

-  table.qzv 文件可视化中可以看到去噪得到的 ASV 即 feature-id 以及每个 ASV 被测到的次数

- rep-seqs.qzv 文件可视化后可以看到 ASV 对应的序列信息并且点击这些序列可以在 NCBI 数据库中找到

- [stats.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/single/stats.qzv?raw=true)             

  [rep-seqs.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/single/rep-seqs.qzv?raw=true)

  [table.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/single/table.qzv?raw=true)

## 4.5 物种注释

```
# 物种注释
qiime feature-classifier classify-sklearn \
 --i-reads rep-seqs.qza \
 --i-classifier gg-13-8-99-nb-classifier.qza \
 --o-classification taxonomy.qza
# 物种注释可视化
qiime metadata tabulate \
--m-input-file taxonomy.qza \
--o-visualization taxonomy.qzv
#提取taxonomy.tsv文件
bash taxonomy.sh taxonomy.qzv >taxonomy.tsv
# 物种组成柱状图
qiime taxa barplot \
 --i-table table.qza \
 --i-taxonomy taxonomy.qza \
 --m-metadata-file table.tsv \
 --o-visualization taxa-bar-plots.qzv
```

- 物种注释后得到的 taxonomy.qzv 文件可视化后可以看到每个 ASV (feature-id) 对应的物种注释信息，分类方式主要为 kingdom (界)、phylum (门)、class (纲)、orde (目）、family (科)、genus (属)、species (种）

- 物种组成柱状图能够更明显的看出注释出的物种的相对丰度(图中所给的是种水平)

  [taxonomy.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/single/taxonomy.qzv?raw=true)

  [taxa-bar-plots.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/single/taxa-bar-plots.qzv?raw=true)


# 5. 多项数据分析

## 5.1 启动 qiime2 运行环境

```
# 进入 qiime2 conda工作环境 
conda activate qiime2-2020.11 
# 这时我们的命令行前面出现 (qiime2-2020.11) 表示成功进入工作环境
# 定位到当前用户工作目录
cd ~
# 创建本节学习目录并进入
mkdir -p qiime2-2020.11/project2
cd qiime2-2020.11/project2
```

## 5.2 数据下载

### 5.2.1 分类器下载

```
# 下载物种注释数据库制作的 greengene 分类器
wget \   
-O "gg-13-8-99-nb-classifier.qza" \   
"https://data.qiime2.org/2020.2/common/gg-13-8-99-nb-classifier.qza"
# 或者复制粘贴 4.2.1 已经下载的分类器
cp -r ~/qimme2-2020.11/project1/gg-13-8-99-nb-classifier.qza ~/qiime2-2020.11/project2
```

### 5.2.2 实验数据来源

```
# 共27组数据，复制4.2.2得到的 SRR_Acc_List.txt 文件
cp -r ~/qimme2-2020.11/project1/SRR_Acc_List.txt ~/qiime2-2020.11/project2
# 使用 sratoolkit 中的 prefetch 工具下载数据
prefetch --option-file SRR_Acc_List.txt &
# 将 sra 文件转化为 fastq  文件
parallel -j 4 "
    fastq-dump  {1}
" ::: $(ls *.sra)
# 删除 sra 文件
rm *.sra
```

### 5.3 数据导入

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/22.png)

![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/picture/21.png)

```
# 将得到的27个 fastq 文件按照NCBI样品信息界面的编号与样本名一一对应的关系将fastq文件改名，方便后续进行多样性分析。
# 由上述文献可知，O1-O9,W1-W9,M1-M9分别是 Orchard Grass 样本，White clover 样本和混合样本
并且原文中去掉了 W1 W3 O1 O6 M6 M9 样本
# 用制表分隔符即 tab 键创建一个 manifest.tsv 文件，示例如下
sample-id	absolute-filepath
W2	$PWD/W2.fastq
W4	$PWD/W4.fastq
W5	$PWD/W5.fastq
W6	$PWD/W6.fastq
W7	$PWD/W7.fastq
W8	$PWD/W8.fastq
W9	$PWD/W9.fastq
O2	$PWD/O2.fastq
O3	$PWD/O3.fastq
O4	$PWD/O4.fastq
O5	$PWD/O5.fastq
O7	$PWD/O7.fastq
O8	$PWD/O8.fastq
O9	$PWD/O9.fastq
M1	$PWD/M1.fastq
M2	$PWD/M2.fastq
M3	$PWD/M3.fastq
M4	$PWD/M4.fastq
M5	$PWD/M5.fastq
M7	$PWD/M7.fastq
M8	$PWD/M8.fastq
# 查看清单文件
head  manifest.tsv
#使用清单文件导入fastq数据
qiime tools import \
--type 'SampleData[SequencesWithQuality]' \
--input-path manifest.tsv \
--output-path demux.qza \
--input-format SingleEndFastqManifestPhred33V2
#结果可视化
qiime demux summarize \
--i-data demux.qza \
--o-visualization demux.qzv
# 使用https://view.qiime2.or查看qzv文件可视化结果
```

- [demux.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/demux.qzv?raw=true)

## 5.4 序列质量控制和特征表

```
# 序列质控
qiime dada2 denoise-single \
--i-demultiplexed-seqs demux.qza \
--p-trim-left 0 \
--p-trunc-len 416 \
--o-table table.qza \
--o-representative-sequences rep-seqs.qza \
--o-denoising-stats stats.qza
# 去噪过程统计结果可视化
time qiime metadata tabulate \
--m-input-file stats.qza \
--o-visualization stats.qzv
#提取table.tsv文件
bash table.sh stats.qzv >table.tsv
# 特征表摘要可视化
qiime feature-table summarize \
--i-table table.qza \
--o-visualization table.qzv \
--m-sample-metadata-file table.tsv
# 代表序列
qiime feature-table tabulate-seqs \
--i-data rep-seqs.qza \
--o-visualization rep-seqs.qzv
```

- metadata.tsv 文件中需要有 categorical（无数字）和numeric（有数字）两种类型的数据，查看 metadata.tsv 文件可知，其中只有 numeric  类型数据 ，因此需要加入 categorical 类型数据 ，本例中可加入的 categories 类型数据有对照变量，即 OrchardGrass  、White clover 和 mixed。

- table.qzv 文件可视化后可以看到测序量最大的样本是 M8 样本，测序量为29603。测序量最小的样本是 O3 样本，测序量为 18930

- rep-seqs.qzv 文件可视化后可以看到 ASV 对应的序列信息并且点击这些序列可以在 NCBI 数据库中找到。

- [stats.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/stats.qzv?raw=true)

  [table.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/table.qzv?raw=true)

  [rep-seqs.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/rep-seqs.qzv?raw=true)

## 5.5 物种注释

```
# 物种注释
qiime feature-classifier classify-sklearn \
 --i-reads rep-seqs.qza \
 --i-classifier gg-13-8-99-nb-classifier.qza \
 --o-classification taxonomy.qza
# 物种注释可视化
qiime metadata tabulate \
--m-input-file taxonomy.qza \
--o-visualization taxonomy.qzv
#提取taxonomy.tsv文件
bash taxonomy.sh taxonomy.qzv >taxonomy.tsv
# 物种组成柱状图
qiime taxa barplot \
 --i-table table.qza \
 --i-taxonomy taxonomy.qza \
 --m-metadata-file table.tsv \
 --o-visualization taxa-bar-plots.qzv
```

- 物种注释后得到的 taxonomy.qzv 文件可视化后可以看到每个 ASV (feature-id) 对应的物种注释信息

- 物种组成柱状图能够更明显的看出注释出的物种的相对丰度（图中所给的是纲水平）

- [taxonomy.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/taxonomy.qzv?raw=true)

  [taxa-bar-plots.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/taxa-bar-plots.qzv?raw=true)


## 5.6 核心多样性

```
# 构建进化树用于多样性分析
time qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences rep-seqs.qza \
--o-alignment aligned-rep-seqs.qza \
--o-masked-alignment masked-aligned-rep-seqs.qza \
--o-tree unrooted-tree.qza \
--o-rooted-tree rooted-tree.qza
# 核心多样性
time qiime diversity core-metrics-phylogenetic \
--i-phylogeny rooted-tree.qza \
--i-table table.qza \
--p-sampling-depth 14639 \
--m-metadata-file table.tsv \
--output-dir core-metrics-results
```

- aphla 和 beta 多样性分析，需要基于 rarefaction 标准化的特征表，标准化采用无放回重抽样至序列一致。其中需要用到样品重采样深度参数 --p-sampling-depth。查看 table.qzv，如果数据量都很大，选最小的即可。如果有个别数据量非常小，去除最小值再选最小值。如此既保留了大部分样品用于分析，又去除了数据量过低的异常值。此例中数据量都很大，因选择最小的14639深度重采样。

- [bray_curtis_emperor.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/bray_curtis_emperor.qzv?raw=true)

  [jaccard_emperor.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/jaccard_emperor.qzv?raw=true)

  [unweighted_unifrac_emperor.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/unweighted_unifrac_emperor.qzv?raw=true)

  [weighted_unifrac_emperor.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/weighted_unifrac_emperor.qzv?raw=true)

## 5.7 aphla 多样性

```
# aphla 多样性
qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
--m-metadata-file table.tsv \
--o-visualization core-metrics-results/faith-pd-group-significance.qzv
# aphla 显著性分析和可视化
qiime diversity alpha-group-significance \
--i-alpha-diversity core-metrics-results/evenness_vector.qza \
--m-metadata-file table.tsv \
--o-visualization core-metrics-results/evenness_group_significance.qzv
# aphla 稀疏取线
time qiime diversity alpha-rarefaction \
--i-table table.qza \
--i-phylogeny rooted-tree.qza \
--p-max-depth 22000 \
--m-metadata-file table.tsv \
--o-visualization alpha-rarefaction.qzv
```

- 使用 qiime diversity alpha-rarefaction 可视化工具来探索 α 多样性与采样深度的关系。


该可视化工具在多个采样深度处计算一个或多个α多样性指数，范围介于最小采样深度 --p-min-depth 和最大采样深度 --p-max-depth 之间。在每个采样深度，将生成10个抽样表，并对表中的所有样本计算alpha多样性指数计算。在每个采样深度，将为每个样本绘制平均多样性值，如果提供样本元数据 --m-metadata-file 参数，则可以基于元数据对样本进行分组。本例中将最大深度设置为接近最大序列数2200。

alpha-rarefaction.qzv 文件可视化将显示两个图。第一个图将显示作为采样深度函数的 α 多样性（shannon）。这用于基于采样深度确定丰富度或均匀度是否已饱和。当接近最大采样深度时，稀疏曲线变得平稳。第二个图显示了每个采样深度的每个元数据类别组中的样本数。这对于确定样本丢失的采样深度以及元数据列组值是否存在偏差非常有用。

- [faith-pd-group-significance.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/faith-pd-group-significance.qzv?raw=true)

  [evenness-group-significance.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/evenness_group_significance.qzv?raw=true)

  [alpha-rarefaction.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/alpha-rarefaction.qzv?raw=true)
  
  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/picture/faith.svg)
  
  ![Image text](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/picture/evenness.svg)
  

## 5.8 beta 多样性

```
# unweighted unifrac
time qiime diversity beta-group-significance \
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file metadata.tsv \
--m-metadata-column group \
--o-visualization core-metrics-results/unweighted_unifrac_group_significance.qzv \
--p-pairwise
# weighted unifrac
time qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column group \
  --o-visualization core-metrics-results/weighted_unifrac_group_significance.qzv
```

- [unweighted_unifrac_group_significance.qzv 下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/unweighted_unifrac_group_significance.qzv?raw=true)

  [weighted_unifrac_group_significance.qzv下载](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/core-metrics-results/weighted_unifrac_group_significance.qzv?raw=true)
  
  [unweighted-beta.pdf查看](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/picture/unweight_beta.pdf?raw=true)
  
  [weighted-beta.pdf查看](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/picture/weight_beta.pdf?raw=true)

## 5.9 ANCOM 差异丰度分析

```
# 按属比较，需要先合并
time qiime taxa collapse \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table table-l6.qza
# 格式转换
time qiime composition add-pseudocount \
  --i-table table-l6.qza \
  --o-composition-table comp-table-l6.qza
# 差异比较
time qiime composition ancom \
  --i-table comp-table-l6.qza \
  --m-metadata-file table.tsv \
  --m-metadata-column group \
  --o-visualization l6-ancom-group.qzv  
# 分类学差异直接有名称，不用feature再对应物种注释
```

- [ l6-ancom-group.qzv下载 ](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/l6-ancom-group.qzv?raw=true)

  ![Iamge text](https://github.com/syq12345678/16S-rRNA/blob/master/prepare/more/picture/ancom.png)

## 5.10 使用R进行微生物组分析

```
# 定位到当前用户工作目录
cd ~
cd qiime2-2020.11/project3
# 运行 R
Rscript
# 安装 phyloseq 和 microbioprocess
if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")
BiocManager::install("MicrobiotaProcess")
if(!requireNamespace("BiocManager")){
  install.packages("BiocManager")
}
BiocManager::install("phyloseq")

# 安装 tidyverse 和 rcolorbrewer
install.packages(c( "tidyverse", "RColorBrewer"), repos = "http://cran.rstudio.com", dependencies = TRUE)
# 载入包
library(MicrobiotaProcess)
library(phyloseq)
library(tidyverse)
library(RColorBrewer)
# 载入数据
otu <- "table.qza"
tree <- "rooted-tree.qza"
tax <- "taxonomy.qza"
sample <- "table.tsv"
ps_dada2 <- import_qiime2(otuqza=otu, taxaqza=tax,
                       mapfilename=sample,treeqza=tree)
ps_dada2 
```





引用自：

qiime2官方文档

conda官方文档

中科院刘永鑫博士的博客