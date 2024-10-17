%Initialising the foreground detector to 3 Gaussian models and training
%frames of 50(first 50 frames)
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);

%Read the videoframe to the workspace
videoReader = VideoReader('street2.mp4');

%Loop to read all the frames in given video
for i = 1:150
    frame1 = readFrame(videoReader); % read the next video frame
    frame=imresize(frame1,[850,850]);%Resizing all the video frames to same size
    foreground = step(foregroundDetector, frame);
end

%Computing the number of vehicles in first video frame
%figure; imshow(frame); title('Video Frame');
%figure; imshow(foreground); title('Foreground');

se = strel('rectangle', [50,50]);%Defining structuring element
filteredForeground = imdilate(foreground, se);%fill in the small holes
se1=strel('rectangle',[80,80]);%Defining structuring element
filteredForeground = imerode(filteredForeground, se1);%removing small objects
%figure; imshow(filteredForeground); title('Clean Foreground');

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 500);%Defining blob of minimum area of 500 pixels
bbox = step(blobAnalysis, filteredForeground);


%Displaying number of cars in each videoframe
numCars = size(bbox, 1);
result = insertText(frame, [10 10], numCars, 'BoxOpacity', 1, ...
    'FontSize', 14);
%figure; imshow(result); title('Detected Cars');

%Computing vehicles in rest of the video frames
videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
se = strel('rectangle', [50,50]); % morphological filter for noise removal

while hasFrame(videoReader)

    frame1 = readFrame(videoReader); % read the next video frame
    frame = imresize(frame1,[850,850]);
    % Detect the foreground in the current video frame
    foreground = step(foregroundDetector, frame);

    % Use morphological opening to remove noise in the foreground
    filteredForeground = imdilate(foreground, se);
    se1=strel('rectangle',[80,80]);
   filteredForeground = imerode(filteredForeground, se1);

    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    bbox = step(blobAnalysis, filteredForeground);

    % Draw bounding boxes around the detected cars
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');

    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);

    step(videoPlayer, result);  % display the results
end