#!/usr/bin/env python
# coding: utf-8

# In[78]:


import csv
import requests
from bs4 import BeautifulSoup


# In[79]:


# tell BeautifulSoup, requests where to get data
amz = 'https://www.amazon.ca/Corgis-Monthly-Calendar-Bright-Day/dp/B0BQ3ZKL25/ref=sr_1_8?crid=Z6CLQ5CE3915&keywords=corgi&qid=1701229444&sprefix=corgi%2Caps%2C167&sr=8-8'

# user agent
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

web = requests.get(amz, headers = headers)

#pull page content
content1 = BeautifulSoup(web.content, "html.parser")
content1read = BeautifulSoup(content1.prettify(), "html.parser") 


# In[80]:


#pull content title
pagetitle = content1read.find(id='productTitle').get_text()

#too much whitespace
productname = pagetitle.strip()

print(productname)


# In[60]:


#pull content price
pageprice = content1read.find(id='tp_price_block_total_price_ww').get_text()
clean_price = pageprice.strip()
productprice = clean_price.split(' ', 1)[0]

print(productprice)


# In[81]:


#pull date 
import datetime

record = datetime.date.today()

print(record)


# In[82]:


#create csv

colnames = ['Product Name', 'Product Price', 'Date']

#make a list
csv_out = [productname, productprice, record]

#write csv
with open('amzscrape.csv', 'w', newline='', encoding='UTF8') as m:
    filewrite = csv.writer(m)
    filewrite.writerow(colnames)
    filewrite.writerow(csv_out)
    


# In[83]:


# add data to csv 
with open('amzscrape.csv', 'a+', newline='', encoding='UTF8') as m:
    filewrite = csv.writer(m) 
    filewrite.writerow(csv_out)


# In[87]:


def amzpricecheck():
    # tell BeautifulSoup, requests where to get data
    amz = 'https://www.amazon.ca/Corgis-Monthly-Calendar-Bright-Day/dp/B0BQ3ZKL25/ref=sr_1_8?crid=Z6CLQ5CE3915&keywords=corgi&qid=1701229444&sprefix=corgi%2Caps%2C167&sr=8-8'

    # user agent
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

    web = requests.get(amz, headers = headers)

    #pull page content
    content1 = BeautifulSoup(web.content, "html.parser")
    content1read = BeautifulSoup(content1.prettify(), "html.parser") 
    
    #pull content title
    pagetitle = content1read.find(id='productTitle').get_text()

    #too much whitespace
    productname = pagetitle.strip()
    
    #pull content price
    pageprice = content1read.find(id='tp_price_block_total_price_ww').get_text()
    clean_price = pageprice.strip()
    productprice = clean_price.split(' ', 1)[0]
    
    #date
    import datetime
    record = datetime.date.today()
    
    
    #create csv
    import csv

    colnames = ['Product Name', 'Product Price', 'Date']

    #make a list
    csv_out = [productname, productprice, record]
        
    # add data to csv 
    with open('amzscrape.csv', 'a+', newline='', encoding='UTF8') as m:
        filewrite = csv.writer(m) 
        filewrite.writerow(csv_out)


# In[88]:


import time
while(True):
    amzpricecheck()
    time.sleep(43200)


# In[ ]:




