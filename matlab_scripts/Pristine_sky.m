clc
clear

[TB108dfe{1:96}] = deal(zeros(1500));

for t = 29:31
    count = 0;
    for k = 1:4
        A=load(strcat('X:\EUMETSAT\T09\T09_201201',num2str(t),'_P',num2str(k),'.mat'));
        fields=fieldnames(A);
        for ii = 1:24
            count = count + 1;
            TB108dfe{count} = max(cat(3,TB108dfe{count},A.(fields{1})(:,:,ii)),[],3);
        end
    end
end


for t = 1:25
    count = 0;
    for k = 1:4
        if t < 10
            A=load(strcat('X:\EUMETSAT\T09\T09_2012020',num2str(t),'_P',num2str(k),'.mat'));
        else
            A=load(strcat('X:\EUMETSAT\T09\T09_201202',num2str(t),'_P',num2str(k),'.mat')); 
        end
        fields=fieldnames(A);
        for ii = 1:24
            count = count + 1;
            TB108dfe{count} = max(cat(3,TB108dfe{count},A.(fields{1})(:,:,ii)),[],3);
        end
    end
end

save ('TB108dfe','TB108dfe')


