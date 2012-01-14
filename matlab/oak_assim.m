function E = oak_assim(E,n,obs);

Nens = size(E,2);

if ~isa(obs,'DataSetInitFile')

  yo = obs(n).yo;
  iR = spdiag(1./(obs(n).RMSE.^2));

  % extract observed values from ensemble

  for j=1:Nens
    Hx = obs(n).H(E(:,j));

    if (j==1)
      HE = zeros([numel(Hx) Nens]);
    end

    HE(:,j) = Hx;
  end

  %keyboard
  [inc,info] = ensemble_analysis(full(E),HE,yo,iR);
  E(:,:) = E * info.A;

else
  'fortran'
  initfile = obs.filename;
  init = InitFile(initfile);
  masks = mask(E);
  
  exec = '/home/abarth/Assim/OAK/assim-gfortran-single';

  fmt = get(init,'ErrorSpace.init');
  path = get(init,'ErrorSpace.path');
  Eic = SVector(path,fmt,masks,1:Nens);
  %Eic(:,:) = full(E);
  Eic(:,:) = E;
  %save(E,path,fmt);
  
  syscmd('%s %s %d',exec,initfile,n);

  path = realpath(get(init,sprintf('Diag%03g.path',n)));
  Eaname = get(init,sprintf('Diag%03g.Ea',n));

  E = SVector(path,Eaname,masks,1:Nens); 
end