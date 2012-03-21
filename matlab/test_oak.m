

tests = {...
   'test_svector',...
   'test_fortranwrite',...
   'test_initfile',...
   'test_model',...
   'test_runoak',...
   'test_runoak3',...    
   'test_oakassim',...
   'test_oakassim_anam',...
   'test_oakassim_anam_empir',...
   'test_oakassim_error_modes'...
        };
%   'test_runoak2',...

for iindex=1:length(tests);
 
  try
    eval(tests{iindex});
    colordisp('  OK  ','green');
  catch
    colordisp(' FAIL ','red');
    tests{iindex}
    disp(lasterr)
  end
end


