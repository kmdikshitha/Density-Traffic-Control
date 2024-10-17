clc;
clear;
close;

%Handle to store all the files of jpg format in the given folder
files = dir('*.jpg');
%Array to store no. of vehicles in each street
a = [];
%variable to store the street number
pos = 1;
%Array to store sorted array of 'a'
b = [];
%iteration variable 
j=1;
for i = 1:numel(files)
    
i1=imread(files(i).name); %Reads the image
i=imresize(i1,[1000,1000]);%Resize the image to 1000*1000 pixels    %expanding is preferred over compressing
i=rgb2gray(i); %convert RGB image to GrayScale image    %most functions work on grayscale image

%figure; imshow(i); title('Street');

se=strel('disk',50);  % Defining the structuring element
background = imopen(i,se);  %opens the image morphologically

%figure;imshow(background);title('Background');

I2 = i - background;  %Subtracting background inorder to get foreground
%figure;imshow(I2);title('fg');
I3 = imadjust(I2);%saturates the image   %Adjust the image to brighten the foreground
%figure;imshow(I3);title('adjusted fg');
 
 i=imbinarize(I3);  %Binarize the adjusted image
i = bwareaopen(i,50);%to remove noise   %Morphologically open the image to remove small holes in binary image
 %figure; imshow(i); title('binarised');

se = strel('rectangle',[4,15]);%4,15  %Defining the structuring element
filteredForeground= imerode(i,se);  %Removing small objects 
se1 = strel('rectangle',[50,50]);%50,50  %Defining the structuring element
filteredForeground= imdilate(filteredForeground,se1);  %fills the small holes
%%figure;imshow(filteredForeground);title('clean fg');


blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 500);%100 for dense areas 150 is original value 80 for street-3
     %Defining blob of min area 500 pixels
bbox = step(blobAnalysis, filteredForeground);  % Generating Boundingbox across detected blob


%Display number of vehicles found in image
numCars = size(bbox, 1)
result = insertText(i1,[10 10], numCars, 'BoxOpacity', 1, ...
    'FontSize', 14);
figure; imshow(result); title('Detected Cars');


%Store vehicles from each street in array    
a(j) = numCars;
j = j+1;


end

%to find the densest street
densest = a(1);
for k = 2:4
   if(a(k)>a(k-1))
       densest = a(k);
       pos = k;
   end
end
%Printing the array of number of vehicles and the max number of vehicles
a
densest

%printing the output
fprintf("\n Street %i = green \n ", pos);

%sorting the array in priority order
b=sort(a,'descend');
b

% fprintf("\n Street %i = green \n ", b(1));
% fprintf("\n Street %i = yellow \n ", b(2));
% fprintf("\n Street %i = red \n ", b(3));
% fprintf("\n Street %i = red \n ", b(4));


%printing the priority order
for k = 1:4
   for j = 1:4
       if(a(j)==b(k))
         fprintf("\n Street %i has %i cars ",j,b(k)); 
       end
   end
   if(k==1)
      fprintf("\n Light --> Green \n "); 
   
   elseif(k==2)
      fprintf("\n Light --> Yellow \n "); 
   
   else
      fprintf("\n Light --> Red \n "); 
   end
end
