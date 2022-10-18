import os
import re #正则表达式提取文本
from jsonpath import jsonpath #解析json数据
import requests #发送请求
import pandas as pd #存取csv文件
import datetime #转换时间用

def trans_time(v_str):
	"""转换GMT时间为标准格式"""
	GMT_FORMAT = '%a %b %d %H:%M:%S +0800 %Y'
	timeArray = datetime.datetime.strptime(v_str, GMT_FORMAT)
	ret_time = timeArray.strftime("%Y-%m-%d %H:%M:%S")
	return ret_time

def get_weibo_list(v_keyword,v_max_page):
    headers = {
	    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36",
	    "accept": "application/json, text/plain, */*",
	    "accept-encoding": "gzip, deflate, br",
    }
    for page in range(1,v_max_page + 1):
        print('===开始爬取第{}页微博==='.format(page))
        # 请求地址
        url = 'https://m.weibo.cn/api/container/getIndex'
        # 请求参数
        params = {
	        "containerid": "100103type=1&q={}".format(v_keyword),
	        "page_type": "searchall",
	        "page": page
        }
        # 发送请求
        r = requests.get(url, headers=headers, params=params)
        print(r.status_code)
        # 解析json数据
        cards = r.json()["data"]["cards"]
        # 微博内容
        text_list = jsonpath(cards, '$..mblog.text')
        #微博内容-正则表达式数据清洗
        dr = re.compile(r'<[^>]+>',re.S)
        text2_list = []
        print('text_list is:')
        print(text_list)
        if not text_list:  # 如果未获取到微博内容，进入下一轮循环
            continue
        if type(text_list) == list and len(text_list) > 0:
            for text in text_list:
                text2 = dr.sub('',text)  # 正则表达式提取微博内容
                print(text2)
                text2_list.append(text2)
        # 微博创建时间
        time_list = jsonpath(cards, '$..mblog.created_at')
        time_list = [trans_time(v_str=i) for i in time_list]
        # 微博作者
        author_list = jsonpath(cards,'$..mblog.user.screen_name')
        # 微博id
        id_list = jsonpath(cards, '$..mblog.id')
        # 转发数
        reposts_count_list = jsonpath(cards, '$..mblog.reposts_count')
        # 评论数
        comments_count_list = jsonpath(cards, '$..mblog.comments_count')
        # 点赞数
        attitudes_count_list = jsonpath(cards, '$..mblog.attitudes_count')

        # 把列表数据保存成DataFrame数据
        df = pd.DataFrame(
	        {
		        '页码': [page] * len(id_list),
		        '微博id': id_list,
		        '微博作者': author_list,
		        '发布时间': time_list,
		        '微博内容': text2_list,
		        '转发数': reposts_count_list,
		        '评论数': comments_count_list,
	        	'点赞数': attitudes_count_list,
	        }
        )
        # 表头
        if os.path.exists(v_weibo_file):
            header = None
        else:
            header = ['页码','微博id','微博bid','微博作者','发布时间','微博内容','转发数','评论数','点赞数']
        # 保存到csv文件
        df.reset_index().to_csv(v_weibo_file,mode='a+',index=False,header=header,encoding='utf_8_sig')
        print('csv保存成功:{}'.format(v_weibo_file))

if __name__ == '__main__':
    # 爬取前几页
    max_search_page = 100
    # 爬取关键词
    search_keyword = 'RNAi'
    # 保存文件名
    v_weibo_file = '微博清单_{}_前{}页.csv'.format(search_keyword,max_search_page)
    # 如果csv文件存在，先删除之
    if os.path.exists(v_weibo_file):
        os.remove(v_weibo_file)
        print('微博清单存在,已删除：{}'.format(v_weibo_file))
    # 调用爬取微博函数
    get_weibo_list(v_keyword=search_keyword,v_max_page=max_search_page)
    # 数据清洗-去重
    df = pd.read_csv(v_weibo_file)
    # 删除重复数据
    df.drop_duplicates(subset=['微博bid'], inplace=True, keep='first')
    # 再次保存csv文件
    df.to_csv(v_weibo_file, index=False, encoding='utf_8_sig')
    print('数据清洗完成')

