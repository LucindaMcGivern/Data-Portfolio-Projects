#!/usr/bin/env python
# coding: utf-8

# In[1]:


import matplotlib.pyplot
import pandas
from sklearn.cluster import KMeans


# In[2]:


#import data
data = pandas.read_csv("C:/Users/User/OneDrive/Documents/Python Scripts/K Means/Customers.csv")


# In[3]:


#EDA

import seaborn 

data.describe()


# In[4]:


import warnings
warnings.filterwarnings("ignore")

#summarise numerical characteristics of datasets

num_cols = ['Age', 'Income', 'Index']

for i in num_cols: 
    matplotlib.pyplot.figure()
    seaborn.distplot(data[i])


# In[5]:


#kde plots by Gender

seaborn.displot(data.reset_index(drop=True), x='Index', kind="kde", hue='Sex')
seaborn.displot(data.reset_index(drop=True), x='Age', kind="kde", hue='Sex')
seaborn.displot(data.reset_index(drop=True), x='Income', kind="kde", hue='Sex')




# In[6]:


#boxplots 
num_cols = ['Age', 'Income', 'Index']

for i in num_cols: 
    matplotlib.pyplot.figure()
    seaborn.boxplot(data = data, x='Sex', y= data[i])


# In[7]:


#customers seem to be majority female 
data['Sex'].value_counts(normalize = True)


# In[8]:


#scatterplot

seaborn.scatterplot(data=data, x = 'Income', y = 'Index')


# In[9]:


#there appear to be about ~5 clusters

#let's do this for all pairs of variables
#data = data.drop('CustomerID', axis = 1)

seaborn.pairplot(data=data, hue='Sex')


# In[10]:


#data mean values grouped by Sex

data.groupby(['Sex'])[num_cols].mean()


# In[11]:


#correlations

seaborn.heatmap(data.groupby(['Sex']).corr(), annot=True)


# In[12]:


# K-Means Clustering

km0 = KMeans()


# In[13]:


km0.fit(data[['Income']])


# In[14]:


km0.labels_


# In[15]:


data['Income Labels'] = km0.labels_
data.head()


# In[16]:


#univariate analysis around this first cluster

data['Income Labels'].value_counts()


# In[17]:


#distance between centroids
km0.inertia_


# In[18]:


#Elbow Method 

clinertia = []

for i in range(1,11):
    KM = KMeans(n_clusters=i)
    KM.fit(data[['Income']])
    clinertia.append(KM.inertia_)


# In[19]:


matplotlib.pyplot.plot(range(1,11), clinertia)


# In[20]:


#elbow appears to turn at 3 


# In[21]:


# K-Means Clustering with 3 clusters

km1 = KMeans(n_clusters=3)
km1.fit(data[['Income']])
data['Income Labels'] = km1.labels_
data['Income Labels'].value_counts()


# In[22]:


data.groupby('Income Labels')[num_cols].mean()


# In[23]:


# K-Means Clustering, Bivariate 

km2 = KMeans()
km2.fit(data[['Income', 'Index']])
data['Income and Index Labels'] = km2.labels_


# In[ ]:





# In[24]:


#Elbow Method 

clinertia2 = []

for i in range(1,11):
    KM2 = KMeans(n_clusters=i)
    KM2.fit(data[['Income', 'Index']])
    clinertia2.append(KM2.inertia_) 


# In[25]:


matplotlib.pyplot.plot(range(1,11), clinertia2)


# In[26]:


# Bivariate K-Means Clustering with 5 clusters

km3 = KMeans(n_clusters=5)
km3.fit(data[['Income', 'Index']])
data['Income and Index Labels'] = km3.labels_
data['Income and Index Labels'].value_counts()


# In[27]:


clustercentres = pandas.DataFrame(km3.cluster_centers_)
clustercentres.columns = ['x', 'y']


# In[28]:


matplotlib.pyplot.scatter(x = clustercentres['x'], y = clustercentres['y'], c = 'red')
seaborn.scatterplot(data=data, x='Income', y='Index', hue = 'Income and Index Labels')


# In[29]:


#by sex 
pandas.crosstab(data['Income and Index Labels'], data['Sex'], normalize = 'index')


# In[30]:


# descriptive statistics by cluster 
data.groupby('Income and Index Labels')[num_cols].mean()


# In[31]:


#Scale Data 
from sklearn.preprocessing import StandardScaler


# In[32]:


#initialize 
scl = StandardScaler()


# In[34]:


#K-Means clustering, multivariate
multidata = pandas.get_dummies(data)


# In[37]:


multidata.head()


# In[38]:


multidata = multidata[['Income', 'Index', 'Age', 'Sex_Male']]


# In[39]:


multidata = scl.fit_transform(multidata)


# In[40]:


clinertia3 = []

for i in range(1,11):
    KM3 = KMeans(n_clusters=i)
    KM3.fit(multidata)
    clinertia3.append(KM3.inertia_) 
    


# In[41]:


matplotlib.pyplot.plot(range(1,11), clinertia3)


# In[ ]:




