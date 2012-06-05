db = [];

[db(1).time,db(1).files] = filetlist2('ostia_ice_*.nc','ostia_ice_YYYYMMDD.nc');


db(1).ncname = 'sea_ice_fraction';

[db(1).time,db(1).files] = filetlist2('ostia_sst_????????.nc','xxxxx_xxx_YYYYMMDD.xx');
db(1).ncname = 'analysed_sst';
db(1).variables  = 'tn';
db(1).names      = 'temp';
db(1).gridX      = 'ostia_sst_grid.nc#lonp';
db(1).gridY      = 'ostia_sst_grid.nc#lat';
db(1).gridZ      = 5;
db(1).rmse       = 'ostia_sst_20070111.nc#err';

db(1).get_name = @(t) ['ostia_sst_' gregd2(t,'YYYYMMDD') '.nc#analysed_sst'];


ap = {@assimparam_ostiasst, @assimparam_ostiaice };


fid = fopen('assim_obs2.init','w');


fprintf(fid,'# generated by %s\n\n',mfilename);

%time = mjd(2007,1,10):1:mjd(2007,1,31);
time = mjd(2007,2,1):1:mjd(2007,2,28);


diag = {'Hxf','Hxa','yo','invsqrtR','stddevHxf','stddevHxa'};
        
        
for n = 1:length(time);
    t = time(n);
    clear datat
    j = 0;
    
    for i = 1:length(ap);      
        tmp = ap{i}(t);
        
        if ~isempty(tmp) 
          j = j+1;
          datat(j) = tmp;
        end
        
    end

    date = gregd2(t,'YYYYMMDD');
    prefix = sprintf('Obs%03g.',n);
    putinitval(fid,[prefix 'time'],gregd2(time(n),'YYYY-MM-DDThh:mm:ss'));
    putinitval(fid,[prefix 'variables'],  {datat.variables});
    
    putinitval(fid,[prefix 'names'],      {datat.names});
    putinitval(fid,[prefix 'gridX'],      {datat.gridX});
    putinitval(fid,[prefix 'gridY'],      {datat.gridY});
    putinitval(fid,[prefix 'gridZ.const'],{datat.gridZ});

    putinitval(fid,[prefix 'value'],{datat.value});
    putinitval(fid,[prefix 'mask'] ,{datat.mask});
    putinitval(fid,[prefix 'rmse'] ,{datat.rmse});

    
    % diagnostics
    prefix = sprintf('Diag%03g.',n);

    for j = 1:length(diag);
      val = {};
      for i = 1:length(datat);
        val{i} = datat(i).diag(diag{j});
      end    

      putinitval(fid,[prefix diag{j}],val);
    end
    
    
    putinitval(fid,[prefix 'path' ],sprintf('Analysis%03g/',n));
    putinitval(fid,sprintf('Analysis%03g.path',n),sprintf('Analysis%03g/',n));
    fprintf(fid,'\n#------------------------------------------------------------------------------------\n\n');
    
end


fclose(fid);


