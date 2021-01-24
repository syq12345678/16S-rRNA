```
#!/usr/bin/env bash

usage () { echo "bash uzcat.sh <stats.qzv> [metadata.tsv]" 1>&2; exit; }
[ $# -lt 1 ] && usage

ZIP_FILE=$1
PATTERN=${2:-metadata.tsv}

if [ ! -e ${ZIP_FILE} ]; then
    echo 1>&2 "[${ZIP_FILE}] is not a file" 1>&2; exit;
fi

MATCHED=$(unzip -Z1 ${ZIP_FILE} | grep -w "${PATTERN}" | head -n 1)

if [ "${MATCHED}" == "" ]; then
    echo 1>&2 "[${PATTERN}] can't be found" 1>&2; exit;
fi

unzip -p ${ZIP_FILE} ${MATCHED}
```



```
#!/usr/bin/env bash
从PATH环境变量中查找bash解释器，并使用bash解释器执行该脚本


在脚本中, 第一行以 #! 开头的代码, 在计算机行业中叫做 "shebang",  其作用是"指定由哪个解释器来执行脚本".

#!/usr/bin/bash采用了绝对路径的写法，即指定了采用/usr/bin/bash 解释器来执行该脚本。但是如果bash解释器不在该路径下的话，./file.sh 就无法运行。
而 #!/usr/bin/env bash 从PATH环境变量中来查找bash解释器的位置，因此只要环境变量中存在，该脚本即可执行。 
一般情况下采用 #!/usr/bin/env bash的写法更好。

```



```
usage () { echo "bash uzcat.sh <stats.qzv> [metadata.tsv]" 1>&2; exit; }
[ $# -lt 1 ] && usage
usage函数：打印 bash uzcat.sh <stats.qzv> [metadata.tsv] ，标准输出重定向输出到标准错误输出， 退出脚本
脚本的参数总数小于1，执行usage函数


usage()一般是程序里自定义来提示用户怎么使用程序，是一个自定义函数。用法
function 函数名 () { 语句 }
关键字function表示定义一个函数，可以省略，其后是函数名，有时函数名后可以跟一个括号，符号“{”表示函数执行命令的入口，该符号也可以在函数名那一行，“}”表示函数体的结束，两个大括号之间是函数体。  语句部分可以是任意的Shell命令，也可以调用其他的函数。  
如果在函数中使用exit命令，可以退出整个脚本，通常情况，函数结束之后会返回调用函数的部分继续执行。

;在单行语句中使用，用于区分不同命令
echo用于字符串的输出
在双引号中，除了$, '', `和\以外所有的字符都解释成字符本身。  
在单引号中所有的字符包括特殊字符（$,'',`和\）都将解释成字符本身而成为普通字符。  
在反引号中的字符串将解释成shell命令来执行。
bash uzcat.sh  执行名为 uzcat.sh 的脚本
<  从文件 读入 命令输入
>  将命令输出 写入  文件
1>&2  标准输出重定向到标准错误输出。 1>&2即 >&2 也就是把结果输出到和标准错误一样；之前如果有定义标准错误重定向到某log文件，那么标准输出也重定向到这个log文件
& 是一个描述符，如果1或2前不加&，会被当成一个普通文件

[ ] 用于算数比较，文件属性测试，字符串比较等
$# 是传给脚本的参数个数
-lt 小于
&& 左边的命令（命令1）返回真(即返回0，成功被执行）后，&&右边的命令（命令2）才能够被执行。
```



```
ZIP_FILE=$1
PATTERN=${2:-metadata.tsv}
$1赋值给ZIP_FILE
如果$2 没有设定或者为空值，那么metadata.tsv赋值给PATTERN


$1 是传递给该shell脚本的第一个参数 
$2 是传递给该shell脚本的第二个参数
=  用于判断变量是否相等外以及对变量进行赋值
${ }变量替换

${var:-value}   # var为空或未设置，则返回value；有值则返回var的值
PATTERN=${2:-metadata.tsv} 如果$2 没有设定或者为空值，则是使用metadata.tsv作传回值
```



```
if [ ! -e ${ZIP_FILE} ]; then
    echo 1>&2 "[${ZIP_FILE}] is not a file" 1>&2; exit;
fi
如果${ZIP_FILE}不存在，标准输出重定向输出到标准错误输出，打印[${ZIP_FILE}] is not a file ，标准输出重定向输出到标准错误输出，然后退出脚本


if条件语句的格式
if <条件表达式>;then
　　指令
fi

！逻辑非
-e  文件解释符
[ ] 用于算数比较，文件属性测试，字符串比较等
${ }变量替换
;在单行语句中使用，用于区分不同命令
1>&2  标准输出重定向到标准错误输出
```



```
MATCHED=$(unzip -Z1 ${ZIP_FILE} | grep -w "${PATTERN}" | head -n 1)
查看压缩文件的所有文件名，查找metadata.tsv，只显示头一行，这三个命令替换为MATCHED


= 赋值
$( )命令替换
用管道符 | 连接的命令，命令 1 的正确输出作为命令 2 的操作对象。这里需要注意，命令 1 必须有正确输出，而命令 2 必须可以处理命令 1 的输出结果；而且命令 2 只能处理命令 1 的正确输出，而不能处理错误输出。
unzip -Z1 file.zip  查看压缩文件的所有文件名
grep -w 用于字符串精确匹配
head -n 1显示开头一行
```



```
if [ "${MATCHED}" == "" ]; then
    echo 1>&2 "[${PATTERN}] can't be found" 1>&2; exit;
fi
如果${MATCHED}为空，标准输出重定向输出到标准错误输出，打印[${PATTERN}] can't be found，标准输出重定向输出到标准错误输出，退出


if条件语句的格式
if <条件表达式>;then
　　指令
fi
[ ] 用于字符串比较
== 可用于判断变量是否相等
```



```
unzip -p ${ZIP_FILE} ${MATCHED}
解压压缩文件，将解压缩的结果显示到屏幕上，但不会执行任何的转换，查看压缩文件的所有文件名，查找metadata.tsv，只显示头一行

unzip -p   将解压缩的结果显示到屏幕上，但不会执行任何的转换
${ }变量替换
```

