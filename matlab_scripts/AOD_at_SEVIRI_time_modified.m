clc
clear
load SEVIRI_time.mat;
A=load ('Al_Khaznah_AERONET_Original');
fields = fieldnames(A);
Middle_time = cell(5,1);
[ind{1:20}] = deal(zeros(5000,1));
count = 0;

A.(fields{1})(:,46) = A.(fields{1})(:,7) .* (675/550) .^ A.(fields{1})(:,38);

for ii = 1 : length(A.(fields{1}))
    DOY = fix(A.(fields{1})(ii,3));
    index = find(round(abs(A.(fields{1})(ii,3) - DOY - SEVIRI_time)*1e7)/1e7 <= 0.25/48);
    if length(index) > 1
        count = count + 1;
        Middle_time{count} = ii;
        index = index(1);
    end
    A.(fields{1})(ii,3) = SEVIRI_time(index) + DOY;
end

A.(fields{1})(:,4:end-1) = [];

ind{1} = find(diff(A.(fields{1})(:,3))==0);

while isempty(ind{1}) ~= 1

for t = 2:20
ind{t} = find(diff(ind{t-1})==1);
end

emptyCell = find(cellfun(@isempty,ind),1);
a = ind{emptyCell-1};

if emptyCell == 2
    A.(fields{1})(a,4:end) = (A.(fields{1})(a,4:end) + A.(fields{1})(a+emptyCell-1,4:end));
else
    for t = emptyCell-2:-1:1
        a = ind{t}(a);
    end
    for ii = 1:emptyCell-1
        A.(fields{1})(a,4:end) = (A.(fields{1})(a,4:end) + A.(fields{1})(a+ii,4:end));
    end
end
    
A.(fields{1})(a,4:end) = A.(fields{1})(a,4:end) / emptyCell;

if length(a) == 1
    A.(fields{1})(a+1:a+emptyCell-1,:) = [];
else
    for jj = 1:length(a)
        ind{1} = find(diff(A.(fields{1})(:,3)) == 0);
        for t = 2:20
            ind{t} = find(diff(ind{t-1}) == 1);
        end
        a = ind{emptyCell-1};
        for t = emptyCell-2:-1:1
            a = ind{t}(a);
        end
        A.(fields{1})(a+1:a+emptyCell-1,:) = [];
    end
end

ind{1}=find(diff(A.(fields{1})(:,3)) == 0);

end


