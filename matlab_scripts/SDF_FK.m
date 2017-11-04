clc
clear

[BTDref{1:96}] = deal(zeros(1500));

% for t = 17:31
    count = 0;
    for k = 1:4
        A1=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T07_20150402','_P',num2str(k),'.mat'));
        A2=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T09_20150402','_P',num2str(k),'.mat'));
        fields1=fieldnames(A1);
        fields2=fieldnames(A2);
       % if t == 17
        if t == 1
            for ii = 1:24
                count = count + 1;
                BTDref{count} = A2.(fields2{1})(:,:,ii) - A1.(fields1{1})(:,:,ii);
            end
        else
            for ii = 1:24
                count = count + 1;
                BTD108_087 = A2.(fields2{1})(:,:,ii) - A1.(fields1{1})(:,:,ii);
                BTDref{count} = max(cat(3,BTDref{count},BTD108_087),[],3);
            end
        end
    end
% end



save ('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\BTDref', 'BTDref')

load ('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\;
load \\10.106.67.26\matlab-data\EUMETSAT\T09\T09_20130101_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T07\T07_20130101_P3;

BT108 = T09_P3(:,:,1);
BT120_BT108 = T10_P3(:,:,1) - T09_P3(:,:,1);
BT108_BT087 = T09_P3(:,:,1) - T07_P3(:,:,1);
BTD108_087anom = BT108_BT087 - BTDref{49};

Dust = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
