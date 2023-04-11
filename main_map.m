function finalmap1=main_map(f1,f2)
%%
[row,column]=size(f1);

filter=pyramid_filter;

f11=downsample(f1,filter);
f22=downsample(f2,filter);

%%
p=5; 
for k=1:p

    blur1{k} = guidedfilter(f1,f1, k, 0.3);
    blur2{k} = guidedfilter(f2,f2, k, 0.3);

    D1{k}=f1-blur2{k}; 
    D2{k}=f2-blur1{k};
    D3{k}=calcFocusMeasure_new(D1{k}, 5, 'EOL');% 5
    D4{k}=calcFocusMeasure_new(D2{k}, 5, 'EOL'); 

end
%%
for k=1:p

    blur1{k} = guidedfilter(f11,f11, k, 0.3);
    blur2{k} = guidedfilter(f22,f22, k, 0.3);

    Q1{k}=f11-blur2{k}; 
    Q2{k}=f22-blur1{k};
    Q3{k}=calcFocusMeasure_new(Q1{k}, 5, 'EOL');
    Q4{k}=calcFocusMeasure_new(Q2{k}, 5, 'EOL'); 

end
%%
for k=1:p
    odd = 2*size(Q3{k}) - size(D3{k});
    B3{k}= upsample(Q3{k},odd,filter);
    B4{k}= upsample(Q4{k},odd,filter);
end
%%
map1=zeros(row,column);
map2=zeros(row,column);
for k=1:p         
    map1=map1+B3{k};  map2=map2+B4{k};
end   

mapp1=abs(map1>map2);

%%
map3=zeros(row,column);
map4=zeros(row,column);

for k=1:p         
    map3=map3+D3{k};  map4=map4+D4{k};
end   

mapp2=abs(map3>map4);

%%
new_map1=zeros(row,column);
for i=1:row
    for  j=1:column  
        if mapp2(i,j)==1 && mapp1(i,j)==0
            new_map1(i,j)=0;
        elseif mapp2(i,j)==0 && mapp1(i,j)==1
            new_map1(i,j)=0;
         elseif  mapp1(i,j)==mapp2(i,j)
             new_map1(i,j)=mapp1(i,j);

        end
    end
end   

%%
ratio=0.03;%0.015 
area=ceil(ratio*row*column);
tempMap1=bwareaopen(mapp2,area);
tempMap2=1-tempMap1;
tempMap3=bwareaopen(tempMap2,area);
midmap1=1-tempMap3;

 %%
 r =5; eps = 0.3;
 FF = midmap1.*f1 + (1-midmap1).*f2;
 midmap1 = guidedfilter(FF,midmap1, r, eps);

%%
w=round(row*column*0.0001);  %%round
 if mod(w,2)==1
     window_size=w;
 else
     window_size=w+1;
 end
 finalmap1 = majority_consist_new(midmap1,window_size);