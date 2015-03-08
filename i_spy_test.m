% Jason Pollman
% ITCS-3134-001

function i_spy_test (pathToTrain, fixOrdering)

  t = 0;
  t = t + i_spy_test_set(pathToTrain, 1, fixOrdering);
  t = t + i_spy_test_set(pathToTrain, 2, fixOrdering);
  t = t + i_spy_test_set(pathToTrain, 3, fixOrdering);

  fprintf('Total Time, All Sets: %2.3fs\n\n', t);

end

function [totalTime] = i_spy_test_set (dirName, set, fixOrdering)
  
  files     = dir(dirName);
  setImages = {};
  imNums    = {};
  answers   = {};

  for i = 1 : length(files)

    % Regexp to find the Big Image
    bigImgF  = regexp(files(i).name, strcat('set', num2str(set), '_big_im.*'), 'match');

    % Grab the correct values for this set
    answersF  = regexp(files(i).name, strcat('set', num2str(set), '_gt.csv'), 'match');

    % so we don't get '.' || '../' || 'Thumbs.db', etc
    objImageF = regexp(files(i).name, strcat('set', num2str(set), '_object_im.*'), 'match');

    if(numel(bigImgF) == 1) % We got the Big Image...
      BigImg = imread(strcat(dirName, '/', bigImgF{:}));

    elseif(numel(answersF) == 1)
      answers = [answers, csvread(strcat(dirName, '/', answersF{:}))];

    elseif(numel(objImageF) == 1) % We got an Object Image
      imNums    = [imNums, files(i).name];
      img = imread(strcat(dirName, '/', objImageF{:}));
      if(numel(img) > 0)
        setImages = [setImages; { img }];
      end;

    end % End if block

  end % End for loop

  totalTime = 0; % Computer Total i_spy Call Time

  fprintf('------------------------------------------ SET %d ------------------------------------------\n', set)

  for i = 1 : numel(setImages) % Call i_spy on all 'setImages'

    imTime = tic;
    [r, c] = i_spy(setImages{i}, BigImg);

    t = toc(imTime);
    totalTime = totalTime + t;

    ii = i; % Must adjust for numeric ordering in file system and natural ordering in answer's CSV...
    if(fixOrdering)
      if (i == 1) ii == 1;
      elseif (i == 2) ii = 10;
      else ii = i - 1;
      end
    end

    coords = [answers{:}(ii, 2) answers{:}(ii, 1)];
    if isequal([r, c], coords)
      x = 'Yes';
    else 
      x = 'No';
    end
 
    fprintf('Image `%s`\t -> Returned Col: %4d, Row: %4d (%2.3fs) ... Correct? %s \n', imNums{i}, c, r, t, x);

  end

  fprintf('\nTotal Time, Set %d: %2.3fs\n', set, totalTime);

end % End i_spy_test
