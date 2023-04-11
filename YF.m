function cp=YF(matrix,v);
[row,column]=size(matrix);
cp=zeros(row,column);
window_wide=5;
spread=(window_wide-1)/2;
matrix_en=padarray(matrix,[spread spread],'symmetric');
for i=1:row
    for j=1:column
        cp(i,j)=matrix_en(i+2,j+2)+(-v)*matrix_en(i+2,j)+0.5*(-v)*(-v+1)*matrix_en(i+2,j);
    end
end
