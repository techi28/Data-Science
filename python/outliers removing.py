#!/usr/bin/env python
# coding: utf-8

# In[6]:


def mean_and_std(sample):
    #create variables for mean and std from a sample
    mean = np.mean(sample) #COMPL THIS LINE
    std = np.std(sample)#COMPLETE THIS LINE
    return mean, std 


# In[7]:


def validation(sample, cutoff):
    #get mean and std from the previous function and return the new mean
    #with precision of 2 decimal points
    while True:
        mean, std = mean_and_std(sample)
                                      #COMPLETE THIS LINE
        outliers = 0
        for x in sample:
            if  x >  (mean +  std*cutoff) or x < (mean -  std*cutoff):     #COMPLETE THIS CONDITION:
                print(x)
                sample.remove(x) 
                outliers += 1               
    
        if outliers == 0:
            break
    new_mean, new_std =  mean_and_std(sample) #COMPLETE THIS LINE
    return round(new_mean,2)
    


# In[8]:


import math
import numpy as np
sample = [1,2,3,5,4,0.9,26,31,420,3,4,2,7]
cutoff = 2


# In[9]:


#mean_and_std(sample)
mean, std = mean_and_std(sample)

print(mean,std)
print(sample)


# In[10]:


#validation(sample, cutoff)
mean=  validation(sample, cutoff)

print(mean)
print(sample)


# import numpy as np

# In[11]:


def mean_and_std(sample):
    mean = np.mean(sample)
    std=np.std(sample)
    return mean, std


# In[12]:


def validation(sample,cutoff):
    while True: 
        mean, std = mean_and_std(sample)
        outliers = 0
        for x in sample:
            if x > (mean+std*cutoff) or x <(mean-std*cutoff):
                print(x)
                sample.remove(x)
                outliers +=1
        if outliers ==0:
            break
    new_mean, new_std = mean_and_std(sample)
    return round(new_mean,2)


# In[13]:


sample = [1,2,3,5,4,0.9,26,31,420,3,4,2,7]
cutoff = 2


# In[14]:


mean_and_std(sample)


# In[15]:


validation(sample, cutoff)


# In[ ]:





# In[ ]:




