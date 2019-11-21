from scipy.stats import mode
import pandas as pd
import numpy as np
      

train=pd.read_csv('Train.csv')
test=pd.read_csv('Test.csv')

train['source']='train'
test['source']='test'

data=pd.concat([train,test],ignore_index=True)

print("original_missing")
print(data.apply(lambda x: sum(x.isnull())))


data['Outlet_Size'].fillna(method='ffill',inplace=True)

data['Item_Weight'].fillna(data['Item_Weight'].mean(),inplace=True)

data['Item_Outlet_Sales'].fillna(data['Item_Outlet_Sales'].mean(),inplace=True)

data.apply(lambda x: sum(x.isnull()))

data['Item_Visibility']=data['Item_Visibility'].replace({0:data['Item_Visibility'].mean()})

print(data['Item_Fat_Content'].value_counts())
data['Item_Fat_Content'] = data['Item_Fat_Content'].replace({'LF':'Low Fat','reg':'Regular','low fat':'Low Fat'})
print(data['Item_Fat_Content'].value_counts())


from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler(feature_range=(-1,1)) 
scaled_values = scaler.fit_transform(data[['Item_MRP','Item_Outlet_Sales','Item_Visibility','Item_Weight']]) 
data.loc[:,['Item_MRP','Item_Outlet_Sales','Item_Visibility','Item_Weight']] = scaled_values    

print("final missing")
print(data.apply(lambda x: sum(x.isnull())))
data.to_csv("clean.csv")