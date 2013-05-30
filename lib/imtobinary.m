function watermark = imtobinary(str)

watermark = imread(str);
watermark = boolean(watermark);
watermark = double(watermark);
