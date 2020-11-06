function n = datenumRobust(varargin)
% Works the same as the Matlab function datenum.
% However, in certain versions of Matlab the datenum function fails every
% second call. That is why the last few lines in this function contain a
% 'try catch'. In addition, this function checks more carefully whether the
% provided dateformat matches with the date.

% Last modified: 11/08/2011, Cyriel de Jong, KYOS Energy Consulting
  
   
  % Determine date separator for the date
  d1 = varargin{1,1};
  if isempty(d1) == 0
      
    d1 = char(d1(1,1));
    datetype = 'a';  
    i = 1;
    while i <= length(d1)
      if strcmp(d1(i), '/') == 1 
        datetype = '/';
        i = 1e10;
      elseif strcmp(d1(i), '-') == 1
        datetype = '-';
        i = 1e10;
      end
      i = i + 1;
    end
  
    if i > 1e10
      % Determine date separator for the dateformat and adjust if needed
      d2 = char(varargin{1,2});
      i = 1;
      while i <= length(d2)
        if strcmp(d2(i), '/') == 1 && strcmp(datetype, '/') == 0
          d2(i) = datetype;
        elseif strcmp(d2(i), '-') == 1 && strcmp(datetype, '-') == 0
          d2(i) = datetype;
        end
        i = i + 1;
      end
      varargin{1,2} = d2;
    end
    
  end
      

  try 
    n = datenum(varargin{:});
  catch 
    n = datenum(varargin{:});
  end
end
