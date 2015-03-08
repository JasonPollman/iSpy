% Jason Pollman
% ITCS-3134-001

function [r, c] = i_spy (Target, Source) % Target = object_im, % Source = big_im

  Target = rgb2gray(im2single(Target)); % Since all source images will be color, we can speed up the search by reducing size of 3rd dimension.
  Source = rgb2gray(im2single(Source));

  ts = size(Target); % Get the size of the images
  ss = size(Source);

  r = -1; c = -1; % Set initial return values

  match1 = find(Source == Target(1)); % Find all indices where the source's pixel value == the target's *first* pixel value

  for i = 1 : numel(match1) % Loop through all the first pixel matches

    [r, c] = ind2sub(ss, match1(i)); % Convert i to subscripts to query source image
    d = [r, c] - 1; % Must adjust for i...

    % If we are within the source's index range, select from the source image d + the size of the target image...
    % ...if this sampling == the target image, we've found the target image — so break the loop and return r, c.
    if isequal(d + ts <= ss, [1, 1]) && isequal(Target, Source(d(1) + (1 : ts(1)), d(2) + (1 : ts(2)))) break; end
    
    r = -1; c = -1; % Reset r, c so if the image isn't found, the function will return these values.

  end

end % End i_spy