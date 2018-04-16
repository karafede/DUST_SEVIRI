clear all
clc
list = ls('*.nc');
% Correct Projection
for i = 1:size(list,1)
    clear ncinfo varname
    ncinfo = ncinfo(list(i,:));
    varname = ncinfo.Variables.Name;
    SEVIRI_DUST = ncread(list(i,:),varname);
    SEVIRI_DUST = logical(SEVIRI_DUST);
    if size(SEVIRI_DUST,1) < 1500
        clear option
        option.ModelPixelScaleTag = [0.02;0.02;0];
        option.ModelTiepointTag = [348;149;0;55.3178;25.0586;0];
        option.GeogEllipsoidGeoKey = 7030;
        option.GeographicTypeGeoKey = 4326;
        option.GTCitationGeoKey = 'WGS84"';
        option.Nan = nan;
        filename = sprintf('%s.tif',list(i,1:end-3));
        geotiffwrite(filename,[],SEVIRI_DUST,8,option);
    else
        SEVIRI_DUST = SEVIRI_DUST(741:922,1082:1319,:);
        clear option
        option.ModelPixelScaleTag = [0.02;0.02;0];
        option.ModelTiepointTag = [119;91;0;53.9927;24.3104;0];
        option.GeogEllipsoidGeoKey = 7030;
        option.GeographicTypeGeoKey = 4326;
        option.GTCitationGeoKey = 'WGS84"';
        option.Nan = nan;
        filename = sprintf('%s.tif',list(i,1:end-3));
        geotiffwrite(filename,[],SEVIRI_DUST,8,option);
    end
end