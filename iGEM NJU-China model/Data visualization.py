import pandas as pd
import matplotlib.pyplot as plt
import jieba
from matplotlib import colors
from PIL import Image
import os
import numpy as np
from wordcloud import WordCloud

# 设置matplotlib的画图风格
plt.style.use('seaborn-darkgrid')

# 读取数据及数据清洗

# 读取csv数据，并转换时间格式
df = pd.read_csv('微博清单_RNAi_前100页.csv',parse_dates=['发布时间'])

# 查看前三行
df.head(3)

# 查看数据形状，几行几列
df.shape

# 查看重复值
df.duplicated().any()

# 查看空值
df.isna().any()

# 查看列信息
df.info()

# 可视化分析
# 解决中文显示问题
plt.rcParams['font.sans-serif'] = ['SimHei'] #显示中文标签 # 指定默认字体
plt.rcParams['axes.unicode_minus'] = False # 解决保存图像是负号'-'显示为方块的问题

#条形图
#查看TOP10点赞数
df_like_top10 = df.nlargest(n=10,columns='点赞数')
df_like_top10

#条形图-TOP10点赞数作者
plt.figure(figsize=(20,10)) # 图形大小
plt.barh(df_like_top10['微博作者'][::-1],df_like_top10['点赞数'][::-1]) #[::-1]代表倒序排列
plt.title('TOP10 liked bloggers regarding alopecia - bar chart',fontsize=20) #设置标题及标题大小
plt.xlabel('Like count') # X轴标签
plt.ylabel('Author name')  # Y轴标签
plt.savefig('TOP10 liked bloggers regarding alopecia - bar chart.png') #保存图片
plt.show()

# 环形图
# 把发布时间转换为发布日期
df['blog_date'] = df['发布时间'].dt.date
# 分组统计日期格式
df_dates = df['blog_date'].value_counts()
df_dates
# 环形图-发博日期分布
plt.figure(figsize=(12,12)) # 图形大小
plt.pie(x=df_dates.values, # 数据
        labels=df_dates.index, # 饼图标签
        pctdistance=0.9, # 数值标签相对圆心的距离
        autopct='%.2f%%', # 百分比显示格式
        wedgeprops={'width':0.4}, # 设置为环形图
        )
plt.title("Date of blogs - Doughnut Chart",fontsize=20) # 标题
plt.legend(loc='upper right',fontsize=11) # 图例及其位置
plt.savefig("Date of blogs - Doughnut Chart.png") # 保存图片
plt.show()

# 折线图
# 统计各指标的均值
df_dates_mean = df.groupby('blog_date').mean()[['转发数','评论数','点赞数']]
df_dates_mean

x_data = df_dates_mean.index.astype(str)
plt.figure(figsize=(20,8)) # 图形大小
plt.plot(x_data,df_dates_mean['转发数'],label='Forward count',marker='.',markersize=20)
plt.plot(x_data,df_dates_mean['评论数'],label='Comment count',marker='.',markersize=20)
plt.plot(x_data,df_dates_mean['点赞数'],label='Like count',marker='.',markersize=20)
plt.xlabel('Date of blogs')
plt.ylabel('Related data counts')
plt.legend()
plt.title("Forward, Comment and Like count of blog against date - line chart", fontsize=20) # 标题
plt.savefig("Forward, Comment and Like count of blog against date - line chart.png") # 保存图片
plt.show() # 显示图片

# 堆叠柱形图
data0 = df_dates_mean['转发数']
data1 = df_dates_mean['评论数']
data2 = df_dates_mean['点赞数']
data0
plt.figure(figsize=(20,12))
plt.bar(x_data,data0,width=0.5,color='silver',label='Forward count')
plt.bar(x_data,data1,width=0.5,color='gold',label='Comment count',bottom=data0)
plt.bar(x_data,data2,width=0.5,color='purple',label='Like count',bottom=data0+data1)
plt.xlabel('Date of blog')
plt.ylabel('Count')
plt.legend()
plt.title('Forward, Comment and Like count of blog against date - Stacked-Column',fontsize=20)
plt.savefig('Forward, Comment and Like count of blog against date - Stacked-Column.png')
plt.show()

# 词云图
# 读取微博内容为列表
weibo_text_list = df['微博内容'].values.tolist()
# 把列表转换为字符串
weibo_text_str = ' '.join(weibo_text_list)
# jieba分词
jieba_text = ' '.join(jieba.lcut(weibo_text_str))
# 导入停词
stop_words = open("stopwords.txt",encoding="utf-8").read().split("\n")
# 导入背景图，注意背景图除了目标形状外，其余地方都应是空白的
background = Image.open("round.jpg")
# 将背景图转换为ndarray类型的数据
graph = np.array(background)
# 设置词云中字体颜色可选择的范围
# color_list = ["#FF0000","#FF0000","#DC143C"]
# colormap = colors.ListedColormap(color_list)
# 生成词云，font_path为词云中的字体，background_colors为词云图中背景颜色
# stopwords为去掉的停词，mask为背景图，colormap为词云图颜色
word_cloud = WordCloud(font_path="C:/Windows/Fonts/simsun.ttc",
                       background_color="white",stopwords=stop_words,mask=graph)
# 生成词云
word_cloud.generate(jieba_text)

# 运用matplotlib中的相关函数生成词云
plt.figure(figsize=(12,8),dpi=800)
# 显示词云
plt.imshow(word_cloud)
# 去掉其显示的坐标轴
plt.axis("off")
# 保存词云图
plt.savefig("RNAi 词云图.png")
plt.show()