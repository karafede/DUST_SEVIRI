clc
clear
load X:\EUMETSAT\T10\T10_20120226_P3;
load X:\EUMETSAT\T09\T09_20120226_P3;
load X:\EUMETSAT\T07\T07_20120226_P3;

Red = T10_P3(:,:,17) - T09_P3(:,:,17);
Green = T09_P3(:,:,17) - T07_P3(:,:,17);
Blue = T09_P3(:,:,17);

Red = mat2gray(Red,[-4 2]);
Green = mat2gray(Green,[0 15]);
Green = Green.^(1/2.5);
Blue = mat2gray(Blue,[261 289]);
RGB = cat(3,Red,Green,Blue);
image(RGB)


