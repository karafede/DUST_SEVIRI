x= longGalena(1,:); % should be vector
y=(flipud(latGalena(:,1)))';
altitude = 800;
alphaMatrix = ones(size(band2clw));
index2=waterGalena==0; % NaN pixels
alphaMatrix(index2)=0; % NaN pixels transparent
cLimLow=1; % min of the data
cLimHigh=64; % max of the data
 
filenamedaily=['dailyclassified_2013',num2str(month,'%02d'),num2str(day,'%02d'),'.mat'];
filenamedailypng=['dailyclassified_2013',num2str(month,'%02d'),num2str(day,'%02d'),'.m','.png'];
filenamedailykml=['dailyclassified_2013',num2str(month,'%02d'),num2str(day,'%02d'),'.kml'];
 output = ge_imagesc(x,y,band2clw,...      %band2clw is my data
 'imgURL',filenamedailypng,...
 'cLimLow',cLimLow,...
 'cLimHigh',cLimHigh,...
 'altitude',altitude,...
 'altitudeMode','absolute',...
 'colorMap',mycmap,...
 'alphaMatrix',alphaMatrix);
         
labels={'water','Ice+water','ice','cloud'}; % if colarbar is custom defined
       
output2 = ge_colorbar(x(end),y(1),band2clw,...   % if colarbar is custom defined
 'numClasses',3,...
 'cLimLow',cLimLow,...
 'cLimHigh',cLimHigh,...
 'cBarFormatStr','%+07.4f',...
 'name','Colorbar',...
 'labels',labels,...
 'colorMap',mycolormap, 'showNumbersColumn',false);

ge_output(filenamedailykml,[output2 output],'name',filenamedailykml);
FILE_NAME=['dailyclassified_2013',num2str(month,'%02d'),num2str(day,'%02d')];
north=65.079593;
south=63.912995;
east=-154.864839;
west=-159.936446;
k = kml([FILE_NAME, '.m.kml']);
k.overlay(west,east,south,north, 'file',[FILE_NAME '.m.png']);
k.run;

















k = kml([FILE_NAME, '.m.kml']);
k.overlay(west,east,south,north, 'file',[FILE_NAME '.m.png']);
k.run;
