function output = time_series(startdate,duration,row,column)
ll=startdate-1;
for t = 1:duration
    ll=ll+1;
for k = 1:4
    F = strcat('\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_201202',num2str(ll),'_P',num2str(k),'.mat');
    A=load(F);
    fields=fieldnames(A);
    if k==1 && t==1
        B = A.(fields{1});
    else
        B = cat(3,B,A.(fields{1}));
    end
end
end
m = size(B,3);
output=reshape(B(row,column,:),m,1);
cc=4*15*24*duration-15;
oo=0:15:cc;
plot(oo,output)
end
